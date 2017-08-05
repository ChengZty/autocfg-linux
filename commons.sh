#!/usr/bin/env bash

# 公共 BashShell 支持大量环境的自动化配置
# arg01 -> 安装到目录
# arg02 -> UID:GID
# arg03 -> 环境的名称
#########################
# Java       -> java    #
# Scala      -> scala   #
# Node       -> node    #
# Go         -> golang  #
# Groovy     -> groovy  #
# Grails     -> grails  #
# Maven      -> maven   #
# Gradle     -> gradle  #
# AndroidSdk -> android #
# Hadoop     -> hadoop  #
#########################
# 当前为开发版本
# 推荐使用 release 版本

V_JDK=8u112
V_SCALA=2.12.2
V_NODE=6.10.3
V_GO=1.8.3
V_GROOVY=2.4.11
V_GRAILS=3.3.0.M1
V_MAVEN=3.5.0
V_GRADLE=4.0.2
V_ANDROID_SDK=3859397
V_HADOOP=2.8.0

# Dev Started:
# 定义（接受传参）常量

SOFT_DIR=$1 # 安装目录
UID_GID=$2 # 用户/组 ID
ENV_TYPE=$3 # 环境类型

echo Environment: "${ENV_TYPE}"
echo Install to: "${SOFT_DIR}"
echo UID:GID: "${UID_GID}"

# 定义函数

# 下载函数
# arg1= 下载地址
# arg2= 保存文件名
common-dl() {
    ADDRESS=$1; FILE_NAME=$2
    if [ ! -e "/tmp/${ENV_TYPE}" ];then mkdir "/tmp/${ENV_TYPE}";fi
    wget -O "/tmp/${ENV_TYPE}/${FILE_NAME}" "${ADDRESS}"
    # 定义变量
    DL_FILE="/tmp/${ENV_TYPE}/${FILE_NAME}"
    chmod 777 "/tmp/${ENV_TYPE}" -R
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
    SUFFIX=$1; DIR_NAME=$2
    HOME_PATH="${SOFT_DIR}/${DIR_NAME}"
    # 备份函数
    bak(){
        if [ -e "${HOME_PATH}" ];then mv "${HOME_PATH}" "${HOME_PATH}.bak".`date +%s.%N`;fi
        mkdir "${HOME_PATH}"
    }
    mv_my_dir() {
        (cd "${HOME_PATH}" && mv `echo *`/* "${HOME_PATH}"/)
    }
    case ${SUFFIX} in
        "${SUFFIX_TAR}") bak && tar -xvf "${DL_FILE}" -C "${HOME_PATH}" && mv_my_dir
        ;;
        "${SUFFIX_TAR_GZ}") bak && tar -zxvf "${DL_FILE}" -C "${HOME_PATH}" && mv_my_dir
        ;;
        "${SUFFIX_TAR_XZ}") bak && tar -Jxf "${DL_FILE}" -C "${HOME_PATH}" && mv_my_dir
        ;;
        "${SUFFIX_ZIP}") bak && unzip "${DL_FILE}" -d "${HOME_PATH}" && mv_my_dir
        ;;
        *) echo \*
    esac
}

# 环境变量函数
# arg1= 需要删除的变量关键字数组
# arg2= 写入的环境变量内容
common-set-profile() {

    for key in "${ENV_KEYS[@]}";do
        sed -i "/${key}/Id" /etc/profile
    done
    write
    # 执行结束修改SOFT目录到指定权限
    chown -R "${UID_GID}" "${HOME_PATH}"
    source /etc/profile
}
# Environment Started.

# Java环境
java_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="http://mirrors.linuxeye.com/jdk/jdk-${V_JDK}-linux-x64.tar.gz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="jdk${V_JDK}.tar.gz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='jdk'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('Java_' 'CLASSPATH')
    # 1.下载
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Java_env
JAVA_HOME=${HOME_PATH}
PATH=\$JAVA_HOME/bin:\$PATH
CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export JAVA_HOME CLASSPATH" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Scala环境
scala_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="http://downloads.lightbend.com/scala/${V_SCALA}/scala-${V_SCALA}.tgz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="scala${V_SCALA}.taz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='scala'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('Scala_')
    # 1.下载
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Scala_env
SCALA_HOME=${HOME_PATH}
PATH=\$SCALA_HOME/bin:\$PATH
export SCALA_HOME" >> /etc/profile
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_TAR_XZ}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Node_env
NODE_HOME=${HOME_PATH}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    # 2.1 创建GOPATH
    if [ ! -e "${SOFT_DIR}/GOPATH" ];then mkdir "${SOFT_DIR}/GOPATH";fi
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Go_env
GOROOT=${HOME_PATH}
GOPATH=${SOFT_DIR}/GOPATH
PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH
export GOROOT GOPATH" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_ZIP}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Groovy_env
GROOVY_HOME=${HOME_PATH}${ENV_TYPE}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_ZIP}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Grails_env
GRAILS_HOME=${HOME_PATH}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Maven_env
M2_HOME=${HOME_PATH}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_ZIP}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Gradle_env
GRADLE_HOME=${HOME_PATH}
PATH=\$GRADLE_HOME/bin:\$PATH
export GRADLE_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Android环境
android_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="https://dl.google.com/android/repository/sdk-tools-linux-${V_ANDROID_SDK}.zip?hl=zh-cn"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="android-sdk${V_ANDROID_SDK}.tgz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='android-sdk'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('android_')
    # 1.下载
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_ZIP}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Android_env
ANDROID_SDK_HOME=${HOME_PATH}
PATH=\$ANDROID_SDK_HOME/platform-tools:\$ANDROID_SDK_HOME/tools:\$PATH
export ANDROID_SDK_HOME" >> /etc/profile
    }
    # 3.2 调用函数完成环境变量配置
    common-set-profile
}
# Hadoop环境
hadoop_env() {
    # 0.1 定义变量: 下载地址
    ADDRESS="http://www-us.apache.org/dist/hadoop/common/hadoop-${V_HADOOP}/hadoop-${V_HADOOP}.tar.gz"
    # 0.2 定义变量: 保存文件名
    SAVE_NAME="hadoop${V_HADOOP}.tar.gz"
    # 0.3 定义变量: 解压目录名
    DIR_NAME='hadoop'
    # 0.4 定义变量(数组): 删除旧环境变量关键字
    ENV_KEYS=('hadoop_')
    # 1.下载
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    # 2.解压
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    # 3.配置环境变量（永久性）
    write() {
        echo "#:Hadoop_env
HADOOP_HOME=${HOME_PATH}
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
