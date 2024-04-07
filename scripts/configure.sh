#!/bin/zsh 

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

cd ${dotfiles_dir}
if [ $(uname -a | grep -c "rdkx3") -gt 0 ]; then
	{ git checkout rdkx3; dotfiles_dir=${dotfiles_dir}/rdkx3 } || 
		{ echo Failed to checkout branch for RDKx3; exit 2; }
elif [ $(uname -a | grep -c "rpi") -gt 0 ]; then
	{ git checkout raspi; dotfiles_dir=${dotfiles_dir}/raspi5 }  || 
		{ echo Failed to checkout branch for raspi; exit 2; }
else
	echo Cannot detect system. Please configure dotfiles manually. 
	exit 2
fi

for file in $(ls -a ${dotfiles_dir}/home); do
	abs_path=${dotfiles_dir}/home/${file}
	
	if [[ ${file} == "." || ${file} == ".." ]]; then
		continue
	fi

	if [ -e ${prefix}/${file} ]; then
		echo -e -n "File/Dir ${prefix}/${file} Exists! Preview or Delete it? [P/n/y] "
		read

		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm -fr ${prefix}/${file}
			echo "Delete ${prefix}/${file}"
		elif [[ $REPLY =~ ^[Nn]$ ]]; then
			echo "Skipping link from ${abs_path} to ${prefix}/${file}"
			continue
		else
			vim ${prefix}/${file}
			echo -e -n "Delete it? [N/y] "
			read -n 1
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				rm -fr ${prefix}/${file}
				echo "Delete ${prefix}/${file}"
			else
				echo "Skipping link from ${abs_path} to ${prefix}/${file}"
				continue
			fi
		fi
	fi

	if [ -f ${abs_path} ]; then
		ln ${abs_path} ${prefix}/${file}
		echo "Creating hard link for File ${file}."
	elif [ -d ${abs_path} ]; then
		ln -s ${abs_path} ${prefix}/${file}
		echo "Creating soft link for Directory ${file}."
	else
		cp ${abs_path} ${prefix}/${file} -r
		echo "Cannot detect type, Copying ${file}"
	fi
done


for file in $(ls -a ${dotfiles_dir}/config); do
	abs_path=${dotfiles_dir}/config/${file}

	if [[ ${file} == "." || ${file} == ".." ]]; then
		continue
	fi

	if [ -e ${prefix}/.config/${file} ]; then
		echo -e -n "File/Dir ${prefix}/.config/${file} Exists! Preview or Delete it? [P/n/y] "
		read
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm -fr ${prefix}/.config/${file}
			echo "Delete ${prefix}/.config/${file}"
		elif [[ $REPLY =~ ^[Nn]$ ]]; then
			echo "Skipping link from ${abs_path} to ${prefix}/.config/${file}"
			continue
		else
			vim ${prefix}/.config/${file}
			echo -e -n "Delete it? [N/y] "
			read -n 1
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				rm -fr ${prefix}/.config/${file}
				echo "Delete ${prefix}/.config/${file}"
			else
				echo "Skipping link from ${abs_path} to ${prefix}/.config/${file}"
				continue
			fi
		fi
	fi

	if [ -f ${abs_path} ]; then
		ln ${abs_path} ${prefix}/.config/${file}
		echo "Creating hard link for File ${file}."
	elif [ -d ${abs_path} ]; then
		ln -s ${abs_path} ${prefix}/.config/${file}
		echo "Creating soft link for Directory ${file}."
	else
		cp ${abs_path} ${prefix}/.config/${file} -r
		echo "Cannot detect type, Copying ${file}"
	fi
done

# git checkout main

echo Auto Configuration Successful!
