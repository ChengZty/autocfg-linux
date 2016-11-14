#!/usr/bin/env bash
V_JDK=8u91
V_SCALA=2.12.0
V_NODE=4.6.0
V_GO=1.7.3
V_RUST=1.13.0
V_GROOVY=2.4.7
V_GRAILS=3.2.0
V_MAVEN=3.3.9
V_GRADLE=3.1
V_ANDROID_SDK=24.4.1
V_HADOOP=3.7.3
ENV_TYPE=$1 
SOFT_DIR=$2 
UID_GID=${3}:${3} 
echo environment: ${ENV_TYPE}
echo install to: ${SOFT_DIR}
echo udi:gid: ${UID_GID}
common-dl() {
    address=$1; file_name=$2
    if [ ! -e /tmp/${ENV_TYPE} ];then mkdir /tmp/${ENV_TYPE};fi
    wget -O /tmp/${ENV_TYPE}/${file_name} ${address}
    DL_FILE=/tmp/${ENV_TYPE}/${file_name}
    chmod 777 -R /tmp/${ENV_TYPE}
}
SUFFIX_TAR='tar'
SUFFIX_TAR_GZ='tar.gz'
SUFFIX_TAR_XZ='tar.xz'
SUFFIX_ZIP='zip'
common-unzip() {
    suffix=$1; dir_name=$2
    home_path=${SOFT_DIR}/${dir_name}
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
common-set-profile() {
    for key in ${ENV_KEYS[@]};do
        sed -i "/${key}/Id" /etc/profile
    done
    write
    chown -R ${UID_GID} ${home_path}
    source /etc/profile
}
java_env() {
    ADDRESS="http://bridsystems.net/downloads/java/jdk-${V_JDK}-linux-x64.tar.gz"
    SAVE_NAME="jdk${V_JDK}.tar.gz"
    DIR_NAME='jdk'
    ENV_KEYS=('Java_' 'CLASSPATH')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    write() {
        echo "#:Java_env
JAVA_HOME=${home_path}
PATH=\$JAVA_HOME/bin:\$PATH
CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export JAVA_HOME CLASSPATH" >> /etc/profile
    }
    common-set-profile
}
scala_env() {
    ADDRESS="http://downloads.lightbend.com/scala/${V_SCALA}/scala-${V_SCALA}.tgz"
    SAVE_NAME="scala${V_SCALA}.taz"
    DIR_NAME='scala'
    ENV_KEYS=('Scala_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    write() {
        echo "#:Scala_env
SCALA_HOME=${home_path}
PATH=\$SCALA_HOME/bin:\$PATH
export SCALA_HOME" >> /etc/profile
    }
    common-set-profile
}
node_env() {
    ADDRESS="https://nodejs.org/dist/v${V_NODE}/node-v${V_NODE}-linux-x64.tar.xz"
    SAVE_NAME="node${V_NODE}.tar.xz"
    DIR_NAME='node'
    ENV_KEYS=('node_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_XZ} ${DIR_NAME}
    write() {
        echo "#:Node_env
NODE_HOME=${home_path}
PATH=\$NODE_HOME/bin:\$PATH
export NODE_HOME" >> /etc/profile
    }
    common-set-profile
}
golang_env() {
    ADDRESS="https://storage.googleapis.com/golang/go${V_GO}.linux-amd64.tar.gz"
    SAVE_NAME="go${V_GO}.tar.gz"
    DIR_NAME='go'
    ENV_KEYS=('go_env' 'GOROOT' 'GOPATH')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    if [ ! -e ${SOFT_DIR}/GOPATH ];then mkdir ${SOFT_DIR}/GOPATH;fi
    write() {
        echo "#:Go_env
GOROOT=${home_path}
GOPATH=${SOFT_DIR}/GOPATH
PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH
export GOROOT GOPATH" >> /etc/profile
    }
    common-set-profile
}
rust_env() {
    SOFT_DIR=/tmp/rust
    ADDRESS="https://static.rust-lang.org/dist/rust-${V_RUST}-x86_64-unknown-linux-gnu.tar.gz"
    SAVE_NAME="rust${V_RUST}.tar.gz"
    DIR_NAME='rust'
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    (cd /tmp/${ENV_TYPE}/${DIR_NAME} && ./install.sh)
}
groovy_env() {
    ADDRESS="https://dl.bintray.com/groovy/maven/apache-groovy-binary-${V_GROOVY}.zip"
    SAVE_NAME="groovy${V_GROOVY}.zip"
    DIR_NAME='groovy'
    ENV_KEYS=('groovy_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_ZIP} ${DIR_NAME}
    write() {
        echo "#:Groovy_env
GROOVY_HOME=${home_path}
PATH=\$GROOVY_HOME/bin:\$PATH
export GROOVY_HOME" >> /etc/profile
    }
    common-set-profile
}
grails_env() {
    ADDRESS="https://github.com/grails/grails-core/releases/download/v${V_GRAILS}/grails-${V_GRAILS}.zip"
    SAVE_NAME="grails${V_GRAILS}.zip"
    DIR_NAME='grails'
    ENV_KEYS=('grails_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_ZIP} ${DIR_NAME}
    write() {
        echo "#:Grails_env
GRAILS_HOME=${home_path}
PATH=\$GRAILS_HOME/bin:\$PATH
export GRAILS_HOME" >> /etc/profile
    }
    common-set-profile
}
maven_env() {
    ADDRESS="http://mirrors.cnnic.cn/apache/maven/maven-3/${V_MAVEN}/binaries/apache-maven-${V_MAVEN}-bin.tar.gz"
    SAVE_NAME="maven${V_MAVEN}.tar.gz"
    DIR_NAME='maven'
    ENV_KEYS=('maven_' 'm2_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    write() {
        echo "#:Maven_env
M2_HOME=${home_path}
PATH=\$M2_HOME/bin:\$PATH
export M2_HOME" >> /etc/profile
    }
    common-set-profile
}
gradle_env() {
    ADDRESS="https://services.gradle.org/distributions/gradle-${V_GRADLE}-all.zip"
    SAVE_NAME="gradle${V_GRADLE}.zip"
    DIR_NAME='gradle'
    ENV_KEYS=('gradle_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_ZIP} ${DIR_NAME}
    write() {
        echo "#:Gradle_env
GRADLE_HOME=${home_path}
PATH=\$GRADLE_HOME/bin:\$PATH
export GRADLE_HOME" >> /etc/profile
    }
    common-set-profile
}
android_env() {
    ADDRESS="https://dl.google.com/android/android-sdk_r${V_ANDROID_SDK}-linux.tgz"
    SAVE_NAME="android-sdk${V_ANDROID_SDK}.tgz"
    DIR_NAME='android-sdk'
    ENV_KEYS=('android_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    write() {
        echo "#:Android_env
ANDROID_SDK_HOME=${home_path}
PATH=\$ANDROID_SDK_HOME/platform-tools:\$ANDROID_SDK_HOME/tools:\$PATH
export ANDROID_SDK_HOME" >> /etc/profile
    }
    common-set-profile
}
hadoop_env() {
    ADDRESS="http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-${V_HADOOP}/hadoop-${V_HADOOP}.tar.gz"
    SAVE_NAME="hadoop${V_HADOOP}.tar.gz"
    DIR_NAME='hadoop'
    ENV_KEYS=('hadoop_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    write() {
        echo "#:Hadoop_env
HADOOP_HOME=${home_path}
PATH=\$HADOOP_HOME/bin:\$PATH
export HADOOP_HOME" >> /etc/profile
    }
    common-set-profile
}
main() {
    echo -n `${ENV_TYPE}_env`
}
main
