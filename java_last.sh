#! /bin/bash

JDK_VERSION=1.8.0_73
JAVA_VERSION=8u73
JDK_FILE_NAME=jdk-$JAVA_VERSION-linux-x64.tar.gz
SOFT_DIR=/soft
if [ ! -e $SOFT_DIR ];then
echo $SOFT_DIR dir is not exists.
exit
else
wget -O /soft/$JDK_FILE_NAME http://dl.bluerain.io/$JDK_FILE_NAME
#tgz & rename
(cd $SOFT_DIR && tar -zxvf $JDK_FILE_NAME && mv jdk$JDK_VERSION jdk)
#env
sed -i '/java_/Id' /etc/profile
echo "#Java_env
JAVA_HOME=$SOFT/jdk
PATH=\$JAVA_HOME/bin:\$PATH
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH JAVA_HOME CLASSPATH
" >> /etc/profile
source /etc/profile
fi