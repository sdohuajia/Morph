#!/bin/bash

# 使脚本在遇到任何错误时立即退出
set -e

# 函数：检查 Docker 是否已安装
check_docker() {
    if command -v docker > /dev/null 2>&1; then
        echo "Docker 已安装。"
        return 0
    else
        echo "Docker 未安装。"
        return 1
    fi
}

# 函数：安装 Docker
install_docker() {
    echo "正在安装 Docker..."

    # 更新包索引
    sudo apt-get update
    
    # 升级所有现有的软件包
    sudo apt-get upgrade -y
    
    # 安装必要的依赖包
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    
    # 添加 Docker 官方的 GPG 密钥
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
    # 添加 Docker 仓库
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    
    # 更新包索引
    sudo apt-get update
    
    # 安装 Docker CE
    sudo apt-get install -y docker-ce
    
    # 启动 Docker 服务
    sudo systemctl start docker
    
    # 设置 Docker 开机自启
    sudo systemctl enable docker
    
    # 验证 Docker 安装
    if command -v docker > /dev/null 2>&1; then
        echo "Docker 安装成功。"
    else
        echo "Docker 安装失败。"
        exit 1
    fi
}

# 函数：克隆 Dockerfile 存储库
clone_dockerfile_repo() {
    echo "正在克隆 Dockerfile 存储库..."
    git clone --branch release/v0.2.x https://github.com/morph-l2/morph.git
    if [ $? -eq 0 ]; then
        echo "Dockerfile 存储库克隆成功。"
    else
        echo "Dockerfile 存储库克隆失败。"
        exit 1
    fi
}

# 函数：进入指定目录
enter_directory() {
    echo "进入目录 morph/ops/publicnode..."
    cd morph/ops/publicnode
    if [ $? -eq 0 ]; then
        echo "成功进入 ops/publicnode 目录。"
    else
        echo "无法进入 ops/publicnode 目录。"
        exit 1
    fi
}

# 函数：编辑 .env 文件
edit_env_file() {
    echo "正在打开 .env 文件进行编辑..."
    nano .env
    if [ $? -eq 0 ]; then
        echo ".env 文件编辑完成。"
    else
        echo "无法编辑 .env 文件。"
        exit 1
    fi
}

# 函数：运行节点
run_node() {
    echo "正在运行节点..."
    make run-holesky-node
    if [ $? -eq 0 ]; then
        echo "节点运行成功。"
    else
        echo "节点运行失败。"
        exit 1
    fi
}

# 主菜单函数
main_menu() {
    while true; do
        clear
        echo "脚本由大赌社区哈哈哈哈编写，推特 @ferdie_jhovie，免费开源，请勿相信收费"
        echo "================================================================"
        echo "节点社区 Telegram 群组: https://t.me/niuwuriji"
        echo "节点社区 Telegram 频道: https://t.me/niuwuriji"
        echo "节点社区 Discord 社群: https://discord.gg/GbMV5EcNWF"
        echo "退出脚本，请按键盘 ctrl+c 退出即可"
        echo "请选择要执行的操作:"
        echo "1) 启动节点"
        echo "2) 退出"
        echo
        read -p "请选择一个选项: " choice
        case $choice in
            1)
                start_node
                ;;
            2)
                echo "退出脚本。"
                exit 0
                ;;
            *)
                echo "无效的选项，请重新选择。"
                ;;
        esac
    done
}

# 函数：启动节点
start_node() {
    echo "检查 Docker 安装情况..."
    if check_docker; then
        echo "Docker 已安装，无需安装。"
    else
        install_docker
    fi

    # 克隆 Dockerfile 存储库
    clone_dockerfile_repo

    # 进入指定目录
    enter_directory

    # 编辑 .env 文件
    edit_env_file

    # 运行节点
    run_node
}

# 主程序
main_menu
