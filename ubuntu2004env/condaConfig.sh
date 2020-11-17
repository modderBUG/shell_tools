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
  echo -e "[global]\nindex-url = https://mirrors.aliyun.com/pypi/simple\n[install]\nuse-mirrors =truenmirrors =https://mirrors.aliyun.com/pypi/simple\ntrusted-host =https://mirrors.aliyun.com/pypi/simple" >>$1
  echo write file to $1
}

writeConda() {
  echo -e "channels:\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free\nssl_verify: false\nshow_channel_urls: true" >>$1
  echo write file to $1
}

winDoWork() {
  echo now , we start run the windows command ...
  mkdir $pip_content
  writePip $pip_path
  writeConda $conda_path
}

linuxDoWork() {
  echo now , we start run the windows command ...
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
read a
