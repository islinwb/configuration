
# basic
apt-get install -y make gcc


# install git
# TODO: recompile git with openssl
apt-get install git

cp ~/.gitconfig ~/.gitconfig_bak
cat git_configuration > ~/.gitconfig_bak

# install zsh and oh-my-zsh
apt-get install -y zsh
nohup sh -c \
"$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &
sed -i 's/'


# kubernetes 
# `make update`: make, hg, gcc

## GCE sshd config
```shell
# generate ssh public key
sudo su
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config

# log in
ssh -i <private-key> rsa-key-20181105@
```


```shell
#
cd /home

# insatll make, git
apt-get install -y make git gcc mercurial

# git clone 
mkdir -p gop/src/k8s.io/kubernetes
nohup git clone \
https://github.com/kubernetes/kubernetes.git \
gop/src/k8s.io/kubernetes &



# install zsh and oh~my~zsh
apt-get install -y zsh
nohup sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &

# install go
wget -o go.tar.gz http://mirrors.ustc.edu.cn/golang/go1.11.2.linux-amd64.tar.gz

tar -zxvf go.tar.gz -C /usr/local/
echo "export GOROOT=/usr/local/go" >> ~/.zshrc
echo "export GOBIN=\$GOROOT/bin" >> ~/.zshrc
echo "export GOPATH=/home/gop" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOBIN" >> ~/.zshrc
source ~/.zshrc

# install docker
apt-get update
apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt update
apt install -y docker-ce=17.03.3~ce-0~ubuntu-xenial

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="maran"/' ~/.zshrc

# for debian
if [ $1 == "debian" ]; then
curl -fsSL https://download.docker.com/linux/debian/gpg \
 | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get install docker-ce=17.03.3~ce-0~debian-stretch
else if [ $1 == "ubuntu" ]; then
# for ubuntu 16.04
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt install docker-ce=17.03.3~ce-0~ubuntu-xenial
fi

sudo apt-get update
```