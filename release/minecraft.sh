#!/usr/bin/env bash
MC_HOME=/data/minecraft
if [ ! -e ${MC_HOME} ]; then mkdir -p ${MC_HOME};fi
if [ ! -e /usr/bin/wget ];then apt install wget -y;fi
VERSION_ADDRESS=https://launcher.mojang.com/mc/game/1.10.2/server/3d501b23df53c548254f5e3f66492d178a48db63/server.jar
if test $1;then VERSION_ADDRESS=$1;fi
wget -O ${MC_HOME}/minecraft_server.jar \
${VERSION_ADDRESS}
cp ${MC_HOME}/minecraft_server.jar /data/.minecraft_server.jar
echo ${VERSION_ADDRESS} > /data/.version
echo eula=true > ${MC_HOME}/eula.txt
tee ${MC_HOME}/startup.sh <<-'EOF'
#!/usr/bin/env bash
JVM_OPTS='-Xmx1024M -Xms1024M'
MC_HOME=/data/minecraft
boot-log(){
    echo "Boot Script/Log: $1"
}
reset(){
    boot-log 'reseting...'
    cp /data/.minecraft_server.jar ${MC_HOME}/minecraft_server.jar
    cp /usr/local/bin/start-mc-server ${MC_HOME}/startup.sh
    echo eula=true > ${MC_HOME}/eula.txt
}
boot(){
    if [ ! -e ${MC_HOME}/minecraft_server.jar ];then reset;fi
    boot-log 'booting...'
    (cd ${MC_HOME} && java ${JVM_OPTS} -jar minecraft_server.jar nogui)
}
main(){
    if ! test $0 = "${MC_HOME}/startup.sh";then
        if [ ! -e ${MC_HOME}/startup.sh ];then 
            reset
            main
        else 
            ${MC_HOME}/startup.sh
        fi
    else
        boot
    fi
}
main
EOF
chmod +x ${MC_HOME}/startup.sh
