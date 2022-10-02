#!/bin/bash



sudo systemctl enable sshd
sudo systemctl start sshd

sudo pacman -S git polybar rofi dunst thunar kitty neovim btop xplr pkgfile alacritty feh unzip ranger neofetch





# Copy Xorg config files to user directory
cp .xinitrc ~/
cp .xprofile ~/
cp .Xresources ~/


# Copy All configs to user directory
cp -r config/. ~/.config/

# Copy Wallpaper
cp -r .wallP  ~/




#### Install yay  (need base-devel + user in sudoers)		######

git clone https://aur.archlinux.org/yay.git
sudo chown -R  $USER:users yay
cd yay
makepkg -si

yay -S st nerd-fonts-fira-code nerd-fonts-jetbrains-mono

