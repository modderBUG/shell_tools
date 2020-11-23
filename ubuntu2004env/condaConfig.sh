#!/bin/bash
# Author : wuxiaowei 201116
# DESC : Modify linux source according to environment variables
echo ${HOME}
path=${HOME}

getPath() {
  if [ $1 = 'win' ]; then
    echo home content at ${path:1:1}:/${path:3:${#path}}
    home_path=${path:1:1}:/${path:3:${#path}}

    pip_content=$home_path/pip # Modify
    pip_path=$pip_content/pip.ini
    echo pip content at: $pip_path

  else
    echo home content at ${HOME}
    home_path=${HOME}

    pip_content=$home_path/.pip # Modify
    pip_path=$pip_content/pip.conf
    echo pip content at: $pip_path
  fi

  conda_path=$home_path/.condarc # Modify
  echo conda_path content at: $conda_path
}

writePip() {
  pip install pip -U
  pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  echo write file to $1
}

writeConda() {
  tee $1 <<-EOF
channels:
  - defaults
show_channel_urls: true
channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOF
  echo write file to $1
}

winDoWork() {
  echo now , we start run the windows command ...
  mkdir $pip_content
  writePip $pip_path
  writeConda $conda_path
}

linuxDoWork() {
  echo now , we start run the linux command ...
  mkdir $pip_content
  writePip $pip_path
  writeConda $conda_path
}

getSysEnv() {
  echo "what is your system platform?:linux|win "
  #  read sys
  sys='linux'
  #  sys=$sys
}
getSysEnv
getPath $sys
if [ $sys = 'win' ]; then
  winDoWork
else
  linuxDoWork
fi

echo 'ok ! press any key to continue'
sleep 2s
#read a
