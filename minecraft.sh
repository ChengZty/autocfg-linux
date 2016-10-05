#!/usr/bin/env bash

# 声明变量
MC_HOME=/data/minecraft
# 是否存在 MC_HOME 目录，不存在则创建
if [ ! -e ${MC_HOME} ]; then mkdir -p ${MC_HOME};fi
# 是否存在wget，不存在则安装
if [ ! -e /usr/bin/wget ];then apt install wget -y;fi
# 下载1.10.2版本 server.jar 到 MC_HOME 目录下，重命名为 minecraft-server.jar
wget -O ${MC_HOME}/minecraft-server.jar \
https://launcher.mojang.com/mc/game/1.10.2/server/3d501b23df53c548254f5e3f66492d178a48db63/server.jar
# 创建eula文件
echo eula=true > ${MC_HOME}/eula.txt
# 创建启动脚本
tee ${MC_HOME}/startup.sh <<-'EOF'
#!/usr/bin/env bash
MC_HOME=/data/minecraft
(cd ${MC_HOME} && java -jar minecraft-server.jar nogui)
EOF
chmod +x ${MC_HOME}/startup.sh