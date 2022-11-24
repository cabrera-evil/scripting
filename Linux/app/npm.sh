#Install NVM
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
#Exporting user config
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#Reload config
source ~/.bashrc
#Install NodeJs LTS
nvm install --lts
#Install Modules
npm install -g sass
npm install -g nodemon
npm install -g vite
npm install -g yarn
npm install -g express-generator
npm install -g pug
