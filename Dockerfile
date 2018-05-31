FROM dvoros/hadoop:HDP-3.0.0.0

ENV TEZ_VERSION tez-0.9.1.3.0.0.0-1634
ENV TEZ_HOME /usr/local/tez
ENV TEZ_CONF_DIR $TEZ_HOME/conf
ENV HADOOP_CLASSPATH ${TEZ_CONF_DIR}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*

RUN mkdir /usr/local/$TEZ_VERSION && curl -s http://public-repo-1.hortonworks.com/HDP/centos7/3.x/updates/3.0.0.0/tars/tez/$TEZ_VERSION.tar.gz > /tmp/$TEZ_VERSION.tar.gz
RUN tar -xzf /tmp/$TEZ_VERSION.tar.gz -C /usr/local/$TEZ_VERSION

RUN ln -s /usr/local/$TEZ_VERSION /usr/local/tez

RUN mkdir -p /usr/local/tez/share && curl -s http://public-repo-1.hortonworks.com/HDP/centos7/3.x/updates/3.0.0.0/tars/tez/$TEZ_VERSION-minimal.tar.gz > /usr/local/tez/share/tez.tar.gz

ENV PATH $PATH:$HADOOP_HOME/bin
RUN $BOOTSTRAP && hdfs dfsadmin -safemode leave \
  && hdfs dfs -mkdir -p /apps/tez \
  && hadoop fs -copyFromLocal /tmp/$TEZ_VERSION.tar.gz /apps/tez/tez.tar.gz

ADD tez-site.xml $TEZ_HOME/conf/
ADD mapred-site.xml $YARN_CONF_DIR/
