#!/bin/bash
## Author:	Owen Cocjin
## Version:	1.4.1
## Date:    07/12/20
## Title:   install.sh
## Description: Installs BashTools
## Notes:
##    - Must run as root
##    - Changed comments
### Edit this path to wherever BashTools should install! ###
parentPath='/usr/local/bin'
#Exit if not running as root
if [[ $(id -u) != '0' ]]; then
	echo "[|X] Run as root (would probably have failed otherwise)!"
	exit 1
else
	home_path=$([[ -z ${SUDO_USER} ]] && echo "/root" || echo "/home/${SUDO_USER}")
fi

#Create temp var for bashtools home directory
temp_path="${parentPath}/bashtools"
echo "[|X] Deciding home for bashtools... ${temp_path}"

#Sym link Tools to path if one doesn't already exist
if [[ ! -h ${temp_path} ]]; then
	ln -s ${PWD}/Tools ${temp_path}
	echo -e "[|X] Creating symlink from\n\t-> ${temp_path} to ${PWD}/Tools"
else
	echo "[|X] It looks like the symlink exists! If you have permission to ${temp_path} you can delete this repo as it's probably already setup somewhere..."
fi

#Add lines to .bashrc
echo -e "\nexport BASHTOOLS_PATH=${temp_path}
. \${BASHTOOLS_PATH}/.sources" >> ${home_path}/.bashrc
echo "[|X] Adding lines to ${home_path}/.bashrc ..."

#Tell user to source bash to take effect
echo "[|X] All done! Source your bashrc file to get started!

. ~/.bashrc
"
