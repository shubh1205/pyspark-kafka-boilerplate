# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Spark dependencies
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
ARG spark_version="3.3.0"
ARG hadoop_version="3"
ARG openjdk_version="17"
ARG scala_version="2.12.10"
ARG kafka_version="3.3.2"

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}" \
    SCALA_VERSION="${scala_version}" \
    KAFKA_VERSION="${kafka_version}"

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    "openjdk-${openjdk_version}-jre-headless" \
    ca-certificates-java awscli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#AZURE
RUN apt-get update --yes && \
    apt-get install --yes curl gnupg && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Spark installation
WORKDIR /tmp
RUN wget -q --no-check-certificate "https://archive.apache.org/dist/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

RUN wget -q --no-check-certificate "https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz" && \
  tar xzf scala-$SCALA_VERSION.tgz -C /tmp/ && \
  mkdir /usr/local/scala-$SCALA_VERSION && \
  mv /tmp/scala-$SCALA_VERSION/* /usr/local/scala-$SCALA_VERSION && \
  rm -rf scala-$SCALA_VERSION.tgz 
ENV SCALA_HOME=/usr/local/scala-$SCALA_VERSION/bin

# Kafka instalation
RUN wget -q --no-check-certificate "https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_2.12-$KAFKA_VERSION.tgz" && \
  tar xzf kafka_2.12-$KAFKA_VERSION.tgz && \
  mkdir /usr/local/kafka_2.12-$KAFKA_VERSION && \
  mv /tmp/kafka_2.12-$KAFKA_VERSION/* /usr/local/kafka_2.12-$KAFKA_VERSION && \
  rm -rf kafka_2.12-$KAFKA_VERSION.tgz

WORKDIR /usr/local

# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH="${PATH}:${SPARK_HOME}/bin"

# Configure Kafka
ENV KAFKA=/usr/local/kafka_2.12-$KAFKA_VERSION
ENV PATH="${PATH}:${KAFKA}/bin"

RUN ln -s "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark && \
    # Add a link in the before_notebook hook in order to source automatically PYTHONPATH
    mkdir -p /usr/local/bin/before-notebook.d && \
    ln -s "${SPARK_HOME}/sbin/spark-config.sh" /usr/local/bin/before-notebook.d/spark-config.sh

# Configure IPython system-wide
COPY ipython_kernel_config.py "/etc/ipython/"
RUN fix-permissions "/etc/ipython/"

# Configure Kafka system-wide
RUN fix-permissions "/usr/local/kafka_2.12-$KAFKA_VERSION/"

# Create directory for Spark event logs and set permissions
RUN mkdir -p /tmp/spark-events && \
    chown -R $NB_UID /tmp/spark-events

# Add configuration for Spark History Server
RUN echo "spark.eventLog.enabled          true" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.eventLog.dir              file:///tmp/spark-events" >> ${SPARK_HOME}/conf/spark-defaults.conf && \
    echo "spark.history.fs.logDirectory   file:///tmp/spark-events" >> ${SPARK_HOME}/conf/spark-defaults.conf

# Python packages installation
COPY requirements.txt "/tmp/"
RUN pip install -r /tmp/requirements.txt

USER ${NB_UID}

# Install pyarrow
RUN mamba install --quiet --yes \
    'pyarrow' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

WORKDIR "${HOME}"
