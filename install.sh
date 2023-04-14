#!/bin/bash
## Author:	Owen Cocjin
## Version:	1.4.3
## Date:    2023.04.14
## Description: Installs BashTools
## Notes:
##  - Must run as root
##  - Changed comments
## Updates:
##  - Changed the way we determine home dir to "$HOME"
##  - Fixed home_path determination

### Edit the 'parentPath' var to wherever BashTools should install! ###
###############################
parentPath='/usr/local/bin' ###
###############################

#Exit if not running as root
if [[ $(id -u) != '0' ]]; then
	echo "[|x]: Run as root (would probably have failed otherwise)!"
	exit 1
else
	home_path=$(getent passwd $([[ -z ${SUDO_USER} ]] && echo $USER || echo $SUDO_USER) | cut -d ':' -f 6)
fi

#Create temp var for bashtools home directory
temp_path="${parentPath}/bashtools"
echo "[|x]: Deciding home for bashtools... ${temp_path}"

#Sym link Tools to path if one doesn't already exist
if [[ ! -h ${temp_path} ]]; then
	ln -s ${PWD}/Tools ${temp_path}
	echo -e "[|x]: Creating symlink from\n\t-> ${temp_path} to ${PWD}/Tools"
else
	echo "[|x]: It looks like the symlink exists! If you have permission to ${temp_path} you can delete this repo as it's probably already setup somewhere..."
fi

#Add lines to .bashrc
echo -e "\nexport BASHTOOLS_PATH=${temp_path}
. \${BASHTOOLS_PATH}/.sources" >> ${home_path}/.bashrc
echo "[|x]: Adding lines to ${home_path}/.bashrc ..."

#Tell user to source bash to take effect
echo "[|x]: All done! Source your bashrc file to get started!

. ~/.bashrc
"
