## My Shells
支持 Java、Scala、Node、Go、Rust、Groovy、Grails、Maven、Gradle、AndroidSdk、Hadoop 环境的自动配置。

参数说明:   


环境对应的参数命名：

````
#########################
# Java       -> java    #
# Scala      -> scala   #
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
````
Usage:

````shell
bash commons.sh ${environment} ${path} ${uid/gid}
````
参数说明:

````
environment         # 环境类型
path                # 安装目录
uid/gid             # 用户/组 ID
````
Example:

````shell
bash commons.sh java /usr/local 1000
````
上面命令的第一个参数 java 可以换成所支持的任意一种环境类型。   
注意：Rust环境由于是自带安装脚本的，所以当第一个参数为 rust 的时候并不理会之后的两个参数（安装目录和权限不需要），所以可以省略为一个参数: .sh rust

## 网络拉取执行
我的服务器 nginx 对本项目做了映射，可以直接网络拉取并执行。例如

````shell
curl -sL http://shell.bluerain.io/commons | bash -s java /usr/local 1000
````
-s 后面是参数。

当然，我推荐用 release 版本的地址:

````shell
curl -sL http://shell.bluerain.io/release/commons | bash -s java /usr/local 1000
````

### 注意
1. 上述有些环境的包是从海外节点拉取下来的，可能出现网络问题。如果走代理(例如 proxychains 工具)则是:

    ````
    curl -sL http://shell.bluerain.io/release/commons | proxychains bash -s java /usr/local 1000
    ````   
2. 所有的脚本由于要写入环境变量，所以需要使用 ROOT 来执行。如果是非 root 用户，则应该:

    ````
    curl -sL http://shell.bluerain.io/release/commons | sudo bash -s java /usr/local 1000
    ````   
    这也是第三个参数 (uid/gid) 存在的理由。因为如果是 sudo 提权执行的脚本，那么生成的目录是 root 所属的，会造成权限问题。所以需要指定安装后目录的权限 所属。   
    一般来讲，安装系统时生成的非 root 用户（自己设置的）的 u/gid 是1000，root 是0。当然第三个参数用名称也行，例如:
    
    ````
    curl -sL http://shell.bluerain.io/release/commons | sudo bash -s java /usr/local hentioe
    ````   
更多的环境有待支持:)
