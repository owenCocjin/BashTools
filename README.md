# Bash Tools

> A compilation of various Bash scripts I've created on the fly to help me deal with life on a terminal.

***

## Installation:

**&bull;** Clone repo and add `bashTools` to PATH
> I recommend creating a symbolic link in a directory that already exists in path (*/usr/local/bin/* for this example). You can do this while in the cloned repo with the command:
```
ln -s $PWD/Tools /usr/local/bin/bashTools
```

<br/>

**&bull;** You must add 2 lines to your .bashrc. The following command will do it for you! The following assumes you put *bashTools* in `/usr/local/bin/`:
```
echo -e '\nexport PATH="$PATH:/usr/local/bin/bashTools"\n. /usr/local/bin/bashTools/.sources\n' >> ~/.bashrc
```

&nbsp;&nbsp;Or you could manually add the lines:
```
export PATH="$PATH:/usr/local/bin/bashTools"
. /usr/local/bin/bashTools/.sources
```

<br/>

**&bull;** Finally, source your bashrc file:
```
source ~/.bashrc
```

*Note: If bashTools isn't installed in `/usr/local/bin` you need to go into `sources` and change 'p'*

<br/>

## Updates:

There are 2 update options:

- Run the `update.sh` script provided with the repo.
> !!! MAKE SURE THE PATHS IN THE `update.sh` ARE CORRECT !!!

<br/>

- Delete the entire cloned repo and reinstall:
```
#Replace the variable with the path to bashTools. Default assumes you're in BashTools' parent directory
rm -rf ./bashTools
sudo git clone https://github.com/owenCocjin/bashTools.git
```

<br/>

## Usage:

After installing, you can run any of the following as commands:
* cl
* fillSpaces
* n
* resetWifi
* stickynotes
* wttr
