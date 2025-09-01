add-apt-repository ppa:gnuradio/gnuradio-releases
apt update -y
apt upgrade -y

snaps="gqrx sdrangel"
sudo snap install gqrx
sudo snap install sdrangel

mkdir ~/radio
