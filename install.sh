#!/bin/bash
# Script by Lunitaris
#
# Works with fresh installed ArchLinux with bspwm.
# Just clone the repo wherever you want and launch install.sh
# To get updates, run 'git fetch' in the folder then install.sh
#
# First run: will install all packages and create a flag file in ~/.config/.green
#       This flag is just there for the install.sh script to next time you run it it won't re-install or update your packages.
#       So it won't broke packages with updates.
#
# Next runs: Will just deploy dotfiles.
#   Every time you run the script, it will re-create this folder and save your conf.
#   You can rollback to last backup with the '-r' flag.


BKP_FOLDER="~/.configBKP"   # Backup directory, 
VM="true"                   # set 'true' if running inside a VM to install vmtools. If Not, set 'false'

# USAGE
# install.sh        --> Will install or update your conf.
# install.sh -r     --> Rollback configs to last backup (if any).
# install.sh -b     --> Backup configs to $BKP_FOLDER folder

if [[ $1 != "" && $1 != "-r" && $1 != "-b" ]]
then
    echo "Usage:"
    echo " $0"
    echo " $0 [-b | -r | -h]"
    echo ""
    echo "   -b    backup current config"
    echo "   -r    rollback config to last backup"
    echo "   -h    shows this help message"
    echo ""
    echo "   Note: Backup folder is set to :  $BKP_FOLDER"
    echo "   To install or update config just launch without args"
    echo ""
fi


#   Script must be launched as user because it will potentialy install yay and use it.
#   And you are proprietary of you dotfiles so no need to be root. Will exit if not.
if [[ ! "$EUID" -ne 0 ]]
  then echo "Please run as normal user!"
  exit
fi


# Get directory where script install.sh is located
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function updateConf {

    echo "Installing Lunitaris's bspwm rice..."
    # Copy Xorg and bashrc config files to user directory
    cp $SCRIPT_DIR/.xinitrc     ~/
    cp $SCRIPT_DIR/.xprofile    ~/
    cp $SCRIPT_DIR/.Xresources  ~/
    cp $SCRIPT_DIR/.bashrc      ~/

    
    cp -r $SCRIPT_DIR/config/. ~/.config/   # Copy all configs to user directory
    cp -r $SCRIPT_DIR/.wallP    ~/          # Copy Wallpaper
    chmod +x  ~/.config/bspwm/*

    touch ~/.config/.green      # Flag file just for the install.sh script to know you already installed all packages.
    echo "Done!"
    source ~/.bashrc
}


function firstInstall {

    echo "Installing all packages..."
    # The "--noconfirm --needed" options tells pacman to just install if not present without asking confirmation.
    sudo pacman -Sy
    sudo pacman -S git polybar rofi dunst thunar kitty neovim btop xplr pkgfile alacritty feh unzip ranger neofetch fzf xorg-apps ttf-iosevka-nerd picom --noconfirm --needed
    sudo pacman -S exa lsd bat fd duf --noconfirm --needed      # Nice modern alternatives commands
    
    if [[ $VM == "true" ]]      # If running in a VM, install vmtools
    then
        sudo pacman -S open-vm-tools --noconfirm --needed
        sudo systemctl enable vmtoolsd
    fi

    # Check if 'yay' (AUR helper, package manager) is installed. Install it if not.
    # Will be needed to easely install any fonts
    if [[ ! `which yay &> /dev/null` ]]
    then
        echo 'yay is not installed, going to install it...'
        cd /tmp/
        git clone https://aur.archlinux.org/yay.git
        sudo chown -R  $USER:users yay
        cd yay
        makepkg -si
    fi

    echo "Installing Nerd fonts"
    yay -S nerd-fonts-fira-code nerd-fonts-jetbrains-mono
}



function makeBackup {
    echo "Creating backup of current config..."
    rm -rf $BKP_FOLDER 2> /dev/null
    mkdir $BKP_FOLDER

    cp ~/.xinitrc       $BKP_FOLDER
    cp ~/.xprofile      $BKP_FOLDER
    cp ~/.Xresources    $BKP_FOLDER
    cp ~/.bashrc        $BKP_FOLDER

    mkdir $BKP_FOLDER/.config
    cp -r  ~/.config/alacritty  $BKP_FOLDER/.config/
    cp -r  ~/.config/bspwm      $BKP_FOLDER/.config/
    cp -r  ~/.config/dunst      $BKP_FOLDER/.config/
    cp -r  ~/.config/gtk-3.0    $BKP_FOLDER/.config/
    cp -r  ~/.config/polybar    $BKP_FOLDER/.config/
    cp -r  ~/.config/rofi       $BKP_FOLDER/.config/
    cp -r  ~/.config/picom      $BKP_FOLDER/.config/
    cp -r  ~/.config/sxhkd      $BKP_FOLDER/.config/
    echo "Backup made in $BKP_FOLDER"
}


function rollbackBackup {
    echo "Rolling back changes to last backup ($BKP_FOLDER)..."

    # Check for backup foler
    if [[ ! -d "$BKP_FOLDER" ]]
    then
        echo "Sorry mate, you don't have any backup (directory $DIRECTORY does not exist)"
        echo "Could not rollback you config to last backup"
        exit 1
    fi

    cp $BKP_FOLDER/.xinitrc        ~/
    cp $BKP_FOLDER/.xprofile       ~/
    cp $BKP_FOLDER/.Xresources     ~/
    cp $BKP_FOLDER/.bashrc         ~/

    
    cp -r  $BKP_FOLDER/.config/alacritty    ~/.config/
    cp -r  $BKP_FOLDER/.config/bspwm        ~/.config/
    cp -r  $BKP_FOLDER/.config/dunst        ~/.config/
    cp -r  $BKP_FOLDER/.config/gtk-3.0      ~/.config/
    cp -r  $BKP_FOLDER/.config/polybar      ~/.config/
    cp -r  $BKP_FOLDER/.config/picom        ~/.config/
    cp -r  $BKP_FOLDER/.config/rofi         ~/.config/
    cp -r  $BKP_FOLDER/.config/sxhkd        ~/.config/
    echo "Last backup has been re-deployed!"
}



# Configure system to autologin user on tty1 and lauch X server. (no display manager required)
function setupAutologinX {

    if [[ ! -f "/etc/systemd/system/getty@tty1.service.d/autologin.conf" ]]
    then
        echo "Configurating system for autologin user on tty1 and automatically start X..."
        echo "Uninstalling lightdm display manager, won't be using it anymore"
        sudo systemctl stop lightdm
        sudo pacman -Rcns lightdm --noconfirm 

        echo "Creating  drop-in file to override getty@tty1 service conf.."
        # Create a drop-in file to override systemd  'getty@tty1.service' unit 
        # so user automatically login in tty1 at boot
        sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/

        sudo bash -c "cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf <<\EOF
        [Service]
        ExecStart=
        ExecStart=-/sbin/agetty -o '-p -f -- \\\\u' --noclear --autologin $USER %I \$TERM
        Type=simple
EOF"

        # Automatically launch 'startx' cmd if entering tty1 
        echo '[[ "$(tty)" = "/dev/tty1"  ]] && startx' >  ~/.bash_profile
        echo "Done configuring autologin and X startup"
    fi
}



##############################################################################################################
#================================================ MAIN ======================================================#
##############################################################################################################


[[ $1 == "-r" ]] && { rollbackBackup; exit 0; }
[[ $1 == "-b" ]] && { makeBackup; exit 0; }

# Shortland just for fun ;)
#[[ -f "~/.config/.green" ]] && { makeBackup; updateConf; exit 0; } || { firstInstall ; setupAutologinX; updateConf; }

if [[ -f "~/.config/.green" ]]  # If .green flag file exists, update. If Not, install and update.
then
    makeBackup
    updateConf
    exit 0
else
    firstInstall
    updateConf
    setupAutologinX
    echo "Installation is finished, you may reboot now!"
fi


exit 0