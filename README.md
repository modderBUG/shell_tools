# shell_tools
`shell_tools`用于快速构linux系统环境。
建新linux或ubuntu系统时常常需要部署环境而浪费大量时间，这个脚本可以一键生成系统环境。
+ 只需要运行 `bash installer.sh` 就能自动挂机部署包括
1. 更新yum/apt源
2. 安装jdk1.8/11稳定版
3. 安装docker并更新为国内源
4. 安装python conda环境、并替换国内源
5. 安装mysql5.7，并启动到3366,基于docker，可自定修改参数。
6. 安装mariaDB10.3.9，并启动到3306,基于docker，可自定修改参数。
8. 安装nginx，并启动到8013,基于docker，可自定修改参数。

## Ubuntu 20.04.1 x64 (通过测试)
### 快速开始
1. `https://github.com/modderBUG/shell_tools.git`
2. `cd shell_tools/ubuntu2004env`
3. `sudo su root` 必须以root运行。
4. `bash installer_apt.sh` 等待完成！
### 说明
+ installer_apt.sh 为

## Linux cent os 7.9 
+ condaConfig.sh

  用于更换linux和windows的pip和conda源,
  
+ nginxConfig.sh

  用于快速安装和配置docker下nginx环境，必须已安装docker
  
+ installer_yum.sh

  centOS7下快速
  
 ## 目前问题
 1. 最后一步安装完conda环境之后仍需要交互安装，但此时已经不在下载组件，因此可以接收。
 2. 没有异常处理，因此必须在有网络环境、root权限下运行。
 
 
 