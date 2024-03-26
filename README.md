# Linux Scripting

![](https://img.shields.io/github/last-commit/cabrera-evil/scripting/master)
![](https://img.shields.io/github/license/cabrera-evil/scripting)
![](https://img.shields.io/github/languages/top/cabrera-evil/scripting?label=bash)
![](https://img.shields.io/github/contributors/cabrera-evil/scripting)

Welcome to the Linux Scripting repository! This repository contains a collection of scripts to help you configure and manage your Linux server. The scripts are written in Bash and are designed to be easy to use and modify.

## Table of Contents

- [Linux Scripting](#linux-scripting)
  - [Table of Contents](#table-of-contents)
  - [Scripts](#scripts)
  - [Usage](#usage)
  - [License](#license)

## Scripts

This repository contains scripts for the following scripts:

```
└── 📁scripting
    └── .gitignore
    └── LICENSE
    └── README.md
    └── init.sh
    └── 📁linux
        └── 📁debian
            └── 📁app
                └── 📁desktop
                    └── alacritty.sh
                    └── android-studio.sh
                    └── chrome.sh
                    └── dbeaver.sh
                    └── discord.sh
                    └── docker.sh
                    └── intellij.sh
                    └── mongodb-compass.sh
                    └── obs-studio.sh
                    └── postman.sh
                    └── save-dekstop.sh
                    └── slack.sh
                    └── spotify.sh
                    └── termius.sh
                    └── thunderbird.sh
                    └── virtualbox.sh
                    └── vmware.sh
                    └── vscode.sh
                    └── whatsapp.sh
                └── 📁terminal
                    └── apt.sh
                    └── flatpak.sh
                    └── kubectl.sh
                    └── mongodb-tools.sh
                    └── npm.sh
                    └── nvim.sh
                    └── ohmybash.sh
            └── 📁config
                └── docker-hub.sh
                └── github-ssh.sh
                └── github-user.sh
                └── grub.sh
                └── repos.sh
                └── sudo.sh
                └── toucheeg.sh
                └── update.sh
```

## Usage

To use these scripts, simply clone the repository to your server and run the `init.sh` script. This script will prompt you to select a category of scripts to run, and then prompt you to select a specific script to run. The script will then execute the selected script, and you will be prompted to select another script to run. This process will continue until you choose to exit the script.

```bash
git clone https://github.com/cabrera-evil/scripting
cd scripting
./init.sh
```

If you would like to run a specific script directly, you can do so by running the script directly from the command line. For example, to run the `update.sh` script, you would run the following command:

```bash
./linux/debian/config/update.sh
```

## License

This repository is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the scripts as long as you include the original license text.

---

Happy linux scripting!