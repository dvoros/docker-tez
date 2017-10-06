# Apache Tez Docker image

[![DockerPulls](https://img.shields.io/docker/pulls/dvoros/tez.svg)](https://registry.hub.docker.com/u/dvoros/tez/)
[![DockerStars](https://img.shields.io/docker/stars/dvoros/tez.svg)](https://registry.hub.docker.com/u/dvoros/tez/)

With Oracle JDK8 and Hadoop 2.7.4.

## Usage

```
docker run -it dvoros/tez:latest
```

## Tez example

Run the ordered word-count example with:

```
echo "some words in some file" > /tmp/some.file
hdfs dfs -put /tmp/some.file /user/root/in

cd $TEZ_HOME
hadoop jar tez-examples-*.jar orderedwordcount /user/root/in /user/root/out
hdfs dfs -cat '/user/root/out/*'
```
