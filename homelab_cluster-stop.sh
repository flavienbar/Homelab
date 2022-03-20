#!/bin/sh
echo Stop Hive
echo hive metastore pi08
ssh pi08noir 'sudo service hive-metastore stop'
sleep 10
echo hive metastore is on
echo hive hiveserver2 pi07
ssh pi07violet 'sudo service hiveserver2 stop'
sleep 10
echo hive hiveserver2 is on
echo Hive is off

A voir ps aux | awk '{print $1,$2}' | grep hive | awk '{print $2}' | xargs kill >/dev/null 2>&1

echo Spark
ssh pi01rouge '/opt/spark/sbin/stop-all.sh > /dev/null 2>&1 &'
echo Spark is off

echo Stoppping Yarn
ssh pi01rouge '/opt/hadoop/sbin/stop-yarn.sh'
sleep 10

echo Stopping Datanodes
ssh pi03orange '/opt/hadoop/bin/hdfs --daemon stop datanode > /dev/null 2>&1 &'
ssh pi04jaune '/opt/hadoop/bin/hdfs --daemon stop datanode > /dev/null 2>&1 &'
ssh pi05vert '/opt/hadoop/bin/hdfs --daemon stop datanode > /dev/null 2>&1 &'
ssh pi06bleu '/opt/hadoop/bin/hdfs --daemon stop datanode > /dev/null 2>&1 &'
ssh pi07violet '/opt/hadoop/bin/hdfs --daemon stop datanode > /dev/null 2>&1 &'
ssh pi08noir '/opt/hadoop/bin/hdfs --daemon stop datanode > /dev/null 2>&1 &'
ssh pi09blanc '/opt/hadoop/bin/hdfs --daemon stop datanode > /dev/null 2>&1 &'
echo All Datanodes off

echo Stopping Namenodes 
echo Stopping the Active Namenode pi01rouge
ssh pi01rouge '/opt/hadoop/bin/hdfs --daemon stop namenode  > /dev/null 2>&1 &'
echo Active Namenode is off
echo Stopping the Standby Namenode pi02rose
ssh pi02rose '/opt/hadoop/bin/hdfs --daemon stop namenode  > /dev/null 2>&1 &'
echo Standby Namenode is off

echo Stopping Zookeeper fail over
echo Stopping the Zookeeper fail over controller in Active namenode pi01rouge
ssh pi01rouge '/opt/hadoop/bin/hdfs --daemon stop zkfc > /dev/null 2>&1 &'
echo Stopping the Zookeeper fail over controller in Standby namenode pi02rose
ssh pi02rose '/opt/hadoop/bin/hdfs --daemon stop zkfc > /dev/null 2>&1 &'
echo Zookeeper fail over is off

echo Stopping the Journalnode 
echo Journalnode pi01rouge
ssh pi01rouge '/opt/hadoop/bin/hdfs --daemon stop journalnode  > /dev/null 2>&1 &'
echo Journalnode pi02rose
ssh pi02rose '/opt/hadoop/bin/hdfs --daemon stop journalnode  > /dev/null 2>&1 &'
echo Journalnode pi03orange
ssh pi03orange '/opt/hadoop/bin/hdfs --daemon stop journalnode  > /dev/null 2>&1 &'
echo All Journalnodes off

echo Stopping Zookeeper
echo Stopping Zookeeper Server
echo zookeeper pi01rouge
ssh pi01rouge '/opt/zookeeper/bin/zkServer.sh stop > /dev/null 2>&1 &'
echo zookeeper pi02rose
ssh pi02rose '/opt/zookeeper/bin/zkServer.sh stop > /dev/null 2>&1 &'
echo zookeeper pi03orange
ssh pi03orange '/opt/zookeeper/bin/zkServer.sh stop > /dev/null 2>&1 &'
echo Zookeeper off

echo 'Good night Homelab!!!'
