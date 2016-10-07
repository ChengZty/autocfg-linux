#!/usr/bin/env bash
ENV_TYPE=$1 
SOFT_DIR=$2 
common-dl() {
    address=$1; file_name=$2
    if test /tmp/${ENV_TYPE};then mkdir /tmp/${ENV_TYPE};fi
    wget -O /tmp/${ENV_TYPE}/${file_name} ${address}
    DL_FILE=/tmp/${ENV_TYPE}/${file_name}
}
SUFFIX_TAR='tar'
SUFFIX_TAR_GZ='tar.gz'
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
        *) echo \*
    esac
}
common-set-profile() {
    for key in ${ENV_KEYS[@]};do
        sed -i "/${key}/Id" /etc/profile
    done
    write
    source /etc/profile
}
test_env() {
    ADDRESS='http://dl.bluerain.io/test.tar.gz'
    SAVE_NAME='test.tar.gz.1'
    DIR_NAME='test'
    ENV_KEYS=('test_')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    write() {
        echo "
TEST_HOME=${home_path}
PATH=\$TEST_HOME/:\$PATH
export TEST_HOME" >> /etc/profile
    }
    common-set-profile
}
java_env() {
    ADDRESS='http://bridsystems.net/downloads/java/jdk-8u91-linux-x64.tar.gz'
    SAVE_NAME='jdk.tar.gz'
    DIR_NAME='jdk'
    ENV_KEYS=('Java_' 'CLASSPATH')
    common-dl ${ADDRESS} ${SAVE_NAME}
    common-unzip ${SUFFIX_TAR_GZ} ${DIR_NAME}
    write() {
        echo "
JAVA_HOME=${home_path}
PATH=\$JAVA_HOME/bin:\$PATH
CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export JAVA_HOME CLASSPATH" >> /etc/profile
    }
    common-set-profile
}
main() {
    echo -n `${ENV_TYPE}_env`
}
main
chown 1000:1000 ${home_path} -R
