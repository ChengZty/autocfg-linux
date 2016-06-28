#!/usr/bin/env bash

if [ x$1 != x ];then soft_dir=$1;else soft_dir=/soft;fi
echo your soft_dir:${soft_dir}
version=1.6.2
file_name=go${version}.linux-amd64.tar.gz
dl_address=https://storage.googleapis.com/golang/${file_name}
source_dir=go
target_dir=go
go_path=${soft_dir}/GOPATH
if [ ! -e ${soft_dir} ];then
echo ${soft_dir} dir is not exists.
exit
else
wget -O ${soft_dir}/${file_name} ${dl_address}
#rm old version
rm -rf ${soft_dir}/${target_dir}
#tgr & rename
(cd ${soft_dir} && tar -zxvf ${file_name})
#env
if [ ! -e ${go_path} ];then
mkdir ${go_path} -p
fi
sed -i '/Go_env/Id' /etc/profile
sed -i '/GOROOT/Id' /etc/profile
sed -i '/GOPATH/Id' /etc/profile
echo "#Go_env
GOROOT=$soft_dir/$target_dir
GOPATH=$go_path
PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH
export GOROOT GOPATH
" >> /etc/profile
source /etc/profile
fi