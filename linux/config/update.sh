#Updating System
clear
echo Updating System
sudo apt-get update -y

clear
echo Upgrading Packages
sudo apt-get upgrade -y

clear
echo Dist-Upgrade
sudo apt-get dist-upgrade -y

clear
echo Full-Upgrade
sudo apt-get full-upgrade -y

clear
echo Autoremove Packages
sudo apt autoremove -y

clear
echo Autoclean Packages
sudo apt autoclean -y

clear
echo Fixing Broken Packages
sudo apt --fix-broken install -y