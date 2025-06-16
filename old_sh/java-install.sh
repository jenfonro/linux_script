#!/bin/bash
BASENAME="Java"
nohup node -v >> /dev/null  2>&1
if [  $? -eq 0 ]; then
read -p "检测到已有${BASENAME}环境，是否重新安装[y/n] (默认不安装) " yes;
if [ "$yes" != "y" ];then
exit
fi

fi

echo "请输入要安装的${BASENAME}版本的下载链接"
read -p "默认版本：20 ：" VERSION;
if [ "$VERSION" == "" ];then
DOWNLOADURL=https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.tar.gz
else
if [ "$VERSION" == "20" ];then
DOWNLOADURL=https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.tar.gz
else
if [ "$VERSION" == "17" ];then
DOWNLOADURL=https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz
else
DOWNLOADURL=${VERSION}
fi
fi
fi


#设定安装目录
DIR=/usr/local


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
	sudo mv /tmp/${BASENAME}/${FILENAME} ${DIR}/${BASENAME}
	echo "添加${BASENAME}到快捷命令"
	DIRB=$(echo ${DIR}/${BASENAME} | sed 's/\//\\\//g')
	sudo sed -i '/export JAVA_HOME='${DIRB}'/d' /etc/profile
    sudo sed -i '/export PATH=$PATH:$JAVA_HOME\/bin;/d' /etc/profile
    sudo sed -i '/export CLASSPATH=.:$JAVA_HOME\/lib\/dt.jar:$JAVA_HOME\/lib\/tools.jar;/d' /etc/profile
    sudo sed -i '$a export JAVA_HOME='${DIRB} /etc/profile
    sudo sed -i '$a export PATH=$PATH:$JAVA_HOME/bin;' /etc/profile
    sudo sed -i '$a export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar;' /etc/profile
	sudo rm -rf /usr/bin/java
	sudo ln -s ${DIR}/${BASENAME}/bin/java /usr/bin

#检测配置是否成功

source /etc/profile
sleep 2s
nohup java -version >> /dev/null  2>&1
if [ ! $? -eq 0 ]; then
	sudo sed -i '/export JAVA_HOME='${DIRB}'/d' /etc/profile
    sudo sed -i '/export PATH=$PATH:$JAVA_HOME\/bin;/d' /etc/profile
    sudo sed -i '/export CLASSPATH=.:$JAVA_HOME\/lib\/dt.jar:$JAVA_HOME\/lib\/tools.jar;/d' /etc/profile
	sudo rm -rf /usr/bin/java
    echo "============================================"
    echo "${BASENAME}安装失败可能的原因："
    echo "下载的 ${BASENAME}压缩包损坏"
    echo "============================================"

else
    echo "恭喜你，安装成功了${BASENAME}"
	
fi
    sudo rm -rf /tmp/${BASENAME}
    exit
