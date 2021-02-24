#!/bin/bash
## Author:	Owen Cocjin
## Version:	1.5.5
## Date:    24/02/2021
## Title:   update.sh
## Description: Updates all bashTools
## Notes:
##    - Requires 'wget'
##    - Updated README.md, but won't show a version no.
## Update:
##    - Fixed issue with updates saving to current directory (as opposed to BASHTOOLS_PATH)
##    - Fixed README.md issue saving to BASHTOOLS_PATH

#----------------#
#    FUNCTION    #
#----------------#
dwnldr(){
	echo -n "Downloading ${1}... "
	if [[ -z $2 ]]; then
		namepath="${BASHTOOLS_PATH}/${1}"
		rawpath="https://raw.githubusercontent.com/owenCocjin/BashTools/master/Tools/${1}"
	else
		namespath="${1}"
		rawpath="https://raw.githubusercontent.com/owenCocjin/BashTools/master/${1}"
	fi
	wget -O "${namespath}" $rawpath
	if [[ $? != 0 ]]; then
		echo "[X]"
	else
		echo "[V]"
	fi
};#function()

#------------#
#    MAIN    #
#------------#
if [[ ${1} = '-v' ]] || [[ ${1} = '--version' ]]; then
	echo -en "\n********************************"
	curVersion=$(head -n 3 "./update.sh" | tail -n 1)
	echo -e "\nupdate.sh\n\tVersion ${curVersion:12}"
	for f in $(ls ${BASHTOOLS_PATH}); do
		curVersion=$(head -n 3 "${BASHTOOLS_PATH}/${f}" | tail -n 1)
		echo -e "\n${f}:"
		echo -en "\tVersion ${curVersion:12}\n"
	done
	echo "********************************"
	exit 0
fi
menu_regex='^[Yy]es$|^[Yy]$'
echo -e "This script will be modifying files in:\n\t${BASHTOOLS_PATH}\nIf this is not the correct directory change env var 'BASHTOOLS_PATH'."
echo -en "\nIs this the correct directory (y/n)? "
read menu
if [[ ! ${menu} =~ ${menu_regex} ]] && [[ ${menu} != '' ]]; then
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
	dwnldr $f
done
#Download README
dwnldr "README.md" 'x'

#List updated versions
echo -en "\n********************************"
counter=0
for f in $(ls ${BASHTOOLS_PATH}); do
	newVersion=$(head -n 3 "${BASHTOOLS_PATH}/${f}" | tail -n 1)
	echo -e "\n${f}:"
	echo -en "\tVersion ${oldVersion[counter]:12} -> ${newVersion:12}\n"
	((++counter))
done
echo "********************************"

#Can't source bashrc from script
echo -e "\nDone! Finally, source bashrc to complete update!"
echo -e "\n. ~/.bashrc\n"
