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
exec awesome
