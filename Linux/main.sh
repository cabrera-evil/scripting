#Updating System
sudo sh ./config/update.sh
#Install Basic Applications
sudo apt-get install htop -y
sudo apt-get install neofetch -y
sudo apt-get install git -y
sudo apt-get install gnome-keyring -y
sudo apt-get install build-essential -y
sudo apt-get install default-jdk -y
sudo apt-get install snapd -y
#Install Late Dock
sudo apt-get install latte-dock -y
#Install Kvantum
sudo apt install qt5-style-kvantum qt5-style-kvantum-themes -y
#Install ULauncher
sudo add-apt-repository ppa:agornostal/ulauncher && sudo apt update && sudo apt install ulauncher -y
ulauncher &
#Install Brave Browser
sudo apt install apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
sudo apt install brave-browser -y
#Install Snap Applications
sudo sh ./app/snap.sh
#Install NPM Modules
sudo sh ./app/npm.sh
