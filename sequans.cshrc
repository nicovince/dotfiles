# @(#)cshrc 14 Avril 1999
#hostname

# file completion
set filec

#limit descriptor 1024
limit coredumpsize 0

##
## History configuration
##
set histfile = /home/$USER/.history
set histdup  = erase
set ignoreeof

if ( $?prompt ) then
        set history=10000
endif
set history=10000
set savehist=(10000 merge)


set new
set autolist = ambiguous
set listflags = -AF
set matchbeep = never
#set printexitvalue
set notify

#
# prompt before `rm *` is executed (if  USER is set)
#
set rmstar

#
# list of directories in which cd should search
# for subdirectories
# if not present in current directory
#
set cdpath = (~ )


###
### Source Common file for csh or tcsh
###

if (-r ~/.mycshrc) then
    source ~/.mycshrc
endif
