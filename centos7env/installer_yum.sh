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
    sleep 1s
  fi
}

# yum 换源
function yumOrigen() {
  cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base-repo.bak
  wget http://mirrors.aliyun.com/repo/Centos-7.repo
  yum clean all
  mv Centos-7.repo /etc/yum.repos.d/CentOS-Base.repo
  yum makecache
  yum update
  echo "................................yum change origen succeed !"
  sleep 1s
}

# 安装git
function gitInstaller() {
  yum info git
  yum install git
  echo "................................git installed succeed !"
  sleep 1s
}
# 安装docker 换源
function dockerInstaller() {
  yum -y install docker
  systemctl start docker
  systemctl status docker
  dockerConfig
  systemctl daemon-reload
  systemctl restart docker
  echo "................................docker installed succeed !"
  sleep 1s
}
# 配置docker
function dockerConfig() {
  # json无法启动docker，ubuntu环境。
  tee /etc/docker/daemon.conf <<-'EOF'
{
"registry-mirrors": [
"https://docker.mirrors.ustc.edu.cn",
"https://kfwkfulq.mirror.aliyuncs.com",
"https://2lqq34jg.mirror.aliyuncs.com",
"https://pee6w651.mirror.aliyuncs.com",
"https://registry.docker-cn.com",
"http://hub-mirror.c.163.com"
]
}
EOF
}

# 安装redis
function redisInstaller() {
  docker pull redis:latest
  docker images
  docker run -itd --name $2 -p $1:6379 redis
  echo "................................redis installed succeed !"
  sleep 1s
}

# 安装mysql
function mysqlInstaller() {
  docker pull mysql:5.7
  mkdir -p "/home/mysql/log"
  mkdir -p "/home/mysql/data"
  mkdir -p "/home/mysql/conf"
  docker run -p $1:3306 --name $2 -v /home/mysql/log:/var/log/mysql -v /home/mysql/data:/var/lib/mysql -v /home/mysql/conf:/etc/mysql -e MYSQL_ROOT_PASSWORD=initpasswd -d mysql:5.7
  docker ps
  echo "................................mysql57 installed succeed !"
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
  echo "................................mariadb installed succeed !"
  sleep 1s
}

# 运行nginx安装脚本
function nginxInstaller() {
  bash nginxConfig.sh $1 $2
}

# 安装java
function javaInstaller() {
  # yum search java | grep -i --color jdk
  yum -y install java-1.8.0-openjdk*
  #  yum -y install java-11-openjdk*
  # yum -y remove java-1.7.0-openjdk*
  echo "................................java installed succeed !"
  sleep 1s
}

# 安装conda
function condaInstaller() {
  sh condaConfig.sh
  wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash Miniconda3-latest-Linux-x86_64.sh
  echo -e "* you can run : \n\n   *  source ~/.bashrc "
  echo "................................Miniconda3 installed succeed !"
  sleep 1s
}
rootCheck
yumOrigen  #yum 换源
javaInstaller
dockerInstaller
gitInstaller
redisInstaller 6379 redis_master
mysqlInstaller 3366 mysql_master
mariaDBInstaller 3306 maria_master
nginxInstaller 8013 nginx_master
condaInstaller
