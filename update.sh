#!/bin/bash
## Author:	Owen Cocjin
## Version:	1.6
## Date:    2021.04.08
## Title:   update.sh
## Description: Updates all bashTools
## Notes:
##    - Requires 'wget'
##    - Updated README.md, but won't show a version no.
## Update:
##    - Changed how script downloads updates
##    - Should now update ALL filed in Tools

#----------------#
#    FUNCTION    #
#----------------#
dwnldr(){
	echo -n "Downloading ${1}... "
	if [[ -z $2 ]]; then
		namepath="${BASHTOOLS_PATH}/${1}"
		rawpath="https://raw.githubusercontent.com/owenCocjin/BashTools/master/Tools/${1}"
	else
		namepath="${1}"
		rawpath="https://raw.githubusercontent.com/owenCocjin/BashTools/master/${1}"
	fi
	wget -O "${namepath}" $rawpath &>/dev/null
	if [[ $? != 0 ]]; then
		echo "[X]"
		return 1
	else
		echo "[V]"
		return 0
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
[[ ! -e /tmp/BashTools ]] && mkdir /tmp/BashTools

echo -n '' > /tmp/BashTools/oldversion
for f in $(cat .list.txt | tail -n +2); do  #Ignore the first line. This is just a readme
	echo -en "${f}\t" >> /tmp/BashTools/oldversion
	if [[ -f "${BASHTOOLS_PATH}/${f}" ]]; then
		echo $(head -n 3 "${BASHTOOLS_PATH}/${f}" | tail -n 1) >> /tmp/BashTools/oldversion
	else
		echo "none" >> /tmp/BashTools/oldversion
	fi
done
#Download list from root
[[ $(dwnldr ".list.txt" 'x') == '0' ]] && : || echo 'Failed to download list!' && exit 1


#Download all raw files from github & overwrite old tools
for f in $(cat .list.txt); do
	dwnldr $f
done

#Download README
dwnldr "README.md" 'x'

#List updated versions
echo -en "\n********************************"
counter=0
for f in $(cat /tmp/BashTools/oldversion | tail -n +2); do
	filename=$(cut -f 1 <<< $f)
	oldversion=$(cut -f 2 <<< $f)
	newversion=$(head -n 3 "${BASHTOOLS_PATH}/${filename}" | tail -n 1)
	echo -e "\n${f}:"
	echo -en "\tVersion ${oldversion:12} -> ${newversion:12}\n"
	((++counter))
done
#List README.md updated version

echo "********************************"

#Can't source bashrc from script
echo -e "\nDone! Finally, source bashrc to complete update!"
echo -e "\n. ~/.bashrc\n"
