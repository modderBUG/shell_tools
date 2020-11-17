#!/bin/bash
# Author : wuxiaowei 201117
# ENV : Cent OS 7.9
# DESC : Modify linux source according to environment variables

# yum 换源
function yumOrigen() {
  cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base-repo.bak
  wget http://mirrors.aliyun.com/repo/Centos-7.repo
  yum clean all
  mv Centos-7.repo /etc/yum.repos.d/CentOS-Base.repo
  yum makecache
  yum update
  echo "yum change origen succeed !"
}

# 安装git
function gitInstaller() {
  yum info git
  yum install git
  echo "git installed succeed !"
}
# 安装docker 换源
function dockerInstaller() {
  yum -y install docker
  systemctl start docker
  systemctl status docker
  dockerConfig
  systemctl daemon-reload
  systemctl restart docker
  echo "docker installed succeed !"
}
# 配置docker
function dockerConfig() {
  # json无法启动docker，ubuntu环境。
  tee /etc/docker/daemon.conf <<-'EOF'
{
“registry-mirrors”: [
“https://docker.mirrors.ustc.edu.cn”,
“https://kfwkfulq.mirror.aliyuncs.com”,
“https://2lqq34jg.mirror.aliyuncs.com”,
“https://pee6w651.mirror.aliyuncs.com”,
“https://registry.docker-cn.com”,
“http://hub-mirror.c.163.com”
]
}
EOF
}

# 安装redis
function redisInstaller() {
  docker pull redis:latest
  docker images
  docker run -itd --name redis_master -p 6379:6379 redis
  echo "redis installed succeed !"
}

# 安装mysql
function mysqlInstaller() {
  docker pull mysql:5.7
  mkdir -p "/home/mysql/log"
  mkdir -p "/home/mysql/data"
  mkdir -p "/home/mysql/conf"
  docker run -p 3306:3306 --name mysql_master -v /home/mysql/log:/var/log/mysql -v /home/mysql/data:/var/lib/mysql -v /home/mysql/conf:/etc/mysql -e MYSQL_ROOT_PASSWORD=initpasswd -d mysql:5.7
  docker ps
  echo "mysql57 installed succeed !"
}

# 安装maria
function mariaDBInstaller() {
  docker pull mariadb:10.3.9
  mkdir -p "/home/mariadb/log"
  mkdir -p "/home/mariadb/data"
  mkdir -p "/home/mariadb/conf"
  docker run -p 3366:3306 --name mariadb_master -v /home/mariadb/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=initpasswd -d mariadb:10.3.9
  docker ps
  echo "mariadb installed succeed !"
}

# 运行nginx安装脚本
function nginxInstaller() {
  sh nginxConfig.sh
}

# 安装java
function javaInstaller() {
  # yum search java | grep -i --color jdk
  yum -y install java-1.8.0-openjdk*
  #  yum -y install java-11-openjdk*
  # yum -y remove java-1.7.0-openjdk*
  echo "java installed succeed !"
}

# 安装conda
function condaInstaller() {
  sh condaConfig.sh
  wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash Miniconda3-latest-Linux-x86_64.sh
  source ~/.bashrc
  echo "Miniconda3 installed succeed !"
}
#yumOrigen  #yum 换源
gitInstaller
dockerInstaller
redisInstaller
mysqlInstaller
mariaDBInstaller
nginxInstaller
javaInstaller
condaInstaller
