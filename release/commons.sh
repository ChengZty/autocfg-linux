#!/usr/bin/env bash
JDK_VERSION=10.0.1
JDK_ARCH=10.0.1+10
JDK_HASH=fb4372174a714e6b8c52526dc134031e
JDK_FILENAME="jdk-${JDK_VERSION}_linux-x64_bin.tar.gz"
V_SCALA=2.12.4
V_NODE=8.11.1
V_GO=1.10.1
V_GROOVY=2.4.15
V_GRAILS=3.3.5
V_MAVEN=3.5.3
V_GRADLE=4.7
V_ANDROID_SDK=3859397
V_HADOOP=3.1.0
SOFT_DIR=$1 
UID_GID=$2 
ENV_TYPE=$3 
echo Environment: "${ENV_TYPE}"
echo Install to: "${SOFT_DIR}"
echo UID:GID: "${UID_GID}"
common-dl() {
    ADDRESS=$1; FILE_NAME=$2
    if [ ! -e "/tmp/${ENV_TYPE}" ];then mkdir "/tmp/${ENV_TYPE}";fi
    wget -O "/tmp/${ENV_TYPE}/${FILE_NAME}" "${ADDRESS}"
    DL_FILE="/tmp/${ENV_TYPE}/${FILE_NAME}"
    chmod 777 "/tmp/${ENV_TYPE}" -R
}
SUFFIX_TAR='tar'
SUFFIX_TAR_GZ='tar.gz'
SUFFIX_TAR_XZ='tar.xz'
SUFFIX_ZIP='zip'
common-unzip() {
    SUFFIX=$1; DIR_NAME=$2
    HOME_PATH="${SOFT_DIR}/${DIR_NAME}"
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
common-set-profile() {
    for key in "${ENV_KEYS[@]}";do
        sed -i "/${key}/Id" /etc/profile
    done
    write
    chown -R "${UID_GID}" "${HOME_PATH}"
    source /etc/profile
}
java_env() {
    ADDRESS="http://download.oracle.com/otn-pub/java/jdk/$JDK_ARCH/$JDK_HASH/$JDK_FILENAME"
    SAVE_NAME="jdk${JDK_VERSION}.tar.gz"
    DIR_NAME='jdk'
    ENV_KEYS=('Java_' 'CLASSPATH')
    if [ ! -e "/tmp/${ENV_TYPE}" ];then mkdir "/tmp/${ENV_TYPE}";fi
    wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" -O "/tmp/${ENV_TYPE}/${SAVE_NAME}" "${ADDRESS}"
    DL_FILE="/tmp/${ENV_TYPE}/${SAVE_NAME}"
    chmod 777 "/tmp/${ENV_TYPE}" -R
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    write() {
        echo "#:Java_env
JAVA_HOME=${HOME_PATH}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    write() {
        echo "#:Scala_env
SCALA_HOME=${HOME_PATH}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_TAR_XZ}" "${DIR_NAME}"
    write() {
        echo "#:Node_env
NODE_HOME=${HOME_PATH}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    if [ ! -e "${SOFT_DIR}/GOPATH" ];then mkdir "${SOFT_DIR}/GOPATH";fi
    write() {
        echo "#:Go_env
GOROOT=${HOME_PATH}
GOPATH=${SOFT_DIR}/GOPATH
PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH
export GOROOT GOPATH" >> /etc/profile
    }
    common-set-profile
}
groovy_env() {
    ADDRESS="https://dl.bintray.com/groovy/maven/apache-groovy-binary-${V_GROOVY}.zip"
    SAVE_NAME="groovy${V_GROOVY}.zip"
    DIR_NAME='groovy'
    ENV_KEYS=('groovy_')
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_ZIP}" "${DIR_NAME}"
    write() {
        echo "#:Groovy_env
GROOVY_HOME=${HOME_PATH}${ENV_TYPE}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_ZIP}" "${DIR_NAME}"
    write() {
        echo "#:Grails_env
GRAILS_HOME=${HOME_PATH}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    write() {
        echo "#:Maven_env
M2_HOME=${HOME_PATH}
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
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_ZIP}" "${DIR_NAME}"
    write() {
        echo "#:Gradle_env
GRADLE_HOME=${HOME_PATH}
PATH=\$GRADLE_HOME/bin:\$PATH
export GRADLE_HOME" >> /etc/profile
    }
    common-set-profile
}
android_env() {
    ADDRESS="https://dl.google.com/android/repository/sdk-tools-linux-${V_ANDROID_SDK}.zip?hl=zh-cn"
    SAVE_NAME="android-sdk${V_ANDROID_SDK}.tgz"
    DIR_NAME='android-sdk'
    ENV_KEYS=('android_')
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_ZIP}" "${DIR_NAME}"
    write() {
        echo "#:Android_env
ANDROID_SDK_HOME=${HOME_PATH}
PATH=\$ANDROID_SDK_HOME/platform-tools:\$ANDROID_SDK_HOME/tools:\$PATH
export ANDROID_SDK_HOME" >> /etc/profile
    }
    common-set-profile
}
hadoop_env() {
    ADDRESS="http://www-us.apache.org/dist/hadoop/common/hadoop-${V_HADOOP}/hadoop-${V_HADOOP}.tar.gz"
    SAVE_NAME="hadoop${V_HADOOP}.tar.gz"
    DIR_NAME='hadoop'
    ENV_KEYS=('hadoop_')
    common-dl "${ADDRESS}" "${SAVE_NAME}"
    common-unzip "${SUFFIX_TAR_GZ}" "${DIR_NAME}"
    write() {
        echo "#:Hadoop_env
HADOOP_HOME=${HOME_PATH}
PATH=\$HADOOP_HOME/bin:\$PATH
export HADOOP_HOME" >> /etc/profile
    }
    common-set-profile
}
main() {
    echo -n `${ENV_TYPE}_env`
}
main
