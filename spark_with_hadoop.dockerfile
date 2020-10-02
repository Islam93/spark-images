FROM ubuntu:20.10

RUN apt update \
    && apt install -y wget curl \
    && apt install -y openjdk-11-jdk \
    && apt remove scala-library scala \
    && wget http://scala-lang.org/files/archive/scala-2.13.3.deb \
    && dpkg -i scala-2.13.3.deb \
    && wget -O sbt-1.3.13.deb https://bintray.com/sbt/debian/download_file?file_path=sbt-1.3.13.deb \
    && dpkg -i sbt-1.3.13.deb \
    && apt update \
    && apt install scala sbt \
    && apt clean \
    && rm scala-2.13.3.deb sbt-1.3.13.deb

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

ARG SPARK_VERSION=3.0.1
ARG HADOOP_VERSION=3.2
ENV SPARK_NAME spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

ENV SPARK_DOWNLOAD_PATH http://apachemirror.wuchna.com/spark/spark-${SPARK_VERSION}/${SPARK_NAME}.tgz
RUN curl ${SPARK_DOWNLOAD_PATH} | tar xzf - -C /opt

ENV SPARK_DIR /opt/${SPARK_NAME}
ENV SPARK_HOME /usr/local/spark
RUN ln -sf ${SPARK_DIR} ${SPARK_HOME}

ENV PATH ${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin

ADD ./conf/spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf
ADD ./entrypoint.sh /entrypoint

EXPOSE 4040 4040

WORKDIR ${SPARK_HOME}

ENTRYPOINT ["bash", "/entrypoint"]