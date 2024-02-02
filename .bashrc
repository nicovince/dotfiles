# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# shellcheck disable=SC1090 # source files whose paths is known at runtime

export EDITOR=vim

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=100000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "
# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# Source color variables
if [ -f "$HOME/.bash_colors" ]; then
  source "$HOME/.bash_colors"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

# shellcheck disable=SC2154
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    # shellcheck disable=SC2154
    PS1='\[[36m\][\t]\[[0m\] \[[35m\]\u\[[0m\]\[[34m\]@\[[0m\]\[[33m\]\h\[[0m\]:\[[32m\]\W\[[0m\] (old)$(__a=$?;if (($__a));then echo -n "\[\e[31;1m\]"[$__a];fi)\[\e[00m\]\\$ '
fi
unset color_prompt force_color_prompt

function bash_getstarttime()
{
    # places the epoch time in seconds into shared memory
    date +%s >"/dev/shm/${USER}.bashtime.${1}"
}

function bash_getstoptime()
{
    starttime_file="/dev/shm/${USER}.bashtime.${1}"
    if [ ! -f "${starttime_file}" ]; then
        echo 0
        return
    fi

    # reads stored epoch time and subtracts from current
    endtime=$(date +%s)
    starttime=$(cat "${starttime_file}")
    rm -f "${starttime_file}"
    echo "$endtime - $starttime" | bc
}

function seconds_to_human()
{
    secs="$1"
    days="$((secs / 86400))"
    hours="$((secs % 86400 / 3600))"
    mins="$((secs % 3600 / 60))"
    secs="$((secs % 60))"
    if [ "${days}" -gt 0 ]; then
        printf "%dd " "${days}"
    fi
    if [ "${days}" -gt 0 ] || [ ${hours} -gt 0 ]; then
        printf "%dh" "${hours}"
    fi
    if [ "${days}" -gt 0 ] || [ ${hours} -gt 0 ] || [ ${mins} -gt 0 ]; then
        printf "%dm" "${mins}"
    fi
    printf "%ds" "${secs}"
}

function runonexit (){
  rm -f "/dev/shm/${USER}.bashtime.${ROOTPID}"
}

trap runonexit EXIT

ROOTPID=$BASHPID
# shellcheck disable=SC2034,SC2016
PS0='$(bash_getstarttime "${ROOTPID}")'

PROMPT_COMMAND=__get_prompt
function __get_prompt()
{
  rc=$?
  exec_time=$(bash_getstoptime ${ROOTPID})
  PS1=""
  # Execution time of previous command (if greater than threshold)
  if [ "${exec_time}" -gt 30 ]; then
      # shellcheck disable=SC2154
      PS1+="${Yellow}Execution time: ${Color_Off}$(seconds_to_human "${exec_time}")${Color_Off}\n"
  fi

  # Virtual env
  if [ -z "${VIRTUAL_ENV_DISABLE_PROMPT-}" ] ; then
      if [ -n "${VIRTUAL_ENV}" ]; then
          PS1+="($(basename "${VIRTUAL_ENV}"))"
      fi
  fi

  # Time and date
  # shellcheck disable=SC2154
  PS1+="${ICyan}[\t${Color_Off}-${Cyan}\D{%d.%m.%Y}]$Color_Off "

  # Username
  if [ "$(whoami)" = "root" ]; then
    # shellcheck disable=SC2154
    PS1+="${Red}\u${Color_Off}"
  elif [ "$(whoami)" = "sandworm" ]; then
    # shellcheck disable=SC2154
    PS1+="${Green}\u${Color_Off}"
  else
    # shellcheck disable=SC2154
    PS1+="$Purple\u${Color_Off}"
  fi

  # @ sign between username and hostname
  # shellcheck disable=SC2154
  PS1+="${IBlue}@${Color_Off}"

  # Hostname
  if [ "$(whoami)" = "sandworm" ]; then
    # shellcheck disable=SC2154
    PS1+="${BGreen}\h${Color_Off}"
  else
    # shellcheck disable=SC2154
    CURRENT_HOSTNAME="$(hostname)"
    if [ "${CURRENT_HOSTNAME}" = "firefly" ]; then
      HOST_COLOR="\[\e[1;30;44m\]"
    elif [ "${CURRENT_HOSTNAME}" = "mordor" ]; then
      HOST_COLOR="\[\e[30;43m\]"
    elif [ "${CURRENT_HOSTNAME}" = "nostromo" ]; then
      HOST_COLOR="\[\e[30;42m\]"
    else
      HOST_COLOR="${Yellow}"
    fi
    PS1+="${HOST_COLOR}\h${Color_Off}"
  fi

  # dirname color
  # shellcheck disable=SC2154
  PS1+=":${Green}\W${Color_Off}"
  function_exists __git_ps1 && PS1+="${Cyan}$(__git_ps1)${Color_Off}"
  if [ $rc -ne 0 ]; then
    PS1+="${Red}[$rc]${Color_Off}"
  fi
  if [ "$(whoami)" = "root" ]; then
    PS1+=" # "
  else
    PS1+=" \$ "
  fi
}

# some system do not use vim as default editor
EDITOR=vim

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ]; then
      eval "$(dircolors -b ~/.dircolors)"
  else
      eval "$(dircolors -b)"
  fi
fi

# Define your own aliases here ...
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f "$HOME/.git-completion.bash" ]; then
  . "$HOME/.git-completion.bash"
fi

if [ -f "/usr/share/bash-completion/completions/fzf" ]; then
  . /usr/share/bash-completion/completions/fzf
fi

if [ -f "${HOME}/.local/bin/virtualenvwrapper.sh" ]; then
    . "${HOME}/.local/bin/virtualenvwrapper.sh"
fi

if [ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ]; then
  . /usr/share/doc/fzf/examples/key-bindings.bash
  # Keep original reverse search history available on alt-o, this allows to use ctrl-o
  # to accept and execute, which is not possible with fzf yet
  # https://github.com/junegunn/fzf/issues/2399
  bind '"\eo": reverse-search-history'
fi

export TERM=xterm-256color
