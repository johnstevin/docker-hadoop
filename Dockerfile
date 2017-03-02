FROM ubuntu:14.04
MAINTAINER Zhengbang Rong <stevin.john@qq.com>

WORKDIR /root

ADD ./sources.list /etc/apt/sources.list

RUN buildDeps='gcc make' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && apt-get install -y vim ssh \
    && apt-get install -y openjdk-8-jdk \
    && apt-get purge -y --auto-remove $buildDeps

# install hadoop 2.7.2
COPY ./build/hadoop-2.7.2.tar.gz /root/build/
RUN tar -xzvf /root/build/hadoop-2.7.2.tar.gz -C /root/build/ && \
    mv /root/build/hadoop-2.7.2 /usr/local/hadoop

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    HADOOP_HOME=/usr/local/hadoop \
    PATH=$PATH:$HADOOP_HOME/bin:$JAVA_HOME/bin

# test copy command
COPY ./build/composer.json /root/
VOLUME ["/root/build"]