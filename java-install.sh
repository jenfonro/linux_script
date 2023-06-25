#!/bin/bash
echo "请输入要安装的java版本"
read -p "Please enter the Java version to be installed(17/20): " JDKVER;
if [ "$JDKVER" == "17" ];then
JDKURL=https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz
else
if [ "$JDKVER" == "20" ];then
JDKURL=https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.tar.gz
else
echo "Please enter the Java version to be installed"
echo "请输入要安装的java版本"
fi
fi
JDKD=/usr/local


#设定jdk安装目录
nohup java -version >> /dev/null  2>&1
if [  $? -eq 0 ]; then
echo "检测到已有java环境，是否重新安装(yes/no)"
read -p "Detected an existing Java environment, do you want to reinstall it (yes/no): " yes;
if [ "$yes" != "yes" ];then
exit
else
#先删除之前的配置
    rm -rf $JDKD/java
	sed -i '/export JAVA_HOME=\/usr\/local\/java/d' /etc/profile
    sed -i '/export PATH=$PATH:$JAVA_HOME\/bin;/d' /etc/profile
    sed -i '/export CLASSPATH=.:$JAVA_HOME\/lib\/dt.jar:$JAVA_HOME\/lib\/tools.jar;/d' /etc/profile
fi
fi

    echo "----------------------------------------"
    echo "开始下载jdk-$JDKVER"
	echo "Start downloading jdk-$JDKVER"
    echo "----------------------------------------"
	rm -rf /tmp/java
	mkdir /tmp/java
	cd /tmp/
    wget $JDKURL -P /tmp/java/
	JDKFILENAME=$(ls /tmp/java/)
    echo "$JDKFILENAME 下载完成"
	echo "$JDKFILENAME Download completed"
    echo "开始解压$JDKFILENAME"
	echo "Start decompressing $JDKFILENAME"
	tar -zxf /tmp/java/$JDKFILENAME -C /tmp/java/
    echo "----------------------------------------"
    echo "jdk-$JDKVER解压完成"
    echo "----------------------------------------"
if [ -d $JDKD/java ]; then
#echo "$JDKD/java 存在"
    #删除java目录
    rm -rf $JDKD/java/*
fi


# 配置java环境echo "----------------------------------------"
echo "开始配置java环境"
echo "Start configuring the Java environment"
	rm -rf /tmp/java/$JDKFILENAME
	JDKFILENAME=$(ls /tmp/java/)
	mv /tmp/java/$JDKFILENAME $JDKD/java
echo "添加全局变量"
echo "Add Global variable"
echo "----------------------------------------"
    sed -i '/export JAVA_HOME=\/usr\/local\/java/d' /etc/profile
    sed -i '/export PATH=$PATH:$JAVA_HOME\/bin;/d' /etc/profile
    sed -i '/export CLASSPATH=.:$JAVA_HOME\/lib\/dt.jar:$JAVA_HOME\/lib\/tools.jar;/d' /etc/profile
#grep "JAVA_HOME=" /etc/profile
#    if [ ! $? -eq 0 ]; then
    sed -i '$a export JAVA_HOME='$JDKD'/java' /etc/profile
    sed -i '$a export PATH=$PATH:$JAVA_HOME/bin;' /etc/profile
    sed -i '$a export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar;' /etc/profile
    echo "----------------------------------------"
    echo "java环境配置完成"
	echo "Java environment configuration completed"
    echo "----------------------------------------"
#    else
#    echo "----------------------------------------"
#    echo "java环境全局变量已存在"
#    echo "----------------------------------------"
#    fi
#检测配置是否成功
echo "----------------------------------------"
echo "检测配置是否成功"
echo "Check if the configuration was successful"
echo "----------------------------------------"
source /etc/profile
nohup java -version >> /dev/null  2>&1
if [ ! $? -eq 0 ]; then
    rm -rf $JDKD/java/*
    rmdir $JDKD/java
    sed -i '/export JAVA_HOME=\/usr\/local\/java/d' /etc/profile
    sed -i '/export PATH=$PATH:$JAVA_HOME\/bin;/d' /etc/profile
    sed -i '/export CLASSPATH=.:$JAVA_HOME\/lib\/dt.jar:$JAVA_HOME\/lib\/tools.jar;/d' /etc/profile
    echo "java安装失败"
    echo "Java installation failed"
    echo "已删除java环境变量"
    echo "Removed Java environment variable"
    echo "已删除/etc/profile/java"
    echo "Removed/etc/profile/a"
    echo "请尝试重新安装"
    echo "Please try reinstalling"
	
    echo "============================================"
    echo "jdk安装失败可能的原因："
    echo "Possible causes of jdk installation failure："
    echo "下载的 jdk-$JDKVER压缩包损坏"
    echo "The existing jdk-$JDKVER compressed package is damaged"

else
    echo "恭喜你，安装成功了jdk-$JDKVER"
    echo "Congratulations, the installation was successful jdk-$JDKVER"
fi
    rm -rf /tmp/java
    exit
