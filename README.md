## My Shells
支持 Java、Node、Go、Groovy、Grails、Maven、Gradle、AndroidSdk、Hadoop 环境的自动配置。

参数说明:   


环境对应的参数命名：
````
#########################
# Java       -> java    #
# Node       -> node    #
# Go         -> golang  #
# Groovy     -> groovy  #
# Grails     -> grails  #
# Maven      -> maven   #
# Gradle     -> gradle  #
# AndroidSdk -> android #
# Hadoop     -> hadoop  #
#########################
````
Usage:
````
bash commons.sh ${env type} ${install dir} ${uid/gid}
````
参数说明:
````
${env type}         # 环境类型
${install dir}      # 安装目录
${uid/gid}          # 用户/组 ID
````
Example:
````
bash commons.sh java /usr/local 1000
````
上面命令的第一个参数 java 可以换成所支持的任意一种环境类型。

## 网络拉取执行
我的服务器nginx对本项目做了映射，可以直接网络拉取并执行。例如
````
curl -sL http://shell.bluerain.io/commons | bash -s java /usr/local 1000
````
-s 后面是参数。

当然，我推荐用release版本的地址:
````
curl -sL http://shell.bluerain.io/release/commons | bash -s java /usr/local 1000
````


更多的环境有待支持:)