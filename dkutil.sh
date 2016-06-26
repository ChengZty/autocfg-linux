#! /usr/bin/env bash

if [ x$1 != x ];then soft_dir=$1;else soft_dir=/soft;fi
echo your soft_dir:${soft_dir}

core_file=DockerUtil.py
if [ ! -e ${soft_dir} ];then
echo ${soft_dir} is not exists.
fi
rm -rf ${soft_dir}/dkutil
(cd ${soft_dir} && git clone https://github.com/hentai-mew/dkutil.git)
chmod +x ${soft_dir}/dkutil/${core_file}
ln -fs ${soft_dir}/dkutil/${core_file} /usr/bin/dkutil
echo dkutil installed.
echo you can show the version.
echo the cammand:dkutil -v
