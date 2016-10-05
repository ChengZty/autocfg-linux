#!/usr/bin/env bash

# 声明变量
MC_HOME=/data/minecraft
# 是否存在 MC_HOME 目录，不存在则创建
if [ ! -e ${MC_HOME} ]; then mkdir -p ${MC_HOME};fi
# 是否存在wget，不存在则安装
if [ ! -e /usr/bin/wget ];then apt install wget -y;fi
# 下载server.jar（如果没有参数则下载最新，否则下载参数地址中的版本）
VERSION_ADDRESS=https://launcher.mojang.com/mc/game/1.10.2/server/3d501b23df53c548254f5e3f66492d178a48db63/server.jar
if test $1;then VERSION_ADDRESS=$1;fi
wget -O ${MC_HOME}/minecraft_server.jar \
${VERSION_ADDRESS}
# 备份jar到 /data 目录
cp ${MC_HOME}/minecraft_server.jar /data/
# 写入版本地址
echo ${VERSION_ADDRESS} > /data/version
# 创建eula文件
echo eula=true > ${MC_HOME}/eula.txt
# 创建启动脚本
tee ${MC_HOME}/startup.sh <<-'EOF'
#!/usr/bin/env bash
MC_HOME=/data/minecraft
reset(){
    echo 'reseting...'
    # 从 data 目录还原 jar
    cp /data/minecraft_server.jar ${MC_HOME}/
    # 还原启动脚本
    cp /usr/local/bin/start-mc-server ${MC_HOME}/startup.sh
    # 修改EULA
    echo eula=true > ${MC_HOME}/eula.txt

}
boot(){
    echo 'booting...'
    if [ ! -e ${MC_HOME}/minecraft_server.jar ];then reset;fi
    (cd ${MC_HOME} && java -jar $* minecraft_server.jar nogui)
}
main(){
    # 如果不是以startup.sh启动
    if ! test $0 = "${MC_HOME}/startup.sh";then
        if [ ! -e ${MC_HOME}/startup.sh ];then # 并且不存在startup.sh
            # 重置然后启动
            reset
            boot
        else # 如果存在
            # 执行运行
            boot
        fi
    else
        boot
    fi
}
main
EOF
chmod +x ${MC_HOME}/startup.sh