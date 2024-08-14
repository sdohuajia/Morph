#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

# 检查 Docker 是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker 未安装，正在安装 Docker..."
        # 执行安装命令
        sudo apt update && \
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common && \
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
        sudo apt update && \
        sudo apt install -y docker-ce docker-ce-cli containerd.io && \
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
        sudo chmod +x /usr/local/bin/docker-compose
        echo "Docker 安装完成。"
    else
        echo "Docker 已安装。"
    fi

    # 验证 Docker 安装
    echo "验证 Docker 安装..."
    if sudo docker run hello-world &> /dev/null; then
        echo "Docker 验证成功。"
    else
        echo "Docker 验证失败。"
    fi

    # 验证 Docker Compose 安装
    echo "验证 Docker Compose 安装..."
    if docker-compose --version &> /dev/null; then
        echo "Docker Compose 验证成功。"
    else
        echo "Docker Compose 验证失败。"
    fi
}

# 定义安装节点的函数
install_node() {
    echo "克隆 Dockerfile 存储库..."
    git clone https://github.com/kodaicoder/morphl2-validator.git
    cd morphl2-validator || { echo "无法进入目录 morph"; exit 1; }
    echo "已进入目录 morph。"

    # 添加提示用户按任意键继续
    read -p "请按任意键继续编辑 .env 文件..."

    echo "正在编辑 .env 文件..."
    nano .env
    echo "请设置您的 RPC 和钱包地址以及私钥，然后保存并退出编辑器。"
}

# 启动节点的函数
start_node() {
    echo "正在启动节点..."
    read -p "按回车键开始构建镜像并运行容器..."

    # 建镜像并运行容器
    docker compose up --build -d
    echo "节点正在启动。"
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
        echo "1) 安装节点"
        echo "2) 启动节点"
        echo "3) 退出"
        echo
        read -p "请选择一个选项: " choice
        case $choice in
            1)
                check_docker
                install_node
                ;;
            2)
                check_docker
                start_node
                ;;
            3)
                echo "退出脚本。"
                exit 0
                ;;
            *)
                echo "无效的选项，请重新选择。"
                ;;
        esac
    done
}

# 主程序
main_menu
