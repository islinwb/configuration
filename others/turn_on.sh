#!/bin/bash

function set_git_config()
{
    if [ ! -f ~/.gitconfig ]; then
        cp ~/.gitconfig ~/.gitconfig_bak
    fi
    
    cat git_configuration > ~/.gitconfig
}

function install_golang()
{
    go_version="1.11.2"
    wget http://mirrors.ustc.edu.cn/golang/go${go_version}.linux-amd64.tar.gz
    tar -zxvf go${go_version}* -C /usr/local/
    echo "export GOROOT=/usr/local/go" >> ~/.zshrc
    echo "export GOBIN=\$GOROOT/bin" >> ~/.zshrc
    echo "export PATH=\$PATH:\$GOBIN" >> ~/.zshrc
    source ~/.zshrc
}

case $1 in
"ch_src")
    cp /etc/apt/sources.list /etc/apt/sources.list_bak
    sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
    apt update
    ;;
"zsh")
    echo ">>> install zsh and oh-my-zsh"
    apt install -y zsh
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="maran"/' ~/.zshrc
    source ~/.zshrc
    ;;
"git")
    echo ">>> git config"
    apt install git
    set_git_config
    ;;
*)
    echo ">>> sorry"
    ;;
esac