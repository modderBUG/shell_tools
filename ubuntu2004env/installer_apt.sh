#!/bin/bash
# Author : wuxiaowei 201117
# ENV : Cent OS 7.9
# DESC : Modify linux source according to environment variables

function rootCheck() {
  echo "Check Permission :"
  if [ $(whoami) != "root" ]; then
    echo "Permission Denied! please login with 'root'"
    exit 1
  else
    echo "ok!"
  fi
}

# aptOrigen 换源
function aptOrigen() {
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
  tee /etc/apt/sources.list <<-'EOF'
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
EOF
  sudo apt-get update
  sudo apt-get upgrade
  echo "apt change origen succeed !"
}

# 安装git
function gitInstaller() {
  yum info git
  yum install git
  echo "git installed succeed !"
}
# 安装docker 换源
function dockerInstaller() {
  sudo apt update
  sudo apt install docker.io
  dockerConfig
  sudo systemctl restart docker
  echo "docker installed succeed !"
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
  sudo docker run -itd --name redis_master -p 6379:6379 redis
  echo "redis installed succeed !"
}

安装mysql
function mysqlInstaller() {
  docker pull mysql:5.7
  mkdir -p "/home/mysql/log"
  mkdir -p "/home/mysql/data"
  mkdir -p "/home/mysql/conf"
  docker run -p 3366:3306 --name mysql_master -v /home/mysql/log:/var/log/mysql -v /home/mysql/data:/var/lib/mysql -v /home/mysql/conf:/etc/mysql -e MYSQL_ROOT_PASSWORD=initpasswd -d mysql:5.7
  docker ps
  echo "mysql57 installed succeed !"
}

# 安装maria
function mariaDBInstaller() {
  docker pull mariadb:10.3.9
  mkdir -p "/home/mariadb/log"
  mkdir -p "/home/mariadb/data"
  mkdir -p "/home/mariadb/conf"
  docker run -p 3306:3306 --name mariadb_master -v /home/mariadb/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=initpasswd -d mariadb:10.3.9
  docker ps
  echo "mariadb installed succeed !"
}

# 运行nginx安装脚本
function nginxInstaller() {
  bash nginxConfig.sh
}

# 安装java
function javaInstaller() {
  sudo apt update
  sudo apt install openjdk-11-jdk
  java -version
  echo "java installed succeed !"
}

# 安装conda
function condaInstaller() {
  bash condaConfig.sh
  wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash Miniconda3-latest-Linux-x86_64.sh
  source ~/.bashrc
  echo "Miniconda3 installed succeed !"
}
rootCheck
aptOrigen
dockerInstaller
gitInstaller
redisInstaller
mysqlInstaller
mariaDBInstaller
nginxInstaller
javaInstaller
condaInstaller
