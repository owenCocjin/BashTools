#!/bin/bash
## Author:	Owen Cocjin
## Version:	1.0
## Date:    07/12/20
## Title:   install.sh
## Description: Installs BashTools
## Notes:
##    - Must run as root
#Exit if not running as root
if [[ $(id -u) != '0' ]]; then
	echo "[|X] Run as root (would probably have failed otherwise)!"
	exit 1
fi

#Create temp var for bashtools home directory
### CHANGE ME IF YOU WANT ###
temp_path='/usr/local/bin'
echo "[|X] Deciding home for bashtools... ${temp_path}"

#Sym link Tools to path
ln -s ${PWD}/Tools ${temp_path}/bashtools
echo -e "[|X] Creating symlink from\n\t-> ${temp_path}/bashtools to ${PWD}/Tools"

#Add lines to .bashrc
echo -e "\nexport BASHTOOLS_PATH=${temp_path}
. \${BASHTOOLS_PATH}/bashtools/.sources" >> /home/${SUDO_USER}/.bashrc
echo "[|X] Adding lines to /home/${SUDO_USER}/.bashrc ..."

#Tell user to source bash to take effect
echo "[|X] All done! Source your bashrc file to get started!

. ~/.bashrc
"
