#!/bin/bash

startup=$(pwd)
prefix=$HOME
dotfiles_dir=${prefix}/dotfiles
echo Dotfiles Dir: ${dotfiles_dir}

echo Updating software repo
#sudo apt-get update

echo Installing git, wget and curl
#sudo apt-get install git wget curl

# Check SSH configuration
if [ -f ${prefix}/.ssh/id_rsa.pub ]; then
	echo SSH configuration found! Using SSH to clone repo
	clone_url=git@github.com:neoluxis/nlx-dotfiles.git
else
	echo No SSH configuration found. Please configure SSH on you device and sooner HTTP will be used...
	clone_url=http://github.com/neoluxis/nlx-dotfiles.git
fi

# clone repo to HOME dir
echo Cloning Repo
if [ -d ${dotfiles_dir} ]; then
	echo ${dotfiles_dir} already exists! Skipping cloning...
else
	git clone ${clone_url} ${dotfiles_dir} || { echo Failed to clone dotfiles repo. ; exit 1; }
fi

cd ${dotfile_dir}
if [ $(uname -a | grep -c "rdkx3") -gt 0 ]; then
	git checkout rdkx3 || { echo Failed to checkout branch for RDKx3; exit 2; }
elif [ $(uname -a | grep -c "raspi") -gt 0 ]; then
	git checkout raspi || { echo Failed to checkout branch for raspi; exit 2; }
else
	echo Cannot detect system. Please configure dotfiles manually. 
	exit 2
fi


