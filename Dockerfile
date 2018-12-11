FROM dvoros/hadoop:3.1.1

ENV TEZ_TGZ tez-0.9.1.tar.gz
ENV TEZ_MINIMAL_TGZ tez-0.9.1-minimal.tar.gz
ENV TEZ_HOME /usr/local/tez
ENV TEZ_CONF_DIR $TEZ_HOME/conf
ENV HADOOP_CLASSPATH ${TEZ_CONF_DIR}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*

RUN curl -Ls https://github.com/dvoros/tez/releases/download/rel%2Frelease-0.9.1-hadoop310-noui/tez-0.9.1.tar.gz > /tmp/$TEZ_TGZ
RUN curl -Ls https://github.com/dvoros/tez/releases/download/rel%2Frelease-0.9.1-hadoop310-noui/tez-0.9.1-minimal.tar.gz > /tmp/$TEZ_MINIMAL_TGZ
RUN mkdir /usr/local/apache-tez-0.9.1-bin && tar -xzf /tmp/$TEZ_MINIMAL_TGZ -C /usr/local/apache-tez-0.9.1-bin

RUN cd /usr/local && ln -s /usr/local/apache-tez-0.9.1-bin tez

ENV PATH $PATH:$HADOOP_HOME/bin
RUN $BOOTSTRAP && hdfs dfsadmin -safemode leave \
  && hdfs dfs -mkdir -p /apps/tez \
  && hadoop fs -copyFromLocal /tmp/$TEZ_TGZ /apps/tez/tez.tar.gz

RUN rm -f /tmp/$TEZ_TGZ /tmp/$TEZ_MINIMAL_TGZ

ADD tez-site.xml $TEZ_HOME/conf/
ADD mapred-site.xml $YARN_CONF_DIR/
