# Set up the prompt

autoload -Uz promptinit
promptinit

setopt histignorealldups

# Allows shell to be exited if some gui application launched from the shell is still running
setopt NO_HUP
# Disable warning that there is an existing job running
setopt NO_CHECK_JOBS

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit
autoload -U colors && colors
# Custom prompt : return code if non zero, time, date, user, workstation, current folder
PROMPT="%(?..%B%F{red}[%?]%b%f)%B%F{blue}%D{%T}%f%b %B%F{black}%D{%d.%m}%f%b %F{yellow}%n@%m%k %B%F{cyan}%~%F{white} %# %b%f%k"

source ~/configrc/git_prompt.zsh

autoload edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

PATH="$PATH:$HOME/bin"

# map alt-p and alt-n to search history
bindkey "^[p" history-beginning-search-backward
bindkey "^[n" history-beginning-search-forward

# aliases 
source ~/.bash_aliases
