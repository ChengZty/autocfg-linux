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
wget -O ${MC_HOME}/minecraft-server.jar \
${VERSION_ADDRESS}
# 写入版本地址
echo ${VERSION_ADDRESS} > ${MC_HOME}/version
# 创建eula文件
echo eula=true > ${MC_HOME}/eula.txt
# 创建启动脚本
tee ${MC_HOME}/startup.sh <<-'EOF'
#!/usr/bin/env bash
MC_HOME=/data/minecraft
if [ -e ${MC_HOME}/startup.sh ];then ${MC_HOME}/startup.sh;
else
    if [ ! -e ${MC_HOME}/minecraft_server.jar ];then curl -sL http://shell.bluerain.io/minecraft | bash `cat ${MC_HOME}/version`;fi
    (cd ${MC_HOME} && java -jar $* minecraft-server.jar nogui)
fi
EOF
chmod +x ${MC_HOME}/startup.sh