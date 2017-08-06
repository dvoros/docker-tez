# Apache Tez 0.8.4 Docker image

Based on https://github.com/sequenceiq/hadoop-docker

## Usage

```
docker run -it dvoros/tez
```

## Tez example

Run the ordered word-count example with:

```
echo "some words in some file" > /tmp/some.file
hdfs dfs -put /tmp/some.file /user/root/in

cd $TEZ_HOME
hadoop jar tez-examples-0.8.4.jar orderedwordcount /user/root/in /user/root/out
```
