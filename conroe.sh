#!/usr/bin/env bash

if [ ! dkutil ];then
echo dkutil not installed.
exit
else
for i in $(seq 1 4)
do
dkutil run -v /apps/conroe:/app \
-p 300${i}:3000 --name conroe-${i} -d bluerain/node:express
done
fi