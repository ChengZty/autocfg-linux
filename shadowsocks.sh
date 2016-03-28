#!/usr/bin/env bash

if [ x$1 != x ];then
echo 'your port:'$1
PORT=$1
else
echo 'no port.'
exit
fi
if [ x$2 != x ];then
echo 'your password:'$2
PASSWORD=$2
else
echo 'no password.'
exit
fi
if [ x$3 != x ];then
METHOD=$3
else
METHOD=aes-256-cfb
fi
echo 'your method:'$3

DATA_DIR=/data
SS_DIR=${DATA_DIR}/shadowsocks
JSON=${SS_DIR}/c1.json
if [ ! -e ${DATA_DIR} ];then
echo ${DATA_DIR} is not exists.
exit
else
if [ ! -e ${SS_DIR} ];then
mkdir ${SS_DIR} -p
fi
rm -rf ${JSON}
echo '{
    "server":"0.0.0.0",
    "server_port":${PORT},
    "password":"${PASSWORD}",
    "timeout":300,
    "method":"${METHOD}",
    "fast_open": false
}
' >> ${JSON}

if [ ! ssserver ];then
yum install python-setuptools && easy_install pip
pip install shadowsocks
fi
ssserver -c ${JSON} -d start
fi
