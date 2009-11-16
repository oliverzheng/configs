#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

# exec gnome-session
# exec startkde
# exec startxfce4
# exec icewm
# exec openbox
# exec blackbox
# exec fluxbox
# exec ratpoison
# exec dwm
# ... or any other WM of your choosing ...

# {{{ Log settings
errorlog="$HOME/.xsession-errors"

# Start with a clean log file every time
if ( cp /dev/null "$errorlog" 2> /dev/null ); then
   chmod 600 "$errorlog"
   exec > "$errorlog" 2>&1
   break
fi
# }}}

xmodmap ~/.Xmodmap
xset -b r rate 225 50
xsetroot -cursor_name left_ptr
#xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &
xcompmgr -F -D 1 &

screen -d -m rtorrent

export XMODIFIERS=@im=SCIM
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"

scim -d

exec awesome
