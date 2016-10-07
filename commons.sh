#!/usr/bin/env bash

# 公共 BashShell 支持大量环境的自动化配置
# arg01 -> 环境的名称
# arg02 -> 安装到目录
#########################
# Java       -> java    #
# Go         -> go      # 目
# Groovy     -> groovy  # 前
# Node       -> node    # 包
# Maven      -> maven   # 括
# AndroidSdk -> android #
#########################
# 当前为开发(Dev)版本
# 推荐使用release版本

# Dev Started:
# 定义（接受传参）常量

ENV_TYPE=$1 # 环境类型
SOFT_DIR=$2 # 安装目录
UID_GID=${3}:${3} # 用户/组 ID

echo environment: ${ENV_TYPE}
echo install to: ${SOFT_DIR}
echo udi:gid: ${UID_GID}

# 定义函数

# 下载函数
# arg1= 下载地址
# arg2= 保存文件名
common-dl() {
    address=$1; file_name=$2
    if [ ! -e /tmp/${ENV_TYPE} ];then mkdir /tmp/${ENV_TYPE};fi
    wget -O /tmp/${ENV_TYPE}/${file_name} ${address}
    # 定义变量
    DL_FILE=/tmp/${ENV_TYPE}/${file_name}
}

# 解压函数
# arg1= 文件后缀
# arg2= 解压后目录名
# 定义一系列压缩包后缀常量
SUFFIX_TAR='tar'
SUFFIX_TAR_GZ='tar.gz'
SUFFIX_TAR_XZ='tar.xz'
common-unzip() {
    suffix=$1; dir_name=$2
    home_path=${SOFT_DIR}/${dir_name}
    # 备份函数
    bak(){
        if [ -e ${home_path} ];then mv ${home_path} ${home_path}.bak.`date +%s.%N`;fi
        mkdir ${home_path}
    }
    mv_my_dir() {
        (cd ${home_path} && mv `echo *`/* ${home_path}/)
    }
    case ${suffix} in
        ${SUFFIX_TAR}) bak && tar -xvf ${DL_FILE} -C ${home_path} && mv_my_dir
        ;;
        ${SUFFIX_TAR_GZ}) bak && tar -zxvf ${DL_FILE} -C ${home_path} && mv_my_dir
        ;;
        ${SUFFIX_TAR_XZ}) bak && tar -Jxf ${DL_FILE} -C ${home_path} && mv_my_dir
        ;;
        *) echo \*
    esac
}

# 环境变量函数
# arg1= 需要删除的变量关键字数组
# arg2= 写入的环境变量内容
common-set-profile() {

    for key in ${ENV_KEYS[@]};do
        sed -i "/${key}/Id" /etc/profile
    done
    write
    # 执行结束修改SOFT目录到指定权限
    chown -R ${UID_GID} ${home_path}
    source /etc/profile
}
# Environment Started.

# Test环境
test_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS='http://dl.bluerain.io/test.tar.gz'
    # 0.2 定义变量: 保存文件名
    SAVE_NAME='test.tar.gz.1'
    # 0.3 定义变量: 解压目录名
    DIR_NAME='test'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('test_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现写入方法!!
    write() {
        echo "#Test_env
TEST_HOME=${home_path}
PATH=\$TEST_HOME/:\$PATH
export TEST_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Java环境
java_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS='http://bridsystems.net/downloads/java/jdk-8u91-linux-x64.tar.gz'
    # 0.2 定义变量: 保存文件名
    SAVE_NAME='jdk.tar.gz'
    # 0.3 定义变量: 解压目录名
    DIR_NAME='jdk'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('Java_' 'CLASSPATH')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现写入方法!!
    write() {
        echo "#Java_env
JAVA_HOME=${home_path}
PATH=\$JAVA_HOME/bin:\$PATH
CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export JAVA_HOME CLASSPATH" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}

# Node环境
node_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS='https://nodejs.org/dist/v4.6.0/node-v4.6.0-linux-x64.tar.xz'
    # 0.2 定义变量: 保存文件名
    SAVE_NAME='node.tar.xz'
    # 0.3 定义变量: 解压目录名
    DIR_NAME='node'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('node_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_XZ} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现写入方法!!
    write() {
        echo "#Node_env
NODE_HOME=${home_path}
PATH=\$NODE_HOME/bin:\$PATH
export NODE_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}

# 入口环境
main() {
    # 调用对应环境函数
    echo -n `${ENV_TYPE}_env`
}
# 开始执行
main