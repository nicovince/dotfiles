# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
#export HISTCONTROL=ignoredups
HISTSIZE=100000
HISTFILESIZE=100000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi



# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color)
	PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]]\$ '
	;;
	*)
#	PS1='[${debian_chroot:+($debian_chroot)}\u@\h \W]\$ '
	#a cool prompt
#	PS1="[\t] \u@\h:\W \!:\$RV\\$ "
PS1='\[\033[36m\][\t]\[\033[0m\] \[\033[35m\]\u\[\033[0m\]\[\033[34m\]@\[\033[0m\]\[\033[33m\]\h\[\033[0m\]:\[\033[32m\]\W\[\033[0m\] \!$(__a=$?;if (($__a));then echo -n "\[\e[31;1m\]"[$__a];fi)\[\e[00m\]\\$ '
#PS1='\[[36m\][\t]\[[0m\] \[[35m\]\u\[[0m\]\[[34m\]@\[[0m\]\[[33m\]\h\[[0m\]:\[[32m\]\W\[[0m\] \!$(__a=$?;if (($__a));then echo -n "\[\e[31;1m\]"[$__a];fi)\[\e[00m\]\\$ '
	;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
	PROMPT_COMMAND='RV=$?;echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
	;;
	*)
	;;
esac

# Define your own aliases here ...
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi
