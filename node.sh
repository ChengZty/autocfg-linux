#! /bin/bash

VERSION=2.4.6
FILE_NAME=apache-groovy-binary-$VERSION.zip
SOURCE_DIR=groovy-$VERSION
TARGET_DIR=groovy
DL_ADDRESS=https://dl.bintray.com/groovy/maven/$FILE_NAME
SOFT_DIR=/soft
if [ ! -e $SOFT_DIR ];then
echo $SOFT_DIR dir is not exists.
exit
else
wget -O $SOFT_DIR/$FILE_NAME $DL_ADDRESS
#tgz & rename
(cd $SOFT_DIR && unzip $FILE_NAME && mv $SOURCE_DIR $TARGET_DIR)
#env
sed -i '/groovy_/Id' /etc/profile
echo "#Groovy_env
GROOVY_HOME=$SOFT_DIR/$TARGET_DIR
PATH=\$GROOVY_HOME/bin:\$PATH
export PATH GROOVY_HOME
" >> /etc/profile
source /etc/profile
fi
