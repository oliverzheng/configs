alias du='du -h'
alias df='df -h'
alias grepi='grep -n --color'
alias grep='grep -in --color'
alias l='ls -lh --format=single-column --group-directories-first'
alias la='ls -Alh --format=single-column --group-directories-first'
alias ls='ls -h --color=tty --group-directories-first'
alias ll='ls -hAl --color=tty --group-directories-first'
alias llt='ls -hAl --color=tty --group-directories-first --sort=time'
alias list='tree -hSAC --dirsfirst -L 2'
alias ..='cd ..'
alias tagsup='ctags --languages=c,c++ -R *'
alias vi='vim'
alias free='free -m'

function g() { cd $1 && l; }
function calc () { awk "BEGIN { print $* ; }"; }


export PS1='\[\033[1;30m\]\w: \[\033[00m\]'

export FBCMD="/home/oliver/.fbcmd"

export EDITOR=vim
export VISUAL=vim
export PATH=~/playground/app-engine-patch-sample:~/util/google_appengine:~/util:.:$PATH

alias pow="wine '/home/oliver/.wine/drive_c/SuperMemo Extreme English!/MSM.exe' 'Power Words!.kno'"
alias vcm="cd '/home/oliver/.wine/drive_c/SuperMemo Extreme English!/' && svn commit -m 'update' && cd -"
alias vup="cd '/home/oliver/.wine/drive_c/SuperMemo Extreme English!/' && svn update --accept theirs-full && cd -"

alias pacman="yaourt"
alias oi="offlineimap"
alias oif="offlineimap -f INBOX"
alias wn="dict -d wn"
alias wg="dict -d gcide"

alias ds="dev_appserver.py --address=0.0.0.0"
alias au="appcfg.py update"
alias xp="VirtualBox --startvm 'Windows XP'"

alias p4="p4 -u x4c6 -P lerssep4 -p lersse-p4.ece.ubc.ca:1666"
alias shutdown="sudo shutdown -h now"
