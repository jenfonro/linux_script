#!/bin/bash
lsb_release -a |grep Centos >> /dev/null  2>&1 
if [  $? -eq 0 ]; then
echo "此脚本仅支持Centos"
exit
fi
BASENAME="Python3"
nohup python3 --version >> /dev/null  2>&1
if [  $? -eq 0 ]; then
read -p "检测到已有${BASENAME}环境，是否重新安装[y/n] (默认不安装) " yes;
if [ "$yes" != "y" ];then
exit
fi

fi

echo "请输入要安装的${BASENAME}版本的下载链接"
read -p "默认版本：3.10.12 ：" VERSION;
if [ "$VERSION" == "" ];then
DOWNLOADURL=https://www.python.org/ftp/python/3.10.12/Python-3.10.12.tar.xz
else
DOWNLOADURL=${VERSION}
fi


#设定安装目录
DIR=/usr/bin

echo "是否使用清华的yum软件源(yes/no)"
read -p "Do you want to use the yum software source from Tsinghua University (yes/no): " yes;
sudo yum install epel-release -y
if [ "$yes" != "yes" ];then
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' -i.bak /etc/yum.repos.d/CentOS-*.repo
sudo sed -e 's!^metalink=!#metalink=!g' -e 's!^#baseurl=!baseurl=!g' -e 's!https\?://download\.fedoraproject\.org/pub/epel!https://mirrors.tuna.tsinghua.edu.cn/epel!g' -e 's!https\?://download\.example/pub/epel!https://mirrors.tuna.tsinghua.edu.cn/epel!g' -i /etc/yum.repos.d/epel*.repo
fi

    echo "----------------------------------------"
    echo "开始下载${BASENAME}"
    echo "----------------------------------------"
	sudo rm -rf /tmp/${BASENAME}
	sudo mkdir /tmp/${BASENAME}
    sudo wget $DOWNLOADURL -P /tmp/${BASENAME}/
	FILENAME=$(ls /tmp/${BASENAME}/)
	if [ "${FILENAME}" == "" ];then
	echo "${BASENAME}下载失败,请重新运行"
	exit
	fi
    echo "${BASENAME} 下载完成"
    echo "开始解压${FILENAME}"
	sudo tar -xf /tmp/${BASENAME}/$FILENAME -C /tmp/${BASENAME}/
    echo "----------------------------------------"
    echo "${BASENAME}解压完成"
    echo "----------------------------------------"

if [ -d ${DIR}/${BASENAME} ]; then
#echo "安装目录存在"
    #删除安装目录
    sudo rm -rf ${DIR}/${BASENAME}
fi



echo "开始配置${BASENAME}环境"
	sudo rm -rf /tmp/${BASENAME}/${FILENAME}
	FILENAME=$(ls /tmp/${BASENAME}/)
	cd /tmp/${BASENAME}/
	echo "开始编译安装"
	# 编译主要需要注意的问题是设置编译FLAG，以便使用最新的openssl库。 "----------------------------------------"
	export CFLAGS=$(pkg-config --cflags openssl11)
	export LDFLAGS=$(pkg-config --libs openssl11)
	./configure --enable-optimizations && make altinstall
	# 创建软连接，
	ln -sf /usr/local/bin/python3.10 /usr/bin/python3
	ln -sf /usr/local/bin/pip3.10  /usr/bin/pip3
#检测配置是否成功

source /etc/profile
sleep 2s
nohup python3 --version >> /dev/null  2>&1
if [ ! $? -eq 0 ]; then
	sudo rm -rf /usr/bin/python3 /usr/bin/pip3
    echo "============================================"
    echo "${BASENAME}安装失败可能的原因："
    echo "下载的 ${BASENAME}压缩包损坏"
    echo "============================================"

else
    echo "恭喜你，安装成功了${BASENAME}"
	read -p "是否将pip源更换为清华pip源 [y/n](默认是)): " 
	if [ "$yes" != "n" ];then
	pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
	fi
	if [ "$yes" != "no" ];then
	pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
	fi
	
fi
    sudo rm -rf /tmp/${BASENAME}
    exit
