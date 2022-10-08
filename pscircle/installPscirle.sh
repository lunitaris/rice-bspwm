#!/bin/bash
# Script by Lunitaris
# Install pscircle, create a systemd service to launch it every 30s seconds to change wallpaper automatically
# pscircle generate picture or wallpaper of current running processes.

# Check if 'yay' (AUR helper, package manager) is installed.
if (! which yay &> /dev/null)
then
    echo "yay is not installed, can't install pscircle"
    exit 1
fi

if (! which pscircle &> /dev/null)
then
    echo "Installing pscircle to generate wallpapers displaying process"
    yay -Sy pscircle
fi

if (which pscircle &> /dev/null)
then
    sudo cp pscircleSet /usr/bin/      # Custom script, launch pscircle with some args

    mkdir -p "$HOME/.config/systemd/user"
    cp pscircleSet.service "$HOME/.config/systemd/user/"
    systemctl --user enable pscircleSet
    systemctl --user start pscircleSet
    echo "Done installing pscircle."
    echo "You can anager service by running 'systemctl --user status pscircleSet'"
else
    echo "Error, pscircle command not found, is pscircle really installed?"
    echo "Not creating pscirle service as binary not found."
    exit 2
fi