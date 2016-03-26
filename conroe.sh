#!/usr/bin/env bash

if [ ! doceutil ];then
echo doceutil not installed.
exit
else
for i in $(seq 1 4)
do
doceutil run -v /soft/node:/usr/local/node -v /apps/conroe:/src/app \
-p 300${i}:3000 --name conroe-${i} -d wscl124914/node_runtime
done
fi