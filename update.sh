#!/bin/bash
## Author:	Owen Cocjin
## Version:	1.8
## Date:    2022.02.26
## Title:   update.sh
## Description: Updates all bashTools
## Notes:
##    - Requires 'wget'
##    - Updated README.md, but won't show a version no.
## Update:
##    - Made output prettier

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
		echo -e "\e[41m[X]\e[0m"
		return 1
	else
		echo -e "\e[42m[V]\e[0m"
		chmod +x ${namepath}
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
#Add install.sh and update.sh to old version list
echo -n "install.sh\t" >> /tmp/BashTools/oldversion
echo $(head -n 3 "install.sh" | tail -n 1) >> /tmp/BashTools/oldversion
echo -n "update.sh\t" >> /tmp/BashTools/oldversion
echo $(head -n 3 "update.sh" | tail -n 1) >> /tmp/BashTools/oldversion
#Download list from root
dwnldr ".list.txt" 'x'
if [[ $? != '0' ]]; then
	echo 'Failed to download list!'
	exit 1
fi
#Download all raw files from github & overwrite old tools
newfiles=()
for f in $(cat .list.txt); do
	if [[ ! -f ${BASHTOOLS_PATH}/${f} ]]; then
		newfiles+=(${f})
	fi
	dwnldr $f
done

#Download README
dwnldr "README.md" 'x'
#Download update.sh and install.sh
dwnldr "update.sh" 'x'
dwnldr "install.sh" 'x'

#List updated versions
IFS=$'\n'
echo -e "\n********************************
\e[92m[UPDATED]\e[0m"
counter=0
for f in $(cat /tmp/BashTools/oldversion | tail -n +2); do
	filename=$(cut -f 1 <<< $f)
	oldversion=$(cut -f 2 <<< $f)
	oldversion="${oldversion:12}"
	newversion=$(head -n 3 "${BASHTOOLS_PATH}/${filename}" | tail -n 1)
	newversion="${newversion:12}"
	if [[ ${oldversion} != ${newversion} ]]; then
		echo -e "  ${filename}:"
		echo -en "    Version \e[93m${oldversion}\e[0m -> \e[92m${newversion}\e[0m\n"
		((++counter))
	fi
done
#Print no updates string
if [[ ${counter} == 0 ]]; then
	echo -e '  \e[93mNo files were updated!\e[0m'
fi

#List new files
echo -e "\n\e[92m[NEW FILES]\e[0m"
if [[ ${#newfiles[@]} == 0 ]]; then
	echo -e '  \e[93mNo new files!\e[0m'
else
	for f in ${newfiles[@]}; do
		echo -e "    ${f}"
	done
fi
#List README.md updated version

echo "********************************"

#Can't source bashrc from script
echo -e "\nDone! Finally, source bashrc to complete update!"
echo -e "\n. ~/.bashrc\n"
