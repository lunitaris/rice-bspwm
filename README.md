# My personal dotfiles for bspwm (rice) : 


## Description
This is my personal rice of Archlinux + bspwm, including:

- BSPWM and SXHKD configuration and keybindings
- Picom configuration (todo)
- Polybar configuration and scripts
- A custom .Xresources color palette
- GTK theme
- rofi custom menus and configurations
- dunst notifications
- Kitty configuration (todo)
- alacritty configuration (todo)
- pscircle configuration (as service)


## Prerequisites

Install Archlinux with bspwm.
To speed up process you can use the `archinstall` command and select the installation profile as Desktop with bspwm.
Of course, if you are new to Archlinux, i highly recommend you to install it on your own to learn how linux works.

## Installation

```bash
git clone https://github.com/lunitaris/rice-bspwm/
cd rice-bspwm
./install.sh
```

During the installation, your terminal might ring a bell before installing yay or running makepkg.
This is just for alerting user to go check on installation script to answer to queries and not time-out install.

### Bugs

Black display at boot after the autologin.
This is because xinit is starting too soon, before Vmware auto-resize screen. (I don't know exactly which service is involved)
To fix the issue, just extend the sleep value in ~/.bash_profile

### Note
This configuration is a mix of my own and various config files I took from people (mainly found on unixporn reddit).
Here are my inspiration and also others interresting configs to look:<br>
https://github.com/Kurolox/dotfiles<br>
https://github.com/Mofiqul/Dotfiles<br>
https://github.com/GlitchMill/dotfiles