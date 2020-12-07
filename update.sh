#!/bin/bash
## Author:	Owen Cocjin
## Version:	1.2
## Date:    06/12/20
## Title:   update.sh
## Description: Updates all bashTools
## Notes:
##    - Requires 'wget' program
##    - Imcorporated env var 'BASHTOOLS_PATH'

echo -e "This script will be modifying files in:\n\t${BASHTOOLS_PATH}\n\t${BASHTOOLS_PATH}/BashTools\nIf this is not the correct directory change env var 'BASHTOOLS_PATH'."
echo -en "\nIs this the correct directory (y/n)? "
read menu
if [[ "$menu" != "y" ]] && [[ "$menu" != "Y" ]]; then
	echo "Please change the env var 'BASHTOOLS_PATH'!"
	exit 0
fi

#Save current file versions
oldVersions=( )  #Shouldn't have a need to save names as order of tools shouldn't change
for f in $(ls ${BASHTOOLS_PATH}); do
	oldVersion+=( "$(head -n 3 "${BASHTOOLS_PATH}/${f}" | tail -n 1)" )
done

#Download all raw files from github & overwrite old tools
for f in $(ls ${BASHTOOLS_PATH}); do
	echo -n "Downloading ${f}... "
	wget -O "${BASHTOOLS_PATH}/${f}" "https://raw.githubusercontent.com/owenCocjin/bashTools/master/Tools/${f}" &>/dev/null
	if [[ $? != 0 ]]; then
		echo "[X]"
	else
		echo "[V]"
	fi
done

#List updated versions
counter=0
for f in $(ls ${BASHTOOLS_PATH}); do
	newVersion=$(head -n 3 "${BASHTOOLS_PATH}/${f}" | tail -n 1)
	echo -e "\n${f}:"
	echo -en "\tVersion ${oldVersion[counter]:12} -> ${newVersion:12}\n"
	((++counter))
done

#Can't source bashrc from script
echo "Done! finally, source bashrc to complete update!"
echo -e '\n. ~/.bashrc\n'
