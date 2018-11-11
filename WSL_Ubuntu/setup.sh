#!/bin/bash

set -xe

###
# Install Packages
###

# Update to latest
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install -y apt-transport-https

# Add ppa repositories
## Git
sudo add-apt-repository ppa:git-core/ppa

## VS Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
sudo install -o root -g root -m 644 /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f /tmp/microsoft.gpg

# WSL Utilities - wslu
wget -O - https://api.patrickwu.ml/public.key | sudo apt-key add -
grep 'apt\.patrickwu\.ml' /etc/apt/sources.list || echo "deb https://apt.patrickwu.ml/ stable main" | sudo tee -a /etc/apt/sources.list

sudo apt update
sudo apt install -y \
    vim \
    git \
    terminator \
    dbus-x11 \
    code \
    wslu \
    fonts-firacode

service dbus status || service dbus start

###
# Setup SSH
###

mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -C "eusebio.olalde@indexexchange.com"

###
# Deploy dotfiles
###

# bash
cp bash/.bash* ~/

grep '\.bash_customize' ~/.bashrc || echo "
# My custom bashrc
if [ -f ~/.bash_customize ]; then
    . ~/.bash_customize
fi
" >> ~/.bashrc

