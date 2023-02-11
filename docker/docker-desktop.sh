#Install Kvm For Virtualization
clear
echo Installing KVM
sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu qemu-kvm
kvm-ok
#Update System Package
clear
echo Updating system packages
sudo apt update && sudo apt upgrade -y
[ -f /var/run/reboot-required ] && sudo reboot -f
#Configure Kvm Support
clear
echo setting up KVM
sudo modprobe kvm
lsmod | grep kvm
ls -al /dev/kvm
#Add user to kvm
clear
echo Adding user to kvm
sudo usermod -aG kvm $USER
#Delete Old Installations
clear
echo Cleaning old instalations
sudo apt remove docker-desktop
rm -r $HOME/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
sudo apt purge docker-desktop
#Docker Install
clear
echo Installing docker
sudo apt install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#Setup The Repository
clear
echo Setting up docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#Download A Test Version (Then You Can Update)
clear
echo Downloading last version of docker desktop
#wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.16.2-amd64.deb
#Install The Downloaded Package
clear
echo Installing docker desktop
sudo apt update
sudo apt install ./docker-desktop-4.16.2-amd64.deb -y
#Cheking Version
clear
echo Checking docker version
docker compose version
docker --version
docker version
#Add User To Docker
clear
echo Adding user to docker organization
sudo usermod -aG docker $USER
#Enable Service Startup
clear
echo Enabling docker service
systemctl --user enable docker-desktop
#Open Docker-Desktop
clear
echo Opening docker desktop
systemctl --user start docker-desktop
