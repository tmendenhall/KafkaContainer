
Scripts for starting the internal components. Not added to Container CMD by default.
starting zookeeper (until added)
/usr/local/zookeeper/bin/zkServer.sh start

then
/usr/local/kafka/bin/kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties

to start with the default properties
Create and verify a topic:
# /usr/local/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
Created topic "test".
# /usr/local/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic test
    Topic:test    PartitionCount:1    ReplicationFactor:1    Configs:
        Topic: test    Partition: 0    Leader: 0    Replicas: 0    Isr: 0
#
Produce messages to a test topic:
# /usr/local/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
Test Message 1
Test Message 2
^D
#
Consume messages from a test topic:
# /usr/local/kafka/bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
Test Message 1
Test Message 2
^C
Consumed 2 messages #

however the messages have changed some...
