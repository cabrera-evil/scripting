#Install Git Credential Manager Core
wget "https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.696/gcmcore-linux_amd64.2.0.696.deb" -O /tmp/gcmcore.deb
sudo dpkg -i /tmp/gcmcore.deb
#Configuring GCMC
git-credential-manager-core configure
#Fixing GCMC error
git config --global credential.credentialStore secretservice
