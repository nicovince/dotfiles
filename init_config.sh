#!/bin/bash
# Setup configurations using symbolic link from home folder to config files
# within this repository.
# Script copied and modified from :
# https://github.com/marinacr/configuration_files/blob/master/config_files_script

config_dir=$(git rev-parse --show-toplevel)
ignore_patterns=('README.md' "$(basename $0)" '.git$' '~' 'backup' 'screenrc_layouts' '.*\.swp' 'gonzalez_config' 'revit.sh' 'git_prompt.zsh')
backup_folder=${config_dir}_$(date "+%F_%H.%M.%S")

#symbolic link creation
for file in `ls -A $config_dir`
do
    ignore_flag=0
    for p in ${ignore_patterns[*]}; do
        match=$(echo $file | grep -c "${p}")
        if [ $match -ne 0 ]; then
            ignore_flag=1
        fi
    done
    if [ $ignore_flag -ne 1 ]
    then
        if [ -e $HOME/$file -a ! -h $HOME/$file ]
        then
            #backup existing conf file
            mkdir -p ${backup_folder}
            mv $HOME/${file} ${backup_folder}/${file}.old
        fi
        if [ ! -h ${HOME}/${file} ]; then
            ln -s $config_dir/$file $HOME/$file
        fi

    fi
done

#git configuration
read -p 'Git name : ' name
read -p 'Git mail : ' mail
cat <<EOF > $HOME/.gitconfig_user
[user]
        name = ${name}
        email = ${mail}
EOF
