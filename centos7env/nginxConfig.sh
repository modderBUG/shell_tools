#!/bin/bash
# Author : wuxiaowei 201117
# DESC : Modify linux source according to environment variables

function nginxConfig() {
  docker pull nginx:latest
  mkdir -p "/home/$2/dist"
  docker run -di -v /home/$2:/home/$2 --name=$2 -p $1:80 nginx
  #  docker cp $2:/etc/nginx/nginx.conf nginx.conf
  #  echo "注意：需要编写nginx配置文件(warn: Need to write nginx configuration file):"
  #  read xxx
  #  vi nginx.conf
  tee nginx.conf <<-'EOF'
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;
server
    {
        listen 0.0.0.0:80;
        #server_name 123.57.147.211;
        index index.html;
        root  /home/nginx_master/dist;  #dist上传的路径
        # 避免访问出现 404 错误
        location / {
          try_files $uri $uri/ @router;
          index  index.html;
        }
        location @router {
          rewrite ^.*$ /index.html last;
        }
    }
    #include /etc/nginx/conf.d/*.conf;
}
EOF
  sed -i "s#home/nginx_master/dist#home/${2}/dist#" nginx.conf
  docker cp nginx.conf $2:/etc/nginx/nginx.conf
  docker restart $2
  docker ps
  echo "................................nginx installed succeed !"
  sleep 2s
}

port=$1
name=$2
nginxConfig "${port:-8013}" "${name:-nginx_master}"
