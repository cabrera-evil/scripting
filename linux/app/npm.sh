#Install NVM
clear
echo Installing NVM
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
#Exporting user config
clear
echo Exporting user config
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#Reload config
clear
echo Realoading config
source ~/.bashrc
#Install NodeJs LTS
clear
echo Installing nodejs
nvm i --lts
#Install Modules
clear
echo Installing node modules
npm i -g sass
npm i -g nodemon
npm i -g vite
npm i -g yarn
npm i -g hbs
npm i -g express-generator
npm i -g create-electron-app
npm i -g nest-api-generator
