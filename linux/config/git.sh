#Install Git Credential Manager Core
wget "https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.696/gcmcore-linux_amd64.2.0.696.deb" -O /tmp/gcmcore.deb
sudo dpkg -i /tmp/gcmcore.deb
#Configuring GCMC
git-credential-manager configure
#Install keyring
sudo apt-get install gnome-keyring -y
#Install missing dependency
sudo apt-get install libsecret-1-dev
#Fixing GCMC error
git config --global credential.credentialStore secretservice
