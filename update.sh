#!/bin/bash
## Author:	Owen Cocjin
## Version:	1.5.3
## Date:    15/12/31
## Title:   update.sh
## Description: Updates all bashTools
## Notes:
##    - Requires 'wget'
## Update:
##    - Added a downloader function
##    - Fied issues with README.md

#----------------#
#    FUNCTION    #
#----------------#
dwnldr(){
	echo -n "Downloading ${1}... "
	wget -O "${BASHTOOLS_PATH}/${1}" "https://raw.githubusercontent.com/owenCocjin/BashTools/master/Tools/${1}" &>/dev/null
	if [[ $? != 0 ]]; then
		echo "[X]"
	else
		echo "[V]"
	fi
}#function()

#------------#
#    MAIN    #
#------------#
if [[ ${1} = '-v' ]] || [[ ${1} = '--version' ]]; then
	echo -en "\n********************************"
	curVersion=$(head -n 3 "./update.sh" | tail -n 1)
	echo -e "\nupdate.sh\n\tVersion ${curVersion:12}"
	for f in $(ls ${BASHTOOLS_PATH}; ls "README.md"); do
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
	echo "DOWNLOADING ${f}"
	#dwnldr $f
done
#Download README
echo "DOWNLOADING README.md"
#dwnldr "README.md"

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
