#!/bin/sh

echo Starting the Journalnode 
echo Journalnode pi01rouge
ssh pi01rouge '/opt/hadoop/bin/hdfs --daemon start journalnode  > /dev/null 2>&1 &'
echo Journalnode pi02rose
ssh pi02rose '/opt/hadoop/bin/hdfs --daemon start journalnode  > /dev/null 2>&1 &'
echo Journalnode pi03orange
ssh pi03orange '/opt/hadoop/bin/hdfs --daemon start journalnode  > /dev/null 2>&1 &'
echo All Journalnodes ready

echo Starting the Active Namenode 
echo Format the Active Namenode pi01rouge
ssh pi01rouge  '/opt/hadoop/bin/hdfs namenode -format'
echo Start the Namenode daemon in Active namenode pi01rouge
ssh pi01rouge '/opt/hadoop/bin/hdfs --daemon start namenode  > /dev/null 2>&1 &'
echo Active Namenode is on

echo Start the Standby Namenode
echo Copy the HDFS Meta data from active name node to standby namenode pi02rose
ssh pi02rose  '/opt/hadoop/bin/hdfs namenode -bootstrapStandby'
echo Start the Namenode daemon in Active namenode pi02rose
ssh pi02rose '/opt/hadoop/bin/hdfs --daemon start namenode  > /dev/null 2>&1 &'

echo Zookeeper
echo zookeeper pi01rouge
ssh pi01rouge '/opt/zookeeper/bin/zkServer.sh start > /dev/null 2>&1 &'
echo zookeeper pi02rose
ssh pi02rose '/opt/zookeeper/bin/zkServer.sh start > /dev/null 2>&1 &'
echo zookeeper pi03orange
ssh pi03orange '/opt/zookeeper/bin/zkServer.sh start > /dev/null 2>&1 &'
echo Start the Zookeeper fail over controller in Active namenode pi01rouge
ssh pi01rouge '/opt/hadoop/bin/hdfs --daemon start zkfc > /dev/null 2>&1 &'
echo Start the Zookeeper fail over controller in Standby namenode pi02rose
ssh pi02rose '/opt/hadoop/bin/hdfs --daemon start zkfc > /dev/null 2>&1 &'
echo Zookeeper is on

echo Checking Namenodes
ssh pi01rouge '/opt/hadoop/bin/hdfs haadmin -getAllServiceState &'
echo Namenodes ready

echo Starting Yarn
ssh pi01rouge '/opt/hadoop/sbin/start-yarn.sh'
sleep 10
echo Starting Datanodes
ssh pi03orange '/opt/hadoop/bin/hdfs --daemon start datanode > /dev/null 2>&1 &'
ssh pi04jaune '/opt/hadoop/bin/hdfs --daemon start datanode > /dev/null 2>&1 &'
ssh pi05vert '/opt/hadoop/bin/hdfs --daemon start datanode > /dev/null 2>&1 &'
ssh pi06bleu '/opt/hadoop/bin/hdfs --daemon start datanode > /dev/null 2>&1 &'
ssh pi07violet '/opt/hadoop/bin/hdfs --daemon start datanode > /dev/null 2>&1 &'
ssh pi08noir '/opt/hadoop/bin/hdfs --daemon start datanode > /dev/null 2>&1 &'
ssh pi09blanc '/opt/hadoop/bin/hdfs --daemon start datanode > /dev/null 2>&1 &'

echo Checking Datanode List
ssh pi01rouge '/opt/hadoop/bin/yarn node -list'
echo Yarn ready

echo Hive
echo hive metastore pi08noir
ssh pi08noir '/opt/hive/bin/hive --service metastore > /dev/null 2>&1 &'
sleep 10
echo hive metastore is on
echo hive hiveserver2 pi07violet
ssh pi07violet '/opt/hive/bin/hive --service hiveserver2 > /dev/null 2>&1 &'
sleep 10
echo hive hiveserver2 is on
echo Hive is on

echo Spark
ssh pi01rouge '/opt/spark/sbin/start-all.sh > /dev/null 2>&1 &'
echo Spark is on

echo 'Homelab Ready!!!'
 

 

