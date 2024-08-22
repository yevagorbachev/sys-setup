#!/bin/bash
# installs
sudo apt clean
sudo apt update
sudo apt upgrade -y

# packages
packages="stow tree python3 python3-pip texlive-base texlive-font-utils texlive-science texlive-extra-utils texlive-latex-extra latexmk sl gdb zsh neovim"
sudo apt install $packages -y

# shell
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mkdir ~/.projects

read -p "Enter seed for SSH key: " SEED
ssh-keygen -t rsa -b 4096 -C SEED
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
echo "SSH key:"
cat ~/.ssh/id_rsa.pub
