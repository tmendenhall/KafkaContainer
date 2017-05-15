FROM alpine:3.5
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
CMD wget http://mirror.cc.columbia.edu/pub/software/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz -O /tmp/zookeeper-3.4.6.tar.gz
WORKDIR /tmp
CMD tar -zxf zookeeper-3.4.6.tar.gz && mkdir -p /usr/local && mv zookeeper-3.4.6 /usr/local/zookeeper
CMD mkdir -p /var/lib/zookeeper
ADD zoo.cfg /usr/local/zookeeper/conf/zoo.cfg
EXPOSE 2181
