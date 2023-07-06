#!/bin/bash
BASENAME="Node.js"
nohup node -v >> /dev/null  2>&1
if [  $? -eq 0 ]; then
read -p "检测到已有${BASENAME}环境，是否重新安装[y/n] (默认不安装) " yes;
if [ "$yes" != "y" ];then
exit
fi

fi

echo "请输入要安装的${BASENAME}版本的下载链接"
read -p "默认版本：18.16.1 ：" VERSION;
if [ "$VERSION" == "" ];then
DOWNLOADURL=https://nodejs.org/dist/v18.16.1/node-v18.16.1-linux-x64.tar.xz
else
DOWNLOADURL=${VERSION}
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
	sudo rm -rf /usr/bin/node
	sudo rm -rf /usr/bin/npm
	sudo rm -rf /usr/bin/npx
	sudo rm -rf /usr/bin/pnpm
	sudo rm -rf /usr/bin/pnpx
	sudo rm -rf /usr/bin/yarn
	sudo rm -rf /usr/bin/yarnpkg

	sudo ln -s ${DIR}/${BASENAME}/bin/node /usr/bin
	sudo ln -s ${DIR}/${BASENAME}/bin/npm /usr/bin
	sudo ln -s ${DIR}/${BASENAME}/bin/npx /usr/bin
	sudo ln -s ${DIR}/${BASENAME}/bin/pnpm /usr/bin
	sudo ln -s ${DIR}/${BASENAME}/bin/pnpx /usr/bin
	sudo ln -s ${DIR}/${BASENAME}/bin/yarn /usr/bin
	sudo ln -s ${DIR}/${BASENAME}/bin/yarnpkg /usr/bin

#检测配置是否成功

echo "检测安装是否成功"

sleep 2s
nohup node -v >> /dev/null  2>&1
if [ ! $? -eq 0 ]; then
	sudo rm -rf /usr/bin/node
	sudo rm -rf /usr/bin/npm
	sudo rm -rf /usr/bin/npx
	sudo rm -rf /usr/bin/pnpm
	sudo rm -rf /usr/bin/pnpx
	sudo rm -rf /usr/bin/yarn
	sudo rm -rf /usr/bin/yarnpkg
	
    echo "============================================"
    echo "${BASENAME}安装失败可能的原因："
    echo "下载的 ${BASENAME}压缩包损坏"
    echo "============================================"

else
    echo "恭喜你，安装成功了${BASENAME}"
	read -p "是否安装pnpm、yarn [y/n]（默认安装）" yes;
	if [ "$yes" == "n" ];then
    sudo rm -rf /tmp/${BASENAME}
    exit
	else
		if [ "$yes" == "no" ];then
    sudo rm -rf /tmp/${BASENAME}
    exit
	fi
	fi
	sudo npm install -g pnpm
	sudo npm install -g yarn
	sleep 2s
	nohup pnpm -v >> /dev/null  2>&1
	if [ ! $? -eq 0 ]; then
	echo "============================================"
    echo "pnpm安装失败"
    echo "安装失败可能的原因：网络连接失败"
	echo "请运行命令手动安装pnpm：npm install -g pnpm"
    echo "============================================"
	fi
	nohup yarn -v >> /dev/null  2>&1
	if [ ! $? -eq 0 ]; then
	echo ""
	echo "============================================"
    echo "yarn安装失败"
    echo "安装失败可能的原因：网络连接失败"
		echo "请运行命令手动安装pnpm：npm install -g yarn"
    echo "============================================"
	fi
	
fi
    sudo rm -rf /tmp/${BASENAME}
    exit
