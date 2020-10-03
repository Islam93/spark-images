FROM ubuntu:20.10

RUN apt update \
    && apt install -y wget curl \
    && apt install -y openjdk-11-jdk \
    && apt remove scala-library scala \
    && wget http://scala-lang.org/files/archive/scala-2.12.12.deb \
    && dpkg -i scala-2.12.12.deb \
    && wget -O sbt-1.3.13.deb https://bintray.com/sbt/debian/download_file?file_path=sbt-1.3.13.deb \
    && dpkg -i sbt-1.3.13.deb \
    && apt update \
    && apt install scala sbt \
    && apt clean \
    && rm scala-2.12.12.deb sbt-1.3.13.deb

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

ARG SPARK_VERSION=3.0.1
ARG HADOOP_VERSION=3.2.1

ENV SPARK_NAME spark-${SPARK_VERSION}-bin-without-hadoop
ENV HADOOP_NAME hadoop-${HADOOP_VERSION}

ENV SPARK_DOWNLOAD_PATH http://apachemirror.wuchna.com/spark/spark-${SPARK_VERSION}/${SPARK_NAME}.tgz
ENV HADOOP_DOWNLOAD_PATH http://apachemirror.wuchna.com/hadoop/common/stable/${HADOOP_NAME}.tar.gz
RUN curl ${SPARK_DOWNLOAD_PATH} | tar xzf - -C /opt \
    && curl ${HADOOP_DOWNLOAD_PATH} | tar xzf - -C /opt

ENV SPARK_DIR /opt/${SPARK_NAME}
ENV SPARK_HOME /usr/local/spark

ENV HADOOP_DIR /opt/${HADOOP_NAME}
ENV HADOOP_HOME /usr/local/hadoop

RUN ln -sf ${SPARK_DIR} ${SPARK_HOME} \
    && ln -sf ${HADOOP_DIR} ${HADOOP_HOME}

ENV PATH ${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin
#ENV SPARK_DIST_CLASSPATH $(hadoop classpath)
ENV SPARK_DIST_CLASSPATH '/usr/local/hadoop/etc/hadoop:/usr/local/hadoop/share/hadoop/common/lib/*:/usr/local/hadoop/share/hadoop/common/*:/usr/local/hadoop/share/hadoop/hdfs:/usr/local/hadoop/share/hadoop/hdfs/lib/*:/usr/local/hadoop/share/hadoop/hdfs/*:/usr/local/hadoop/share/hadoop/mapreduce/lib/*:/usr/local/hadoop/share/hadoop/mapreduce/*:/usr/local/hadoop/share/hadoop/yarn:/usr/local/hadoop/share/hadoop/yarn/lib/*:/usr/local/hadoop/share/hadoop/yarn/*'

ADD ./conf/spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf
ADD ./conf/metrics.properties ${SPARK_HOME}/conf/metrics.properties
ADD ./entrypoint.sh /entrypoint

EXPOSE 4040 4040

WORKDIR ${SPARK_HOME}

ENTRYPOINT ["bash", "/entrypoint"]