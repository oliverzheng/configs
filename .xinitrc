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

xmodmap ~/.Xmodmap
xset -b r rate 225 50
xsetroot -cursor_name left_ptr
#xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &
xcompmgr -fF -D 3 &

screen -d -m rtorrent

export XMODIFIERS=@im=SCIM
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"

scim -d

exec awesome
