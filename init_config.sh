#!/bin/bash
# Setup configurations using symbolic link from home folder to config files
# within this repository.
# Script copied and modified from :
# https://github.com/marinacr/configuration_files/blob/master/config_files_script

# shellcheck disable=SC2045 # I want to iterate over ls output

# Function to prompt user with a yes/no question, defaulting to "no" on Enter
ask_yes_no_default_no() {
    local prompt="$1"

    while true; do
        read -r -p "$prompt (yes/no) [no]: " answer
        case $answer in
            [Yy]* ) return 0;;  # Return 0 for "yes"
            [Nn]* ) return 1;;  # Return 1 for "no"
            "" ) return 1;;     # Return 1 for Enter (defaulting to "no")
            * ) echo "Please answer yes or no.";;
        esac
    done
}

config_dir=$(git rev-parse --show-toplevel)
ignore_patterns=('README.md' "$(basename "$0")" '.git$' '~' 'backup' 'screenrc_layouts' '.*\.swp' 'gonzalez_config' 'revit.sh' 'git_prompt.zsh' 'misc' 'tmux_sessions.sh')
ignore_patterns+=('.github' '.pre-commit-config.yaml' 'template')
backup_folder=${config_dir}_$(date "+%F_%H.%M.%S")

#symbolic link creation
for file in $(ls -A "$config_dir")
do
    ignore_flag=0
    for p in "${ignore_patterns[@]}"; do
        match=$(echo "$file" | grep -c "${p}")
        if [ "$match" -ne 0 ]; then
            ignore_flag=1
        fi
    done
    if [ "$ignore_flag" -ne 1 ]
    then
        if [ -e "$HOME/$file" ] && [ ! -h "$HOME/$file" ]
        then
            #backup existing conf file
            mkdir -p "${backup_folder}"
            mv "$HOME/${file}" "${backup_folder}/${file}.old"
        fi
        if [ ! -h "${HOME}/${file}" ]; then
            ln -s "$config_dir/$file" "$HOME/$file"
        fi

    fi
done

#git configuration
read -r -p 'Git name : ' name
read -r -p 'Git mail : ' mail
cat <<EOF > "$HOME/.gitconfig_user"
[user]
        name = ${name}
        email = ${mail}
EOF

# Docker config
mkdir -p "${HOME}/.docker"
cp template_docker_config.json "${HOME}/.docker/config.json"
if ask_yes_no_default_no "Use Vossloh Proxy ?"; then
    # I need echo "$(cmd)"
    # shellcheck disable=2005
    echo "$(cat "${HOME}/.docker/config.json" || echo '{}')" | jq '. += {"proxies": { "default": { "httpProxy": "http://10.255.255.254:8080", "httpsProxy": "http://10.255.255.254:8080", "noProxy": "*.railway.ad"}}}' > ~/.docker/config.json.new && mv ~/.docker/config.json.new ~/.docker/config.json
fi
