#!/bin/bash

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
        exit 1
    fi

    # 验证 Docker Compose 安装
    echo "验证 Docker Compose 安装..."
    if ! command -v docker-compose &> /dev/null; then
        echo "Docker Compose 未安装，正在安装 Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo "Docker Compose 安装完成。"
    fi

    # 再次验证 Docker Compose 安装
    echo "再次验证 Docker Compose 安装..."
    if docker-compose --version &> /dev/null; then
        echo "Docker Compose 验证成功。"
    else
        echo "Docker Compose 验证失败。"
        exit 1
    fi
}

# 定义安装节点的函数
install_node() {
    echo "克隆 Dockerfile 存储库..."
    git clone https://github.com/kodaicoder/morphl2-validator.git
    if [ $? -ne 0 ]; then
        echo "克隆失败，请检查网络连接或存储库 URL。"
        exit 1
    fi

    cd morphl2-validator || { echo "无法进入目录 morphl2-validator"; exit 1; }
    echo "已进入目录 morphl2-validator。"

    # 添加提示用户按任意键继续
    read -p "请按任意键继续编辑 .env 文件..."

    echo "正在编辑 .env 文件..."
    nano .env
    echo "请设置您的 RPC 和钱包地址以及私钥，然后保存并退出编辑器。"
    echo "节点安装完成。"
}

# 启动节点的函数
start_node() {
    echo "正在启动节点..."
    read -p "按回车键开始构建镜像并运行容器..."

    # 构建镜像并运行容器
    docker-compose up --build -d
    echo "节点正在启动。"
}

# 更新 .env 文件的函数
update_env() {
    echo "停止当前 Docker 容器..."
    docker-compose stop
    echo "请按任意键继续更新 .env 文件..."
    read -p "按任意键继续..."

    echo "正在编辑 .env 文件..."
    nano .env
    echo "请设置您的 RPC 和钱包地址以及私钥，然后保存并退出编辑器。"

    echo "重新启动 Docker 容器..."
    docker-compose up -d
    echo ".env 文件已更新并且容器已重新启动。"
}

# 删除节点的函数
delete_node() {
    echo "停止并删除旧容器..."
    docker-compose down
    echo "节点已删除。"
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
        echo "3) 更新 .env 文件"
        echo "4) 删除节点"
        echo "5) 退出"
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
                check_docker
                update_env
                ;;
            4)
                check_docker
                delete_node
                ;;
            5)
                echo "退出脚本。"
                exit 0
                ;;
            *)
                echo "无效选项，请选择 1-5 之间的数字。"
                ;;
        esac
    done
}

# 运行主菜单
main_menu
