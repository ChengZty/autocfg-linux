#!/usr/bin/env bash

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
    "server_port":25,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"wscl123",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}
' >> ${JSON}

if [ ! ssserver ];then
yum install python-setuptools && easy_install pip
pip install shadowsocks
fi
ssserver -c ${JSON} -d start
fi