# vim: syntax=sh shiftwidth=2 filetype=sh:
function function_exists() {
  declare -f -F $1 > /dev/null
  return $?
}
#
# This file can be sourced for zsh shells and bash
# complete command is not supported by zsh so they are commented out
# Shell shortcuts
alias ls='ls --color=auto'
alias ll='ls -l --time-style="+%F %H:%M:%S"'
alias la='ls -A --color=tty'
alias l='ls'
alias lt='ls -lrt'
alias lth='ls -lrth'
alias xt='xterm -vb -sb&'
alias tree="tree -CAFa --dirsfirst -I 'CVS|*.*.package|.svn|.git'"
alias cp='cp -p'
alias grep='grep --color=auto'
alias cdlast='cd $(ls -p | grep "/" | tail -1)'

#admin
alias clocksync='sudo ntpdate fr.pool.ntp.org'

#alias vman="col -b | view -c 'set ft=man nomod nolist' -"
vman() { `which man` $* | col -b | ~/.vim/macros/less.sh -c 'set ft=man nomod nolist' -; }
alias boxdone='kdialog --msgbox'
alias wakeup='kdialog --msgbox "wake up"'
alias wakeupmail='echo "job finished" | mail -s "WAKE UP" nvincent@sequans.com'

# rm
alias rmti='rm -fv *~ #'
alias rmtir='find ./ -name "*~" -exec rm -v {} \;'
alias rmswp='rm -fv .*.swp #'

# avoid mistakes
alias ivm="vim"
alias sl='ls'
alias lls='ls'
alias ccd='cd'
alias cdd='cd'
alias gti='git'
alias unrare='unrar e'

# Sound 
alias snd2hdmi='pactl set-card-profile 0 output:hdmi-stereo-extra1'
alias snd2spkr='pactl set-card-profile 0 output:analog-stereo'
# Record from microphone
alias micrec="artsrec -b 16 -r 44100 -c 2"

# Webcam Quickcam
alias qcshow="mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0:outfmt=yuy2"
alias qcmirror="mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0:outfmt=yuy2 -vf mirror"
alias qcrec="mencoder tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0:outfmt=yuy2 -ovc lavc -lavcopts vcodec=mpeg4 -o "
alias qcskype="cd /home/nicolas/Documents/fichiers/gstfakevideo/ && ./gstfakevideo v4lsrc device=/dev/video0 ! ffmpegcolorspace"

#alias cdlast='cd `ls -1t -d */ | head -n1`'
alias tclsh='rlwrap tclsh'
alias lh='ls -lh'
alias g='gvim'
alias v='vim'
alias sl="ls"
alias ralias='source ~/.bash_aliases'
alias findvhdl='find . -name *vhd'
alias grepinvhdL='find . -type f -iregex ".*vhd\(l\)?" | xargs grep --color=auto'
alias grepinvhdl='find . -type f -iname "*vhdl" | xargs grep --color=auto'
alias grepintex='find . -iname "*tex" | xargs grep --color=auto'
alias grepinpy='find . -iname "*py" | xargs grep --color=auto'
alias grepinc='find . -not -name "*.svn*" -regex ".*\.[ch]\(c\|pp\)?" | xargs -d "\n" grep --color=auto'
alias grepinveri='find . -regex ".*\.v" | xargs grep --color=auto'
alias grepinmk='find . -iregex ".*mk\|.*GNUmakefile\|.*Makefile" | xargs grep --color=auto'
alias lspath='echo $PATH | sed "s/:/\n/g"'
alias pst='ps axfo pid,user,%cpu,%mem,etime,tty,args'
alias diff='diff -U 2'
_konsole_dbus_session_name()
{
  echo org.kde.konsole-$(pstree -p -s $(ps | grep $(basename $(echo $0)) | head -1 | awk '{print $1}') | grep -o 'konsole([0-9]\+)' | grep -o '[0-9]\+')
}

# vim
alias vimaliases='vim ~/.bash_aliases'

# task
alias taskn='task rc:$HOME/.task_niju/.taskrc'
_task_complete_wrp()
{
  # Set taskcommand according to which task profile is used
  if [ "$1" = "task" ]; then
    taskcommand='task rc.verbose:nothing rc.confirmation:no rc.hooks:off'
  fi
  if [ "$1" = "taskn" ]; then
    taskcommand='task rc:~/.task_niju/.taskrc rc.verbose:nothing rc.confirmation:no rc.hooks:off'
  fi
  _task $@
}
if [ -f /usr/share/bash-completion/completions/task ]; then
  # It looks like the following is sourced on demand by bash completion system,
  # In our case we want it to be available for user otherwise _task function is
  # unknown
  source /usr/share/bash-completion/completions/task
  complete -o nospace -F _task_complete_wrp task
  complete -o nospace -F _task_complete_wrp taskn
fi

# System 
alias haltkde="dcop --all-sessions --all-users ksmserver ksmserver logout 0 2 0"
alias rebootkde="dcop ksmserver default logout 0 1 0"
alias format_clef_usb_mp3="echo mkfs.vfat -F 16 -n usbdisk -S 512 -v -I /dev/sda"
alias apn="sudo gphotofs /camera/ -o allow_other"
alias uapn="sudo umount /camera"
alias temperature="cat /proc/acpi/thermal_zone/THRM/temperature" 
# Force screen to suspend (usefull on laptop after an app has disabled it or after onscreen)
alias offscreen="xset dpms force suspend"
# Force screen to stay on (usefull when watching youtube videos)
alias onscreen="xset -dpms"
alias fboxhd="lftp freebox@hd1.freebox.fr"
alias genpasswd="apg -m 8 -x 8 -M NC -t"
# Generate password, with symbol excluding symbol which are not part of a word
alias genpasswd2="apg -a 1 -m 20 -x 20 -M NCSL -E \"*^+=,;:\$|<>#[](){}\\\"\'\\\`\\!\""
alias genpasswd3="apg -a 1 -m 20 -x 20 -M NCSL"
alias genpasswds="echo '--- Pronunciable passwords:' \
                  && genpasswd \
                  && echo '--- Selectionnable passwords:' \
                  && genpasswd2 \
                  && echo '--- Hard passwords:' \
                  && genpasswd3"
# map key above <TAB> to <TAB> (broken <TAB> on my laptop)
alias tabremap='xmodmap -e "keycode 49 = Tab"'
alias myps='/bin/ps -u "$USER" -o user,pid,ppid,pcpu,pmem,args'
alias path='echo -e ${PATH//:/\\n}'
alias top10_2="awk '{print $2}' | sort | uniq -c | sort -rg | head"
alias top10="sed -e 's/sudo //' $HOME/.bash_history | cut -d' ' -f1 | sort | uniq -c | sort -rg | head"
# Force touchpad state
alias offtouchpad='synclient TouchpadOff=1'
alias ontouchpad='synclient TouchpadOff=0'

# Lftp to various destinations
alias lftp_get27="lftp -u pi,dummy_password sftp://get27"
alias lftp_cubalibre="lftp -u admin,dummy_password sftp://cubalibre"
alias lftp_cosmo="lftp -u nicolas,dummy sftp://cosmopolitan"
alias fbox='lftp freebox@hd1.freebox.fr'
alias freeftp='lftp "nico.vince@gmail.com"@dl.free.fr'

alias rcd='cd $(pwd)'
# cd to file's directory
fcd()
{
  cd `dirname $1`
}
# ls environement variable given in arg in a readable form
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

# gh cli
alias get_gh_completion='eval "$(gh completion -s bash)"'


## Sequans Work
# Vim on (common) files
alias vimweekly='vim $HOME/work/weekly.txt +999999'
alias vimhowto='vim $HOME/work/howto'
alias cathowto='cat $HOME/work/howto'
alias lesshowto='vless $HOME/work/howto'
alias vimaar='vim $HOME/work/aar'
alias sap='rdesktop -d sequans -u "nvincent" -p - -r disk:home=/home/$USER/ -g 1660x960  192.168.200.16'

# setup konsole (kde) with gonzalez
alias setup_env='gonzalez.py -f ~/configrc/gonzalez_config/env.json'
alias setup_pi='gonzalez.py -f ~/configrc/gonzalez_config/pi.json'
alias setup_placebo='gonzalez.py -f ~/configrc/gonzalez_config/placebo.json'
alias setup_pcm='gonzalez.py -f ~/configrc/gonzalez_config/pcm.json'
alias setup_palladium='gonzalez.py -f ~/configrc/gonzalez_config/palladium.json'

## NotiloPlus Work
alias cdnot='cd $HOME/work/NotiloPlus/'
alias cdbb='cd $HOME/work/NotiloPlus/repos/ArduBubble'
alias notilenv='source $HOME/work/NotiloPlus/notilo.env'

## Siema Work
alias siemaenv='source $HOME/work/siema.env'
alias vimwork='vim $HOME/work/work.txt'
alias cdvigi='cd $HOME/work/siema/be/vigizone'
alias cdinno='cd $HOME/work/siema/innovation'
alias cdbe='cd $HOME/work/siema/be'
alias cdvog='cd $HOME/work/siema/be/VOG'
alias cducc32='cd $HOME/work/siema/be/UCC32/'
alias cdsiema='cd $HOME/work/siema/'
alias cdqa='cdsiema && cd quick_apps'
alias cdst='cd $HOME/work/siema/vendors/ST'
alias cddatasheets='cd $HOME/work/siema/datasheets'
alias get_esp32='export PATH=$PATH:$HOME/.espressif/tools/xtensa-esp32-elf/1.22.0-80-g6c4433a-5.2.0/xtensa-esp32-elf/bin/'
alias get_r4ip='export PATH=$PATH:/home/nicolas/work/siema/be/vigizone/r4ip-buildroot/output/host/bin/'
alias get_stm32='source $HOME/work/siema/vendors/ST/env.sh'
alias get_zephyr='export PATH=$PATH:$HOME/.local/opt/zephyr-sdk-0.11.3/arm-zephyr-eabi/bin/'
alias scpnhc='scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias sshnhc='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias zeph='cd /home/nicolas/work/siema/be/VOG/src/zephyrproject/ && workon zephyr && source zephyr/zephyr-env.sh'
alias get_tmux_sessions='source $HOME/.dotfiles/tmux_sessions.sh'

br2vigitftp()
{
  local build_dir=$(find . -maxdepth 2 -name images)
  local tftp_dir=/media/nvi/siema/tftp/vigizone
  "cp" -v ${build_dir}/uImage ${build_dir}/tboxcp11-ucc32-p3.dtb ${tftp_dir}
  if [ -f ${build_dir}/rootfs.squashfs ]; then
    "cp" -v ${build_dir}/rootfs.squashfs ${tftp_dir}
  fi
  if [ -f ${build_dir}/apps.tar.xz ]; then
    "cp" -v ${build_dir}/apps.tar.xz{,.md5} ${tftp_dir}
  fi
  "cp" -v ${build_dir}/tboxcp11-ucc32-p3.dtb ${tftp_dir}/tbox.dtb
  "cp" -v ${build_dir}/*.ipk ${tftp_dir}
}

btgsmrbins2windows()
{
  local win_dir=/media/nvi/siema/work/innovation/btgsmr/bin/
  local build_dir=$(find . -maxdepth 2 -name build)
  find ${build_dir} -name "*.bin" -exec "cp" -v {} ${win_dir} \;
  find ${build_dir} -name "*.elf" -exec "cp" -v {} ${win_dir} \;
}

# Movies and series aliases
# run at 25 frame per seconds to avoid subtitles being out of sync
alias 24='gmplayer -alang en -slang eng -fps 25'
# adds de-interlacing post processing when watching friends dvd
alias friends='mplayer -alang en -slang en -vf pp=lb'
# cd to dir and launch serie script
alias heroes='cd /media/data/Videos/Heroes_S4; serie'
alias bb='cd /media/data/Videos/Breaking_Bad/Season_04/; serie'
#alias lost_mp="gmplayer -subfont-text-scale 50"
#alias lost2_mp="gmplayer -subfont-text-scale 4"
alias engvid="gmplayer -alang en -slang en"
alias emule="cd ~/.aMule/Incoming"
alias Videos="cd /media/data/Videos"
alias VideosBuf="cd /media/buffalo/videos"
alias VideosWin="cd '/media/data/VideosWin'"
alias Musique="cd /media/data/Musique"
rda()
{
  gmplayer -alang en -slang en *$1*
}
nsserie()
{
  gmplayer *$1*
}

# buffalo
alias wakeupbuffalo="wakeonlan 00:1D:73:A4:4D:4C"
alias buffalorsync="rsync -avz --size-only --progress"

# cosmopolitan
COSMO="00:12:3f:74:6b:79"
alias wakeupcosmo="wakeonlan ${COSMO}"
alias wakeupcosmolong="ssh buffalolong ssh get27 wakeonlan ${COSMO}"
alias wakeupcosmolocal='ssh get27 wakeonlan ${COSMO}'

# ginfizz
GINFIZZ="30:9c:23:e1:25:c9"
alias wakeupginfizz='wakeonlan ${GINFIZZ}'
alias wakeupginfizzlocal='ssh moscatel wakeonlan ${GINFIZZ}'

#games
alias ksp="~/Games/KSP_linux/KSP.x86_64"


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

# decimal, binary, hexadecimal transformation
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
  for e in $*; do
    echo "obase=16; $e" | bc -l
  done
}
hex2dec()
{
  for e in $*; do
    echo "ibase=16; $(echo $e | tr 'a-z' 'A-Z')" | bc -l
  done
}

hex2bin()
{
  for e in $*; do
    echo "ibase=16; obase=2; $(echo $e | tr 'a-z' 'A-Z')" | bc -l
  done
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

# Display heand and tail of file given in argument
headtail()
{
  head $@;
  echo "...."
  tail $@;
}

# Open file given in argument which is located somewhere in the path
# useful for scripts
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

# Open web browser for given commit
function trac()
{
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


# backup each file given in argument with the current date as suffix
function cpdate() {
 cur_date=`date +%Y%m%d.%H%M%S`
 for i in $*

 do

  cp -rp "${i%%/}" "${i%%/}.${cur_date}"
 done
}

function zendone() {
  # Save return code of previous command to return it at the end of this
  # function because I use this to notify me when a job is done, I
  # want the return code of the previous command, not zenity's
  ret=$?
  box_type="info"
  # box type depends on last return code
  if [ $ret -ne 0 ]; then
    box_type="error"
  fi
  date
  zenity --${box_type} --text "$1" 2> /dev/null
  return ${ret}
}

function siema_help() {
  echo '"cp" output/images/apps.tar.xz{,.md5} output/images/uImage output/images/tboxcp11-ucc32-p3.dtb output/images/rootfs.jffs2 /media/nvi/siema/tftp/vigizone/'
  echo -e '\tCopy buildroot output file to TFTP folder\n'
  echo '"cp" output/images/tboxcp11-ucc32-p3.dtb /media/nvi/siema/tftp/vigizone/tbox.dtb'
  echo -e '\tRename device tree properly to TFTP folder\n'
  echo  'ifconfig br0 192.168.1.2'
  echo  'umount /lib/modules'
  echo  'cd /lib/modules/4.19.25-R4IP/kernel/drivers/net/sdfe4/'
  echo  'mount -o remount,rw / && tftp -g -r sdfe4.ko 192.168.1.1 && sync'
  echo  'mount -o remount,ro / && reboot'
  echo -e '\tUpdate module without flashing all rootfs\n'
  echo  'cpio -idv < file.cpio'
  echo -e '\tExtract cpio archive'
  echo  'scp nicolas@172.19.86.215:/home/nicolas/work/siema/be/vigizone/r4ip-buildroot/output/images/{uImage,rootfs.jffs2,apps.tar.xz,apps.tar.xz.md5,tboxcp11-ucc32-p3.dtb} .'
  echo -e '\tCopy buildroot output files from debian vm hyperV'
}

function oneliners() {
  echo 'Sum each lines: '
  echo "awk '{s+=\$1} END {print s}'"
  echo 'Archive HEAD of current git repository:'
  echo 'git archive -o file.zip --prefix=prefix-name/ $(git log -1 --pretty=%H)'
}

function _crc32() {
  FILE="$1"
  if [ -f "${FILE}" ]; then

    echo -n "0x"
    cat "${FILE}" | gzip -c | tail -c8 | hexdump -n4 -e '"%x"'
    echo
  else
    echo "No such file or directory: ${FILE}"
  fi
}
