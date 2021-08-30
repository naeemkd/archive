#!/bin/sh

# Set refresh rate
xrandr -r 75 &

# Wallpaper (NOTE: Pcmanfm desktop manager changes wallpaper)
nitrogen --set-zoom-fill /icecold.png & # This is the KDE ice cold wallpaper
#nitrogen --set-zoom-fill ~/Wallpapers/ricardo-gomez-angel-180819-blue.jpg & # This is one of the wallpapers from Pop!_OS

# Keyboard settings
setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl -option caps:none # caps led off and us layout
xmodmap -e "keycode 66 = BackSpace" & # caps to backspace

# Load xresources
xrdb ~/.Xresources &

# Pcmanfm daemon
pcmanfm --daemon-mode &

# Xmobar
xmobar &

# Fix mouse cursor
xsetroot -cursor_name left_ptr &

# Picom compositor
picom --experimental-backends -m 1 --vsync -f &

# Xfce panel
xfce4-panel --disable-wm-check &

# Tint2 panel (NOTE: this doesn't work with pcmanfm desktop)
tint2 &

# Notifications
/usr/lib/xfce4/notifyd/xfce4-notifyd &

# Polkit
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

# Xfce power manager
xfce4-power-manager &

# System tray icons
nm-applet &
pamac-tray &

# Flameshot
flameshot &

# Clipboard manager
xfce4-clipman &

# Conky
conky &
