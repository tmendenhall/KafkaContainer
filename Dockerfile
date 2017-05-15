FROM alpine:3.5
#install bash
RUN apk add --no-cache bash=4.3.46-r5

# install Java here add environment variable for JAVA_HOME
# based on https://github.com/docker-library/openjdk/blob/master/8-jre/alpine/Dockerfile
# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u121
ENV JAVA_ALPINE_VERSION 8.121.13-r0

RUN set -x \
	&& apk add --no-cache \
		openjdk8-jre="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

#Install zookeeper
WORKDIR /tmp
RUN wget http://mirror.cc.columbia.edu/pub/software/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz -O zookeeper-3.4.6.tar.gz
RUN tar -zxf zookeeper-3.4.6.tar.gz && mv zookeeper-3.4.6 /usr/local/zookeeper
RUN mkdir -p /var/lib/zookeeper
ADD zoo.cfg /usr/local/zookeeper/conf/zoo.cfg

#Install the Kafka Broker
# busybox wget does not support https
RUN wget http://apache.claz.org/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz -O kafka_2.12-0.10.2.1.tgz
RUN tar -zxf kafka_2.12-0.10.2.1.tgz && mv kafka_2.12-0.10.2.1 /usr/local/kafka
RUN mkdir /tmp/kafka-logs
VOLUME /tmp

#default zookeeper and kafka port
EXPOSE 2181
EXPOSE 9092
