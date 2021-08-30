#!/bin/sh

# Set refresh rate
xrandr -r 75 &

# Wallpaper
nitrogen --set-zoom-fill "/icecold.png" & # This is the KDE ice cold wallpaper

# Load xresources
xrdb ~/.Xresources &

# Picom compositor
picom --experimental-backends -m 1 --vsync -f &

# Polkit
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

# Xfce power manager
xfce4-power-manager &

# Polybar
~/.config/polybar/launch.sh &

# Notifications
/usr/lib/xfce4/notifyd/xfce4-notifyd &

# System tray icons
nm-applet &
pamac-tray &
blueman-applet &

# Conky
conky &

# Flameshot
flameshot &

# Thunar daemon
thunar --daemon &
