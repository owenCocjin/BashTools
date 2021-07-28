# Bash Tools

> A compilation of various Bash scripts I've created on the fly to help me deal with life on a terminal.

***

## Installation:

Run the `install.sh` script as root **WHILE IN REPO DIRECTORY!** Root is really only required if you don't change the default path (/usr/local/bin). To set a home path, edit the `install.sh` script and change `temp_path` to whatever you want the symlink to run through. If you run as root user (not just sudo), make sure the repo itself is somewhere accessible by all accounts!

<br/>

## Updates:

There are 2 update options:

- Run the `update.sh` script provided with the repo.
> !!! MAKE SURE THE PATHS IN THE `update.sh` ARE CORRECT !!!

<br/>

- Delete the entire cloned repo and re-clone. The way the tools are installed means as long as you clone into the same directory as the first time everything should be fine:
```
rm -rf ./BashTools
git clone https://github.com/owenCocjin/BashTools.git
```

In order to update the `update.sh` script itself, you must manually run the below command __IN THE REPO DIRECTORY__:
```
rm ./update.sh
wget -O update.sh https://raw.githubusercontent.com/owenCocjin/BashTools/master/update.sh
chmod +x ./update.sh

```

> In the case of a major update (normally just goes out of the scope of the Tools) manually deleting the repo is the best/only option.

<br/>

## Usage:

After installing, you can run any of the following as commands:
* cl [v2.6]
	* cd then ls into a directory
* fillSpaces [v1.0]
	* Replaces spaces in filenames
* monloop [v1.2]
	* Loops a process. Good for monitoring processes such as a file downloading (monloop 'df -h /home;df /home')
* muldir [v1.0]
	* Sets the pwd to be opened on all new shells (that read .bashrc)
* mvd [1.0]
	* Move a file explicitly from ~/Downloads
* n [v1.3]
	* Send & dissociate a program from a terminal
* readconfig [v1.0]
	* Reads all uncommented lines of a config file that uses `#` as comments
* resetWifi [v1.0]
	* Restart a wifi card
* stickynotes [v1.0]
	* Create and manage stickynotes
* todo [v1.0]
	* Reads a todo list in the current directory
* webnotes [v1.2]
	* Open an editable webpage
* wttr [v1.0]
	* Get weather info

<br/>

## Uninstall:

To uninstall you must:

- Manually change the edits made by the install script in your .bashrc file. See install instructions for specific lines.

- Delete the symlink in the bashtools path. Default will be `/usr/local/bin/bashtools`.

- Delete the BashTools cloned repo.

<br/>

## Bugs:

* webnotes
> (Untested on chrome) Firefox no longer allows html to be run directly from the URL bar. For the moment, you must manually go to the URL bar and hit <Enter>. This can be quickly achieved by typing <Ctrl+l><Enter>.

* monloop
> If a command takes a while to load, monloop will start flickering.
