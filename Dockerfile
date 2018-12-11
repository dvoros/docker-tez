FROM dvoros/hadoop:2.9.0

ENV TEZ_TGZ tez-0.9.1.tar.gz
ENV TEZ_HOME /usr/local/tez
ENV TEZ_CONF_DIR $TEZ_HOME/conf
ENV HADOOP_CLASSPATH ${TEZ_CONF_DIR}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*

COPY $TEZ_TGZ /tmp/
COPY tez-0.9.1-minimal.tar.gz /tmp/
RUN mkdir /usr/local/apache-tez-0.9.1-bin && tar -xzf /tmp/tez-0.9.1-minimal.tar.gz -C /usr/local/apache-tez-0.9.1-bin

RUN cd /usr/local && ln -s apache-tez-0.8.5-bin tez

ENV PATH $PATH:$HADOOP_HOME/bin
RUN $BOOTSTRAP && hdfs dfsadmin -safemode leave \
  && hdfs dfs -mkdir -p /apps/tez \
  && hadoop fs -copyFromLocal /tmp/$TEZ_TGZ /apps/tez/tez.tar.gz

RUN rm -f /tmp/$TEZ_TGZ /tmp/tez-0.9.1-minimal.tar.gz

ADD tez-site.xml $TEZ_HOME/conf/
ADD mapred-site.xml $YARN_CONF_DIR/
