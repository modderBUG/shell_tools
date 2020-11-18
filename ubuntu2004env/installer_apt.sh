#!/bin/bash
# Author : wuxiaowei 201117
# ENV : ubuntu 2004 env
# DESC : Modify linux source according to environment variables

function rootCheck() {
  echo "Check Permission :"
  if [ $(whoami) != "root" ]; then
    echo "Permission Denied! please login with 'root'"
    exit 1
  else
    echo ".................................OK! Now,start run bash!"
    sleep 1s
  fi
}

# aptOrigen 换源
function aptOrigen() {
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
  tee /etc/apt/sources.list <<-'EOF'
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF
  sudo apt-get update
  # 有交互，确认！
  sudo apt-get upgrade <<EOF
y
EOF
  echo ".................................apt change origen succeed !"
  sleep 1s
}

# 安装git
function gitInstaller() {
  sudo apt install git
  echo ".................................git installed succeed !"
  sleep 1s
}
# 安装docker 换源
function dockerInstaller() {
  sudo apt update
  # 有交互，确认！
  sudo apt install docker.io <<EOF
y
y
y
EOF
  dockerConfig
  sudo systemctl restart docker
  echo ".................................docker installed succeed !"
  sleep 1s
}
# 配置docker
function dockerConfig() {
  tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": [
"http://hub-mirror.c.163.com",
"https://docker.mirrors.ustc.edu.cn",
"https://kfwkfulq.mirror.aliyuncs.com",
"https://2lqq34jg.mirror.aliyuncs.com",
"https://pee6w651.mirror.aliyuncs.com",
"https://registry.docker-cn.com"
]
}
EOF
}

# 安装redis
function redisInstaller() {
  sudo docker pull redis:latest
  sudo docker images
  sudo docker run -itd --name $2 -p $1:6379 redis
  echo ".................................redis installed succeed !"
  sleep 1s
}

安装mysql
function mysqlInstaller() {
  docker pull mysql:5.7
  mkdir -p "/home/mysql/log"
  mkdir -p "/home/mysql/data"
  mkdir -p "/home/mysql/conf"
  docker run -p $1:3306 --name $2 -v /home/mysql/log:/var/log/mysql -v /home/mysql/data:/var/lib/mysql -v /home/mysql/conf:/etc/mysql -e MYSQL_ROOT_PASSWORD=initpasswd -d mysql:5.7
  docker ps
  echo ".................................mysql57 installed succeed !"
  sleep 1s
}

# 安装maria
function mariaDBInstaller() {
  docker pull mariadb:10.3.9
  mkdir -p "/home/mariadb/log"
  mkdir -p "/home/mariadb/data"
  mkdir -p "/home/mariadb/conf"
  docker run -p $1:3306 --name $2 -v /home/mariadb/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=initpasswd -d mariadb:10.3.9
  docker ps
  echo ".................................mariadb installed succeed !"
  sleep 1s
}

# 运行nginx安装脚本
function nginxInstaller() {
  bash nginxConfig.sh
}

# 安装java
function javaInstaller() {
  sudo apt update
  sudo apt install openjdk-11-jdk <<EOF
y
EOF
  java -version
  echo ".................................Java installed succeed !"
  sleep 1s
}

# 安装conda
function condaInstaller() {
  bash condaConfig.sh
  if [ -e Miniconda3-latest-Linux-x86_64.sh ]; then
    echo "Miniconda3-latest-Linux-x86_64.sh"
  else
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
  fi
  # 有交互，确认！
  bash Miniconda3-latest-Linux-x86_64.sh
  echo ".................................Miniconda3 installed succeed !"
  echo -e "* you can run : \n\n   *  source ~/.bashrc "
  sleep 1s
}
rootCheck
aptOrigen
javaInstaller
dockerInstaller
#gitInstaller    #默认有git
redisInstaller 6379 redis_master
mysqlInstaller 3366 mysql_master
mariaDBInstaller 3306 maria_master
nginxInstaller
condaInstaller
