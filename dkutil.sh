#! /usr/bin/env bash

soft_dir=/soft
core_file=DockerUtil.py
if [ ! -e ${soft_dir} ];then
echo ${soft_dir} is not exists.
fi
rm -rf ${soft_dir}/dkutil
(cd ${soft_dir} && git clone https://github.com/hentai-mew/dkutil.git)
chmod +x ${soft_dir}/dkutil/${core_file}
ln -fs ${soft_dir}/dkutil/${core_file} /usr/bin/dkutil
