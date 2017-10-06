FROM dvoros/hadoop:2.7.4

ENV TEZ_TGZ apache-tez-0.8.4-bin.tar.gz
ENV TEZ_HOME /usr/local/tez
ENV TEZ_CONF_DIR $TEZ_HOME/conf
ENV HADOOP_CLASSPATH ${TEZ_CONF_DIR}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*

RUN curl -s http://www.eu.apache.org/dist/tez/0.8.4/$TEZ_TGZ | tar -xz -C /usr/local

RUN cd /usr/local && ln -s apache-tez-0.8.4-bin tez

ENV PATH $PATH:$HADOOP_PREFIX/bin
RUN $BOOTSTRAP && hdfs dfsadmin -safemode leave \
  && hdfs dfs -mkdir -p /apps/tez \
  && hadoop fs -copyFromLocal $TEZ_HOME/share/tez.tar.gz /apps/tez/

ADD tez-site.xml $TEZ_HOME/conf/

COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh"]
