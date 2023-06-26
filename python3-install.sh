#!/bin/bash

PY3D=/usr/local
PY3URL=https://www.python.org/ftp/python/3.10.12/Python-3.10.12.tar.xz

#设定jdk安装目录
nohup python3 --version >> /dev/null  2>&1
if [  $? -eq 0 ]; then
echo "检测到已有Python3环境，是否重新安装(yes/no)"
read -p "Detected an existing Python3 environment, do you want to reinstall it (yes/no): " yes;
if [ "$yes" != "yes" ];then
exit
fi
#先删除之前的配置
    rm -rf /usr/bin/python3
    rm -rf /usr/local/bin/pip3.10  /usr/bin/pip3
fi
echo "是否使用清华的yum软件源(yes/no)"
read -p "Do you want to use the yum software source from Tsinghua University (yes/no): " yes;
if [ "$yes" != "yes" ];then
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' -i.bak /etc/yum.repos.d/CentOS-*.repo
fi
    echo "----------------------------------------"
    echo "开始下载依赖环境"
	echo "Start downloading dependent environment"
    echo "----------------------------------------"
	yum -y groupinstall "Development tools"
	yum install -y ncurses-devel gdbm-devel xz-devel sqlite-devel tk-devel uuid-devel readline-devel bzip2-devel libffi-devel
	yum install -y openssl-devel openssl11 openssl11-devel
    echo "----------------------------------------"
    echo "开始下载PYTHON3"
	echo "Start downloading PYTHON3"
    echo "----------------------------------------"
	rm -rf /tmp/python3
	mkdir /tmp/python3
	cd /tmp/
    wget $PY3URL -P /tmp/python3/
	FILENAME=$(ls /tmp/python3/)
    echo "$FILENAME 下载完成"
	echo "$FILENAME Download completed"
    echo "开始解压$FILENAME"
	echo "Start decompressing $FILENAME"
	tar -xf /tmp/python3/$FILENAME -C /tmp/python3/
    echo "----------------------------------------"
    echo "$FILENAME解压完成"
    echo "----------------------------------------"

# 开始编译安装 "----------------------------------------"
echo "开始编译安装"
echo "Start compiling and installing"
	rm -rf /tmp/python3/$FILENAME
	FILENAME=$(ls /tmp/python3/)
	cd /tmp/python3/$FILENAME
# 编译主要需要注意的问题是设置编译FLAG，以便使用最新的openssl库。 "----------------------------------------"
export CFLAGS=$(pkg-config --cflags openssl11)
export LDFLAGS=$(pkg-config --libs openssl11)
./configure --enable-optimizations && make altinstall
# 创建软连接，
ln -sf /usr/local/bin/python3.10 /usr/bin/python3
ln -sf /usr/local/bin/pip3.10  /usr/bin/pip3



#检测是否成功
echo "----------------------------------------"
echo "检测安装是否成功"
echo "Check if the installation was successful"
echo "----------------------------------------"

nohup python3 --version >> /dev/null  2>&1
if [ ! $? -eq 0 ]; then
    rm -rf /usr/bin/python3
	rm -rf /usr/local/bin/pip3.10  /usr/bin/pip3
    echo "Python3安装失败"
    echo "Python3 installation failed"
    echo "已删除Python3命令"
    echo "Removed Python3 command"

    echo "请尝试重新安装"
    echo "Please try reinstalling"
else
    echo "恭喜你，安装成功了$FILENAME"
    echo "Congratulations, the installation was successful $FILENAME"
	echo "----------------------------------------"
	echo "是否将pip源更换为清华pip源 (yes/no)"
	read -p "Do you want to replace the pip source with a Tsinghua pip source (yes/no): " yes;
	if [ "$yes" == "yes" ];then
	pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
	fi
fi
    cd /tmp
	rm -rf /tmp/python3
    exit
