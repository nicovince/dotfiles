# vim: set syntax=sh sw=2:
#
# This file can be sourced for zsh shells and bash
# complete command is not supported by zsh so they are commented out
# Shell shortcuts
alias ls='ls --color=auto'
alias ll='ls -l --time-style="+%F %H:%M:%S"'
alias la='ls -A --color=tty'
alias l='ls'
alias lt='ls -lrt'
alias xt='xterm -vb -sb&'
alias tree="tree -CAFa --dirsfirst -I 'CVS|*.*.package|.svn|.git'"
alias cp='cp -p'

#admin
alias clocksync='sudo ntpdate fr.pool.ntp.org'
alias sudo='sudo env PATH=$PATH'

#alias vman="col -b | view -c 'set ft=man nomod nolist' -"
vman() { `which man` $* | col -b | ~/.vim/macros/less.sh -c 'set ft=man nomod nolist' -; }
alias boxdone='kdialog --msgbox'
alias wakeup='kdialog --msgbox "wake up"'
alias wakeupmail='echo "job finished" | mail -s "WAKE UP" nvincent@sequans.com'

#alias cdlast='cd `ls -1t -d */ | head -n1`'
alias tclsh='rlwrap tclsh'
alias lh='ls -lh'
alias vless='~/.vim/macros/less.sh'
alias gless='~/.vim/macros/gless.sh'
alias rmti='rm -fv *~ #'
alias rmtir='find ./ -name *~ -exec rm -v {} \;'
alias rmswp='rm -fv .*.swp #'
alias g='gvim'
alias v='vim'
alias sl="ls"
alias ssh="ssh -X"
alias ralias='source ~/.bash_aliases'
alias findvhdl='find . -name *vhd'
alias grepinvhdL='find . -type f -iregex ".*vhd\(l\)?" | xargs grep --color=auto'
alias grepinvhdl='find . -type f -iname "*vhdl" | xargs grep --color=auto'
alias grepintex='find . -iname "*tex" | xargs grep --color=auto'
alias grepinc='find . -not -name "*.svn*" -regex ".*\.[ch]\(c\)?" | xargs grep --color=auto'
alias grepinveri='find . -regex ".*\.v" | xargs grep --color=auto'
alias grepinmk='find . -regex ".*mk\|.*GNUmakefile\|.*Makefile" | xargs grep --color=auto'
alias lspath='echo $PATH | sed "s/:/\n/g"'
alias pst='ps axfo pid,user,%cpu,%mem,etime,tty,args'
alias diff='diff -U 2'

alias ivm='vim'
alias vimaliases='vim ~/.bash_aliases'
alias vimweekly='vim $HOME/work/weekly.txt +999999'
alias vimhowto='vim $HOME/work/howto'
alias cathowto='cat $HOME/work/howto'
alias lesshowto='vless $HOME/work/howto'
alias vimaar='vim $HOME/work/aar'
alias sap='rdesktop -d sequans -u "nvincent" -p - -r disk:home=/home/$USER/ -g 1660x960  192.168.200.16'

# cd to file's directory
fcd()
{
  cd `dirname $1`
}
# ls environement variable in a readable form
lsv()
{
  echo $1 | sed "s/:/\n/g"
}

#svn aliases
alias stu='svn st -u -q'
alias stui='svn st -u -q --ignore-externals'
alias svnup='svn up'
alias sup='svn up --ignore-externals'
alias undocommit='echo  svn merge -r HEAD:PREV toto.c or svn merge -r HEAD:555 toto.c'
svndiff()
{
  svn diff $@ | vless
}
svnblame()
{
  svn blame $@ | vless
}


# setup konsole with gonzalez
alias setup_env='gonzalez.py -f ~/configrc/gonzalez_config/env.json'
alias setup_pi='gonzalez.py -f ~/configrc/gonzalez_config/pi.json'
alias setup_placebo='gonzalez.py -f ~/configrc/gonzalez_config/placebo.json'
alias setup_pcm='gonzalez.py -f ~/configrc/gonzalez_config/pcm.json'
alias setup_palladium='gonzalez.py -f ~/configrc/gonzalez_config/palladium.json'


#RADIOS
alias ouifm='vlc http://broadcast.infomaniak.ch/ouifm-high.mp3.asx'
alias virgin='vlc rtsp://viplagardere.yacast.net/encodereurope2'
alias rtl2='vlc http://streaming.radio.rtl2.fr:80/rtl2-1-44-96'
alias rfm='vlc http://player.rfm.fr/V4/player_rfm/rfm.asx'
alias radios='echo ouifm virgin rtl2 rfm'
alias chantefrance='mplayer http://88.191.22.108:19090/listen.pls'

#various functions
# colorstderr command 
colorstderr()
{
  "$@" 3>&1 1>&2 2>&3 | sed 's/^\(.*\)$/[31m\1[0m/'
}

bin2dec()
{
  echo "ibase=2; $1" | bc -l
}

dec2bin()
{
  echo "obase=2; $1" | bc -l
}

dec2hex()
{
  echo "obase=16; $1" | bc -l
}
hex2dec()
{
  echo "ibase=16; $1" | bc -l
}

hex2bin()
{
  echo "ibase=16; obase=2; $1" | bc -l
}

bin2hex()
{
  echo "obase=16; ibase=2; $1" | bc -l
}

lcd()
{
  command cd $@;dir --color;
}

er()
{
  command gvim --remote-tab +p $@ 2> /dev/null & 
} 

headtail()
{
  head $@;
  echo "...."
  tail $@;
}

binvim()
{
  vim `which "$1"`
}
# following line is not supported by zsh
#complete -c binvim

bincat()
{
  cat `which "$1"`
}
#complete -c bincat

findolder()
{
  find . \( ! -name . -prune \) -type d  -mtime +$1 
}

function cporig ()
{
  cp -rp "${1%%/}" "${1%%/}.orig"
}

function trac() {
 for i in $*
 do
  cmd=`svn info $i | sed -n "s%URL: https://svn.zfr.zoran.com/\(SRV-SOFT\|HARDWARE\)/%firefox https://trac.zfr.zoran.com/\1/browser/% p"`
  if [[ -z $cmd ]]
  then
   cmd="firefox https://trac.zfr.zoran.com/HARDWARE/browser/"
  fi
  $cmd
 done
}


function cpdate() {
 cur_date=`date +%Y%m%d.%H%M%S`
 for i in $*
 do
  cp -rp "${i%%/}" "${i%%/}.${cur_date}"
 done
}
