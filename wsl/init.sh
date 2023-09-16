#!/bin/bash
#
echo "\nInstalling packages\n"
# installs
sudo apt clean
sudo apt update
sudo apt upgrade -y

# packages
packages="tree python3 python3-pip texlive-base texlive-font-utils texlive-science texlive-extra-utils texlive-latex-extra latexmk sl gdb zsh neovim stow"
sudo apt-get install $packages -y

# shell
echo "\nSetting up shell\n"
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /bin/zsh
stow wsl -t ~ # assuming I'm in the repo
sed 's/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"afowler-custom\"/g' ~/.zshrc -i # set ZSH theme
echo '. ~/.zsh_aliases' >> ~/.zshrc
mkdir ~/.projects

read -p "Enter seed for SSH key: " SEED
ssh-keygen -t rsa -b 4096 -C SEED
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
echo "SSH key:"
cat ~/.ssh/id_rsa.pub