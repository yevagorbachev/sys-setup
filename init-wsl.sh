#!/bin/bash
# installs
sudo apt clean
# sudo add-apt-repository ppa:neovim-ppa/stable
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update -y
sudo apt upgrade -y

# packages
packages="stow tree neovim python3 python3-pip zig texlive-base texlive-font-utils texlive-science texlive-extra-utils texlive-latex-extra latexmk sl gdb zsh"
sudo apt install -y $packages

# shell
# yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
mkdir ~/.projects

read -p "Enter seed for SSH key: " SEED
ssh-keygen -t rsa -b 4096 -C SEED
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
echo "SSH key:"
cat ~/.ssh/id_rsa.pub

echo "Execute 'stow wsl' from ~/sys-setup to link dotfiles"
