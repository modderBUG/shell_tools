#!/bin/bash

function dockerInstaller() {
  yum -y install docker
  systemctl start docker
  systemctl status docker
  exit 1
  dockerConfig
  systemctl daemon-reload
  systemctl restart docker
}

function dockerConfig() {
  tee /etc/docker/daemon.json <<-'EOF'
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

function redisInstaller() {
  docker pull redis:latest
  docker images
  docker run -itd --name redis_master -p 6379:6379 redis
  echo "redis installed succeed !"
}

function mysqlInstaller() {
  docker pull mysql:5.7
  mkdir "/home/mysql/log"
  mkdir "/home/mysql/data"
  mkdir "/home/mysql/conf"
  docker run -p 3306:3306 --name mysql_master -v /home/mysql/log:/var/log/mysql -v /home/mysql/data:/var/lib/mysql -v /home/mysql/conf:/etc/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7
  docker ps
  echo "mysql57 installed succeed !"
}

function nginxInstaller() {
  docker pull nginx:latest
  mkdir "/home/nginx/conf"
  docker run -di -v /home:/home --name=nginx_master -p 8013:80 nginx
  docker cp nginx_master:/etc/nginx/nginx.conf nginx.conf
  echo "注意：需要编写nginx配置文件(warn: Need to write nginx configuration file):"
  read xxx
  vi nginx.conf
  docker cp nginx.conf nginx_master:/etc/nginx/nginx.conf
  docker restart nginx_master
  docker ps
  echo "nginx installed succeed !"
}

function javaInstall() {
  yum -y install java-1.8.0-openjdk*
  # yum -y remove java-1.7.0-openjdk*
  echo "java installed succeed !"
}

function condaInstall() {
  sh set_env.sh
  wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash Miniconda3-latest-Linux-x86_64.sh
}
dockerInstaller
