#!/bin/bash
# installs
apt clean
add-apt-repository ppa:neovim-ppa/unstable -y
apt update -y
apt upgrade -y

# packages
packages="stow tree vim neovim python3 python3-pip latexmk sl gdb zsh texlive-base texlive-font-utils texlive-science texlive-extra-utils texlive-latex-extra"
apt install -y $packages

# shell
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Prompt to change shell to zsh"
chsh -s $(which zsh)
mkdir ~/.projects

read -p "Enter seed for SSH key: " SEED
ssh-keygen -t rsa -b 4096 -C SEED
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
echo "SSH public key:"
cat ~/.ssh/id_rsa.pub

echo "Execute 'stow wsl' from ~/sys-setup to link dotfiles"
