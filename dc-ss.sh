#!/usr/bin/env bash

if [ x$1 != x ];then
echo 'your pass:'$1
else
echo 'no pass.'
exit
fi
if [ ! doceutil ];then
echo doceutil not installed.
exit
else
for i in $(seq 1 10)
do
PASSWORD=${1}${i}
run --name ss${i} -d -p 200${i}:8888 wscl124914/shadowsocks -s 0.0.0.0 -p 8888 -k $(PASSWORD) -m rc4-md5
done
fi