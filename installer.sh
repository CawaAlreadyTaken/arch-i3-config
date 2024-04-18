#!/bin/bash

# Check if we are in ~/repos/arch-i3-config
if [ ! -d ~/repos/arch-i3-config ]; then
    echo "[!] Please run this script from ~/repos/arch-i3-config/"
    exit 1
fi

echo "[*] Adding keyring..."
sudo pacman -Sy archlinux-keyring --noconfirm

echo "[*] Updating system..."
sudo pacman -Syyu --noconfirm

echo "[*] Installing firefox..."
sudo pacman -S firefox --noconfirm

echo "[*] Installing yay, aur..."
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd ~/repos/arch-i3-config

echo "[*] Setting natural scrolling..." 
# Add another Option to 30-touchpad.conf: Option "NaturalScrolling" "true"
sudo sed -i 's/Driver "libinput"/Driver "libinput"\n\tOption "NaturalScrolling" "true"/' /etc/X11/xorg.conf.d/30-touchpad.conf

echo "[*] Installing and setting up gestures..."
sudo gpasswd -a $USER input
sudo pacman -S xdotool wmctrl --noconfirm
git clone https://github.com/bulletmark/libinput-gestures.git ~/repos/
cd ~/repos/libinput-gestures
sudo ./libinput-gestures-setup install
cd ~/repos/arch-i3-config
cp libinput-gestures.conf ~/.config/libinput-gestures.conf

echo "[*] Enabling libinput-gestures and starting it..."
libinput-gestures-setup stop desktop autostart start

echo "[*] Adding other fonts..."
sudo cp -r fonts/* /usr/share/fonts/

echo "[*] Installing other packages..."
yay -S --needed acpi neovim papirus-icon-theme coreshot zathura zathura-pdf-mupdf

echo "[*] Setting up zsh..."
yay -S --noconfirm zsh-theme-powerlevel10k-git
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
exec zsh
chsh -s /bin/zsh
sudo chsh -s /bin/zsh
fc-cache -fv
cp zshrc ~/.zshrc

echo "[*] Setting up nvim..."
yay -S nodejs npm zig
rm -rf ~/.config/nvim
cp -r ./nvim ~/.config/
nvim --headless +q

echo "[*] Setting up polybar..."
rm -rf ~/.config/polybar
cp -r ./polybar ~/.config/

echo "[*] Setting up gtk..."
mkdir -p "$HOME"/.config/gtk-4.0
git clone https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme ~/repos/Rose-Pine-GTK-Theme
sudo cp -r ~/repos/Rose-Pine-GTK-Theme/themes/RosePine-Main-BL  /usr/share/themes/RosePine-Main
sudo cp -r ~/repos/Rose-Pine-GTK-Theme/themes/RosePine-Main-BL/gtk-4.0/* "$HOME"/.config/gtk-4.0

echo "[*] Setting up sddm..."
yay -S --needed qt6-5compat qt6-declarative qt6-svg sddm
sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

sudo systemctl disable lightdm
sudo pacman -Rs lightdm-gtk-greeter
sudo pacman -Rs lightdm

sudo systemctl enable sddm

echo "[*] Setting up wallpaper..."
sudo cp ./bg_stars.jpg /usr/share/backgrounds/i3/

echo "[*] Installing and setting up dunst for notifications..."
yay -S dunst libnotify
cp -r dunst/ ~/.config/

echo "[*] Finally, setting up i3 config..."
cp ./config ~/.config/i3/

echo "[?] Now reboot, then mod+d, 'customize look and feel', select RosePine."
echo "[*] Enjoy!"
