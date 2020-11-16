#!/bin/bash
set -x
# readme
# 此脚本为配置 ubuntu  xinan 环境

# vagrant destory
# vagrant up
# vagrant

function authUser() {
  echo "切换用户$1"
  su - $1 <<EOF
pwd
whoami

EOF
}

function rootCheck() {
  echo "检查是否为 root 用户"
  if [ $(whoami) != "root" ]; then
    echo " only root can run me"
    exit 1
  fi
}

function historyConf() {
  echo "修改history配置"
  grep -C 10 "HISTFILESIZE" /root/.bashrc
  su - vagrant
  whoami
  rm -f /home/vagrant/.bash_history
  ln -s /Synced/backup/history/vagrant.txt /home/vagrant/.bash_history

  chown -h vagrant:vagrant /home/vagrant/.bash_history
  ll /home/vagrant/.bash_history
  grep -C 10 "HISTFILESIZE" /home/vagrant/.bashrc
  #	HISTSIZE=1000
  #	HISTFILESIZE=2000
  sed -i 's/^HISTSIZE=1000/#HISTSIZE=1000/' /home/vagrant/.bashrc
  sed -i 's/^HISTFILESIZE=2000/#HISTFILESIZE=2000/' /home/vagrant/.bashrc

  sed -i '/^#HISTFILESIZE=2000$/a # 设置保存历史命令的文件大小\nexport HISTFILESIZE=1000000000\n# 保存历史命令条数\nexport HISTSIZE=1000000\n# 实时记录历史命令，默认只有在用户退出之后才会统一记录，很容易造成多个用户间的相互覆盖。\nexport PROMPT_COMMAND="history -a"\n# 记录每条历史命令的执行时间\nexport HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S "' /home/vagrant/.bashrc
  #	# 设置保存历史命令的文件大小
  #	export HISTFILESIZE=1000000000
  #	# 保存历史命令条数
  #	export HISTSIZE=1000000
  #	# 实时记录历史命令，默认只有在用户退出之后才会统一记录，很容易造成多个用户间的相互覆盖。
  #	export PROMPT_COMMAND="history -a"
  #	# 记录每条历史命令的执行时间 %S后空格不要去除
  #	export HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S "

  source /home/vagrant/.bashrc
  echo $HISTSIZE
  echo $HISTFILESIZE

  # 修改root用户

  rm -f /root/.bash_history
  ln -s /Synced/backup/history/root.txt /root/.bash_history

  grep -C 10 "HISTFILESIZE" /root/.bashrc
  #	HISTSIZE=1000
  #	HISTFILESIZE=2000
  sed -i 's/^HISTSIZE=1000/#HISTSIZE=1000/' /root/.bashrc
  sed -i 's/^HISTFILESIZE=2000/#HISTFILESIZE=2000/' /root/.bashrc

  sed -i '/^#HISTFILESIZE=2000$/a # 设置保存历史命令的文件大小\nexport HISTFILESIZE=1000000000\n# 保存历史命令条数\nexport HISTSIZE=1000000\n# 实时记录历史命令，默认只有在用户退出之后才会统一记录，很容易造成多个用户间的相互覆盖。\nexport PROMPT_COMMAND="history -a"\n# 记录每条历史命令的执行时间\nexport HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S "' /root/.bashrc

  source /root/.bashrc
  echo $HISTSIZE
  echo $HISTFILESIZE

  #	必须代码在 EOF 中才生效
  #		authUser phish

  rm -f /home/phish/.bash_history
  ln -s /Synced/backup/history/phish.txt /home/phish/.bash_history

  chown phish:phish /home/phish/.bash_history
  ls -l /home/phish/.bash_history
  grep -C 10 "HISTFILESIZE" /home/phish/.bashrc
  #	HISTSIZE=1000
  #	HISTFILESIZE=2000
  sed -i 's/^HISTSIZE=1000/#HISTSIZE=1000/' /home/phish/.bashrc
  sed -i 's/^HISTFILESIZE=2000/#HISTFILESIZE=2000/' /home/phish/.bashrc

  sed -i '/^#HISTFILESIZE=2000$/a # 设置保存历史命令的文件大小\nexport HISTFILESIZE=1000000000\n# 保存历史命令条数\nexport HISTSIZE=1000000\n# 实时记录历史命令，默认只有在用户退出之后才会统一记录，很容易造成多个用户间的相互覆盖。\nexport PROMPT_COMMAND="history -a"\n# 记录每条历史命令的执行时间\nexport HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S "' /home/phish/.bashrc

  source /home/phish/.bashrc
  echo $HISTSIZE
  echo $HISTFILESIZE

  echo "history 配置完成"

}

function sshConf() {
  echo "远程访问问题"
  #PasswordAuthentication yes
  grep PasswordAuthentication /etc/ssh/sshd_config

  sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

  grep PasswordAuthentication /etc/ssh/sshd_config

  # 重启ssh服务
  /etc/init.d/ssh restart
}

function addUser() {
  # 应用部署用户 -m 创建 /home目录和相关配置
  useradd -m phish

  # 模拟 sftp 用户 #  centos 一样
  useradd -m sydy
  useradd -m sycmss
  adduser phish vagrant

  echo "验证创建用户"
  id phish
  id sydy
  id sycmss
}

function timeZoneUp() {
  echo "#----- time zone start -----#"
  echo "#----- change time zone 更改时区. -----# "
  echo "#----- print timedatectl. -----#"
  timedatectl
  \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  timedatectl set-timezone Asia/Shanghai
  echo "#----- print timedatectl 更改时区 -----#"
  timedatectl
  echo "#----- time zone config end -----#"
}

function pipConf() {
  mkdir ~/.pip

  tee ~/.pip/pip.conf <<-'EOF'
[global]
index-url=http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF

  cat ~/.pip/pip.conf
}

function condaConf() {
  tee ~/.condarc <<-'EOF'
channels:
	- defaults
show_channel_urls: true
channel_alias: http://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
	- http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
	- http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
	- http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
	- http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
	- http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
	conda-forge: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
	msys2: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
	bioconda: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
	menpo: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
	pytorch: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
	simpleitk: http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOF

  cat ~/.condarc
}

function condaInstall() {
  echo "conda  安装 start "

  # 切换用户 phish
  pwd
  type python

  mkdir -p /home/phish/tools
  cd /home/phish/tools
  pwd
  #	wget https://repo.anaconda.com/archive/Anaconda3-4.4.0-Linux-x86_64.sh
  #	wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-4.4.0-Linux-x86_64.sh
  #	cp /Synced/tools/Anaconda3-4.4.0-Linux-x86_64.sh /home/phish/tools/
  #	ls -l /home/phish/tools
  #	chown phish:phish Anaconda3-4.4.0-Linux-x86_64.sh
  #	chmod +x Anaconda3-4.4.0-Linux-x86_64.sh
  # 有交互，需要手动安装
  #	su - phish -c "./Anaconda3-4.4.0-Linux-x86_64.sh"
  cat /home/phish/.bashrc

  su - phish -c "source /home/phish/.bashrc"

  type python3

  pip -V

  pipConf

  #升级pip版本
  pip install --upgrade pip
  pip -V
  pip install freeze
  pip freeze >/Synced/tools/requirements_pip4.txt

  conda -V
  cd /Synced/tools
  # 删除 conda==4.3.30
  pip install -r requirement_pip.txt

  #配置清华源
  condaConf

  conda list -e >/Synced/tools/requirements_pip4.txt

  #清除索引缓存，保证用的是镜像站提供的索引
  conda clean -i

  conda install --yes --file requirements_conda.txt

  conda install paramiko==2.1.2
  conda install pymysql==0.9.3

  conda install tensorflow==1.8.0
  conda install gunicorn==20.0.4

  conda install loguru==0.3.2
  conda install loguru==0.3.2

  conda list | grep -E "paramiko|pymysql|tensorflow|gunicorn|loguru"

  pip install jieba==0.39

  pip install loguru==0.3.2

  echo "conda  安装 end "

}

#timeZoneUp
#
#addUser
#historyConf
#sshConf

# 无法自动，手动处理
#condaInstall
whoami
exit
whoami
