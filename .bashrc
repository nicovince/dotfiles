# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=100000
HISTFILESIZE=100000
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
has_color_vars=0
if [ -f $HOME/.bash_colors ]; then
  has_color_vars=1
  source $HOME/.bash_colors
fi


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
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
    PS1='\[[36m\][\t]\[[0m\] \[[35m\]\u\[[0m\]\[[34m\]@\[[0m\]\[[33m\]\h\[[0m\]:\[[32m\]\W\[[0m\] (old)$(__a=$?;if (($__a));then echo -n "\[\e[31;1m\]"[$__a];fi)\[\e[00m\]\\$ '
fi
unset color_prompt force_color_prompt

export PROMPT_COMMAND=__get_prompt
function __get_prompt() {
  rc=$?
  PS1="$Cyan[\t]$Color_Off $Purple\u${Color_Off}${Blue}@${Color_Off}${Yellow}\h${Color_Off}:${Green}\W${Color_Off}"
  if [ $rc -ne 0 ]; then
    PS1+="${Red}[$rc]${Color_Off}"
  fi
  PS1+=" \$ "
}


# Define your own aliases here ...
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi
