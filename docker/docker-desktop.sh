#Install Kvm For Virtualization
sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu qemu-kvm
kvm-ok
#Update System Package
sudo apt update && sudo apt upgrade -y
[ -f /var/run/reboot-required ] && sudo reboot -f
#Configure Kvm Support
sudo modprobe kvm
lsmod | grep kvm
ls -al /dev/kvm
#Add user to kvm
sudo usermod -aG kvm $USER
#Delete Old Installations
sudo apt remove docker-desktop
rm -r $HOME/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
sudo apt purge docker-desktop
#Docker Install
sudo apt install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#Setup The Repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#Download A Test Version (Then You Can Update)
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.10.0-amd64.deb
#Install The Downloaded Package
sudo apt update
sudo apt install ./docker-desktop-4.12.0-amd64.deb -y
#Cheking Version
docker compose version
docker --version
docker version
#Add User To Docker
sudo usermod -aG docker $USER
#Enable Service Startup
systemctl --user enable docker-desktop
#Open Docker-Desktop
systemctl --user start docker-desktop
