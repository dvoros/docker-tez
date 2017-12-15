FROM dvoros/hadoop:HDP-2.6.3.0

ENV TEZ_VERSION tez-0.7.0.2.6.0.3-8
ENV TEZ_HOME /usr/local/tez
ENV TEZ_CONF_DIR $TEZ_HOME/conf
ENV HADOOP_CLASSPATH ${TEZ_CONF_DIR}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*

RUN mkdir -p /usr/local/$TEZ_VERSION/share
RUN curl -s http://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.6.0.3/tars/tez/$TEZ_VERSION.tar.gz > /tmp/$TEZ_VERSION.tar.gz
RUN tar -C /usr/local/$TEZ_VERSION -xzf /tmp/$TEZ_VERSION.tar.gz

RUN cd /usr/local && ln -s $TEZ_VERSION tez
RUN mkdir -p /usr/local/tez/share && curl -s http://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.6.0.3/tars/tez/$TEZ_VERSION-minimal.tar.gz > /usr/local/tez/share/tez.tar.gz

ENV PATH $PATH:$HADOOP_PREFIX/bin
RUN $BOOTSTRAP && hdfs dfsadmin -safemode leave \
  && hdfs dfs -mkdir -p /apps/tez \
  && hadoop fs -copyFromLocal /tmp/$TEZ_VERSION.tar.gz /apps/tez/tez.tar.gz

ADD tez-site.xml $TEZ_HOME/conf/
ADD mapred-site.xml $YARN_CONF_DIR/

COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh"]
