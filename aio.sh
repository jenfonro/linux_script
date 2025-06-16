#!/bin/bash
##菜单定义
menu_list=(
    "添加自定义服务@custom_service"
    "Oracle云专用功能@oracle"
    "安装python3@python3"
    "安装Node.JS@nodejs"
    "安装Java@java"
)
menu_list2=(
    "选项AA@b11"
    "选项BB@b2"
    "选项CC@c3"
)




## 定义系统判定变量
SYSTEM_DEBIAN="Debian"
SYSTEM_UBUNTU="Ubuntu"
SYSTEM_KALI="Kali"
SYSTEM_DEEPIN="Deepin"
SYSTEM_LINUX_MINT="Linuxmint"
SYSTEM_ZORIN="Zorin"
SYSTEM_RASPBERRY_PI_OS="Raspberry Pi OS"
SYSTEM_REDHAT="RedHat"
SYSTEM_RHEL="Red Hat Enterprise Linux"
SYSTEM_CENTOS="CentOS"
SYSTEM_CENTOS_STREAM="CentOS Stream"
SYSTEM_ROCKY="Rocky"
SYSTEM_ALMALINUX="AlmaLinux"
SYSTEM_FEDORA="Fedora"
SYSTEM_OPENCLOUDOS="OpenCloudOS"
SYSTEM_OPENCLOUDOS_STREAM="OpenCloudOS Stream"
SYSTEM_OPENEULER="openEuler"
SYSTEM_ANOLISOS="Anolis"
SYSTEM_OPENKYLIN="openKylin"
SYSTEM_OPENSUSE="openSUSE"
SYSTEM_ARCH="Arch"
SYSTEM_MANJARO="Manjaro"
SYSTEM_ALPINE="Alpine"
SYSTEM_GENTOO="Gentoo"
SYSTEM_NIXOS="NixOS"
## 定义系统版本文件
File_LinuxRelease=/etc/os-release
File_RedHatRelease=/etc/redhat-release
File_DebianVersion=/etc/debian_version
File_ArmbianRelease=/etc/armbian-release
File_RaspberryPiOSRelease=/etc/rpi-issue
File_openEulerRelease=/etc/openEuler-release
File_OpenCloudOSRelease=/etc/opencloudos-release
File_AnolisOSRelease=/etc/anolis-release
File_OracleLinuxRelease=/etc/oracle-release
File_ArchLinuxRelease=/etc/arch-release
File_ManjaroRelease=/etc/manjaro-release
File_AlpineRelease=/etc/alpine-release
File_GentooRelease=/etc/gentoo-release
File_openKylinVersion=/etc/kylin-version/kylin-system-version.conf
File_ProxmoxVersion=/etc/pve/.version

## 定义颜色和样式变量
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
AZURE='\033[36m'
PLAIN='\033[0m'
BOLD='\033[1m'
SUCCESS="\033[1;32m✔${PLAIN}"
COMPLETE="\033[1;32m✔${PLAIN}"
WARN="\033[1;43m 警告 ${PLAIN}"
ERROR="\033[1;31m✘${PLAIN}"
FAIL="\033[1;31m✘${PLAIN}"
TIP="\033[1;44m 提示 ${PLAIN}"
WORKING="\033[1;36m◉${PLAIN}"

function main() {
    permission_judgment
    collect_system_info
    run_start
    PURE_MODE="${PURE_MODE:-"false"}"
    choose_menu

}
## 错误退出
function output_error() {
    [ "$1" ] && echo -e "\n$ERROR $1\n"
    exit 1
}
## 权限检测
function permission_judgment() {
    if [ $UID -ne 0 ]; then
        echo tt
        output_error "权限不足，请使用 Root 用户运行本脚本"
    fi
}

function collect_system_info() {
    ## 定义系统名称
    SYSTEM_NAME="$(cat $File_LinuxRelease | grep -E "^NAME=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    grep -q "PRETTY_NAME=" $File_LinuxRelease && SYSTEM_PRETTY_NAME="$(cat $File_LinuxRelease | grep -E "^PRETTY_NAME=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    ## 定义系统版本号
    SYSTEM_VERSION_ID="$(cat $File_LinuxRelease | grep -E "^VERSION_ID=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    SYSTEM_VERSION_ID_MAJOR="${SYSTEM_VERSION_ID%.*}"
    SYSTEM_VERSION_ID_MINOR="${SYSTEM_VERSION_ID#*.}"
    ## 定义系统ID
    SYSTEM_ID="$(cat $File_LinuxRelease | grep -E "^ID=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    ## 判定系统处理器架构
    DEVICE_ARCH_RAW="$(uname -m)"
    case "${DEVICE_ARCH_RAW}" in
    x86_64)
        DEVICE_ARCH="x86_64"
        ;;
    aarch64)
        DEVICE_ARCH="ARM64"
        ;;
    armv8l)
        DEVICE_ARCH="ARMv8_32"
        ;;
    armv7l)
        DEVICE_ARCH="ARMv7"
        ;;
    armv6l)
        DEVICE_ARCH="ARMv6"
        ;;
    armv5tel)
        DEVICE_ARCH="ARMv5"
        ;;
    i686)
        DEVICE_ARCH="x86_32"
        ;;
    *)
        DEVICE_ARCH="${DEVICE_ARCH_RAW}"
        ;;
    esac
    ## 判断是否可以使用高级交互式选择器
    CAN_USE_ADVANCED_INTERACTIVE_SELECTION="false"
    if command -v tput &>/dev/null; then
        CAN_USE_ADVANCED_INTERACTIVE_SELECTION="true"
    fi
}

function run_start() {
    if [ -z "${CLEAN_SCREEN}" ]; then
        [ -z "${SOURCE}" ] && clear
    elif [ "${CLEAN_SCREEN}" == "true" ]; then
        clear
    fi
    if [[ "${PURE_MODE}" == "true" ]]; then
        return
    fi
    echo -e "+-----------------------------------+"
    echo -e "欢迎使用 GNU/Linux 脚本"
    local system_name="${SYSTEM_PRETTY_NAME:-"${SYSTEM_NAME} ${SYSTEM_VERSION_ID}"}"
    local arch="${DEVICE_ARCH}"
    local date_time time_zone
    date_time="$(date "+%Y-%m-%d %H:%M")"
    time_zone="$(timedatectl status 2>/dev/null | grep "Time zone" | awk -F ':' '{print$2}' | awk -F ' ' '{print$1}')"

    echo -e ''
    echo -e "运行环境 ${BLUE}${system_name} ${arch}${PLAIN}"
    echo -e "系统时间 ${BLUE}${date_time} ${time_zone}${PLAIN}"
    
}
function run() {
    local choice="$1"
    case "$choice" in
        a)
            echo "你选择了 选项A"
            ;;
        b)
            echo "你选择了 选项B，进入子菜单"
            interactive_select_mirror "${menu_list2[@]}" "\n${BOLD}请选择运行的功能：${PLAIN}\n"
            local sub_choice="${_SELECT_RESULT#*@}"
            run "$sub_choice"  # 子菜单再次调用 run 函数处理
            ;;
        b11)
            echo "$sub_choice"
            ;;
        b2)
            echo "处理子选项B2"
            ;;
        b3)
            echo "处理子选项B3"
            ;;
        c)
            echo "你选择了 选项C"
            ;;
        *)
            echo "未知选择：$choice"
            ;;
    esac
}

function interactive_select_mirror() {
    _SELECT_RESULT=""
    local options=("$@")
    local message="${options[${#options[@]} - 1]}"
    unset options[${#options[@]}-1]
    local selected=0
    local start=0
    local page_size=$(($(tput lines 2>/dev/null) - 3)) # 减去3行用于显示提示信息
    function clear_menu() {
        tput rc 2>/dev/null
        for ((i = 0; i < ${#options[@]} + 1; i++)); do
            echo -e "\r\033[K"
        done
        tput rc 2>/dev/null
    }
    function cleanup() {
        clear_menu
        tput rc 2>/dev/null
        tput cnorm 2>/dev/null
        tput rmcup 2>/dev/null
        echo -e "\n\033[1;44m 提示 \033[0m \033[31m操作已取消\033[0m\n"
        exit 130
    }
    function draw_menu() {
        tput clear 2>/dev/null
        tput cup 0 0 2>/dev/null
        echo -e "${message}"
        local end=$((start + page_size - 1))
        if [ $end -ge ${#options[@]} ]; then
            end=${#options[@]}-1
        fi
        for ((i = start; i <= end; i++)); do
            if [ "$i" -eq "$selected" ]; then
                echo -e "\e[34;4m➤ ${options[$i]%@*}\e[0m"
            else
                echo -e "  ${options[$i]%@*}"
            fi
        done
    }
    function read_key() {
        IFS= read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            IFS= read -rsn2 key
            key="$key"
        fi
        echo "$key"
    }
    tput smcup 2>/dev/null  # 保存当前屏幕并切换到新屏幕
    tput sc 2>/dev/null     # 保存光标位置
    tput civis 2>/dev/null  # 隐藏光标
    trap "cleanup" INT TERM # 捕捉脚本结束时恢复光标
    draw_menu               # 初始化菜单位置
    # 处理选择
    while true; do
        key=$(read_key)
        case "$key" in
        "[A" | "w" | "W")
            # 上箭头 / W
            if [ "$selected" -gt 0 ]; then
                selected=$((selected - 1))
                if [ "$selected" -lt "$start" ]; then
                    start=$((start - 1))
                fi
            fi
            ;;
        "[B" | "s" | "S")
            # 下箭头 / S
            if [ "$selected" -lt $((${#options[@]} - 1)) ]; then
                selected=$((selected + 1))
                if [ "$selected" -ge $((start + page_size)) ]; then
                    start=$((start + 1))
                fi
            fi
            ;;
        "")
            # Enter 键
            tput rmcup
            break
            ;;
        *) ;;
        esac
        draw_menu
    done
    tput cnorm 2>/dev/null # 恢复光标
    tput rmcup 2>/dev/null # 恢复之前的屏幕
    _SELECT_RESULT="${options[$selected]}"
}
function choose_menu()
{
    interactive_select_mirror "${menu_list[@]}" "\n${BOLD}请选择运行的功能：${PLAIN}\n"
    local sub_choice="${_SELECT_RESULT#*@}"
    run "$sub_choice"  # 子菜单再次调用 run 函数处理    
}
main