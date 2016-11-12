#!/usr/bin/env bash

# 公共 BashShell 支持大量环境的自动化配置
# arg01 -> 环境的名称
# arg02 -> 安装到目录
# arg03 -> UID:GID(权限)
#########################
# Java       -> java    #
# Node       -> node    #
# Go         -> golang  #
# Rust       -> rust    #
# Groovy     -> groovy  #
# Grails     -> grails  #
# Maven      -> maven   #
# Gradle     -> gradle  #
# AndroidSdk -> android #
# Hadoop     -> hadoop  #
#########################
# 当前为开发(Dev)版本
# 推荐使用release版本

V_JDK=8u91
V_NODE=4.6.0
V_GO=1.7.3
V_RUST=1.13.0
V_GROOVY=2.4.7
V_GRAILS=3.2.0
V_MAVEN=3.3.9
V_GRADLE=3.0
V_ANDROID_SDK=24.4.1
V_HADOOP=3.7.3

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
    chmod 777 -R /tmp/${ENV_TYPE}
}

# 解压函数
# arg1= 文件后缀
# arg2= 解压后目录名
# 定义一系列压缩包后缀常量
SUFFIX_TAR='tar'
SUFFIX_TAR_GZ='tar.gz'
SUFFIX_TAR_XZ='tar.xz'
SUFFIX_ZIP='zip'
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
        ${SUFFIX_ZIP}) bak && unzip ${DL_FILE} -d ${home_path} && mv_my_dir
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

# Java环境
java_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="http://bridsystems.net/downloads/java/jdk-${V_JDK}-linux-x64.tar.gz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="jdk${V_JDK}.tar.gz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='jdk'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('Java_' 'CLASSPATH')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Java_env
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
    ADDRESS="https://nodejs.org/dist/v${V_NODE}/node-v${V_NODE}-linux-x64.tar.xz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="node${V_NODE}.tar.xz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='node'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('node_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_XZ} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Node_env
NODE_HOME=${home_path}
PATH=\$NODE_HOME/bin:\$PATH
export NODE_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# GoLang环境
golang_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="https://storage.googleapis.com/golang/go${V_GO}.linux-amd64.tar.gz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="go${V_GO}.tar.gz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='go'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('go_env' 'GOROOT' 'GOPATH')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    # 2.1 创建GOPATH
    if [ ! -e ${SOFT_DIR}/GOPATH ];then mkdir ${SOFT_DIR}/GOPATH;fi
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Go_env
GOROOT=${home_path}
GOPATH=${SOFT_DIR}/GOPATH
PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH
export GOROOT GOPATH" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Rust环境
rust_env() {
    # 重置安装目录变量
    SOFT_DIR=/tmp/rust
    # 0.1 定义变量: 下载地址
    ADDRESS="https://static.rust-lang.org/dist/rust-${V_RUST}-x86_64-unknown-linux-gnu.tar.gz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="rust${V_RUST}.tar.gz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='rust'
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    # 3.执行安装脚本
    (cd /tmp/${ENV_TYPE}/${DIR_NAME} && ./install.sh)
}
# Groovy环境
groovy_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="https://dl.bintray.com/groovy/maven/apache-groovy-binary-${V_GROOVY}.zip"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="groovy${V_GROOVY}.zip"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='groovy'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('groovy_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_ZIP} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Groovy_env
GROOVY_HOME=${home_path}
PATH=\$GROOVY_HOME/bin:\$PATH
export GROOVY_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Grails环境
grails_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="https://github.com/grails/grails-core/releases/download/v${V_GRAILS}/grails-${V_GRAILS}.zip"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="grails${V_GRAILS}.zip"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='grails'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('grails_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_ZIP} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Grails_env
GRAILS_HOME=${home_path}
PATH=\$GRAILS_HOME/bin:\$PATH
export GRAILS_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Maven环境
maven_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="http://mirrors.cnnic.cn/apache/maven/maven-3/${V_MAVEN}/binaries/apache-maven-${V_MAVEN}-bin.tar.gz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="maven${V_MAVEN}.tar.gz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='maven'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('maven_' 'm2_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Maven_env
M2_HOME=${home_path}
PATH=\$M2_HOME/bin:\$PATH
export M2_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Gradle环境
gradle_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="https://services.gradle.org/distributions/gradle-${V_GRADLE}-all.zip"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="gradle${V_GRADLE}.zip"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='gradle'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('gradle_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_ZIP} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Gradle_env
GRADLE_HOME=${home_path}
PATH=\$GRADLE_HOME/bin:\$PATH
export GRADLE_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Android环境
android_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="https://dl.google.com/android/android-sdk_r${V_ANDROID_SDK}-linux.tgz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="android-sdk${V_ANDROID_SDK}.tgz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='android-sdk'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('android_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Android_env
ANDROID_SDK_HOME=${home_path}
PATH=\$ANDROID_SDK_HOME/platform-tools:\$ANDROID_SDK_HOME/tools:\$PATH
export ANDROID_SDK_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Hadoop环境
hadoop_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-${V_HADOOP}/hadoop-${V_HADOOP}.tar.gz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="hadoop${V_HADOOP}.tar.gz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='hadoop'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('hadoop_')
    # 1.下载
    common-dl ${ADDRESS} ${SAVE_NAME}
    # 2.解压
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    # 3.配置环境变量（永久性）
    # 3.1这里一直搞不定写入换行问题，所以需要自己实现write函数!!
    write() {
        echo "#:Hadoop_env
HADOOP_HOME=${home_path}
PATH=\$HADOOP_HOME/bin:\$PATH
export HADOOP_HOME" >> /etc/profile
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