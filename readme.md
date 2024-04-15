# Steps

I write the steps I followed to obtain my setup.

Starting from archlinux-gui-i3-2022.07-x86_64.iso. Link is https://sourceforge.net/projects/arch-linux-gui/files/archlinux-gui-i3-2022.07-x86_64.iso/download .

### Add keyring
```sh
sudo pacman -Sy archlinux-keyring
```


### Update the system
```sh
sudo pacman -Syyu
```

### Install firefox and nemo
```sh
sudo pacman -Sy firefox nemo
```

### Install yay, aur
```sh
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/.srcs/yay
cd ~/.srcs/yay
makepkg -si
```

### Set natural scrolling
```sh
sudo vim /etc/X11/xorg.conf.d/30-touchpad.conf
```
And add another Option: `Option "NaturalScrolling" "true"`

### Install and setup gestures
```sh
sudo gpasswd -a $USER input
sudo pacman -S wmctrl xdotool
git clone https://github.com/bulletmark/libinput-gestures.git ~/repos/
cd ~/repos/libinput-gestures
sudo ./libinput-gestures-setup install
```

Edit the libinput-gestures configuration as wanted.  
The file is `/etc/libinput-gestures.conf`. Copy it in local:

```sh
cp /etc/libinput-gestures.conf ~/.config/libinput-gestures.conf
vim ~/.config/libinput-gestures.conf
```

My used libinput-gestures config is provided in this repo.

Now enable the service and start it (may need to reload i3):
```sh
libinput-gestures-setup stop desktop autostart start
echo "exec_always libinput-gestures-setup start" >> ~/.config/i3/config
```

If you need to check the status:
```sh
libinput-gestures-setup status
```

### Install vscode
```sh
sudo pacman -S code
echo 'for_window [class="code"] move to workspace $ws4' >> ~/.config/i3/config
echo 'bindsym $mod+c workspace 4; exec code' >> ~/.config/i3/config
```

### Add other fonts
```sh
sudo cp -r ./fonts/* /usr/share/fonts
```

### Install additional dependencies
```sh
yay -S acpi neovim papirus-icon-theme coreshot zathura zathura-pdf-mupdf
```

### Setup zsh and powerlevel10k

(assuming zsh is already installed)  

Remember that if we want to setup zsh again, we can just remove the `~/.zshrc` file and start `zsh`

```sh
yay -S --noconfirm zsh-theme-powerlevel10k-git
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
exec zsh
chsh -s /bin/zsh
sudo chsh -s /bin/zsh
fc-cache -fv
```

Configuration should start. Otherwise, type `p10k configure`. Otherwise, `cp ./.zshrc ~/.zshrc`

### Setup nvim
```sh
cp -r ./nvim ~/.config/
nvim +PackerSync
```

### Setup gtk
```sh
mkdir -p "$HOME"/.config/gtk-4.0
git clone https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme ~/repos/Rose-Pine-GTK-Theme
sudo cp -r ~/repos/Rose-Pine-GTK-Theme/themes/RosePine-Main-BL  /usr/share/themes/RosePine-Main
sudo cp -r ~/repos/Rose-Pine-GTK-Theme/themes/RosePine-Main-BL/gtk-4.0/* "$HOME"/.config/gtk-4.0
```

Then, mod+d, "Customize Look and Feel", and select Rose-Pine.

### Setup sddm
```sh
yay -S --needed qt5-graphicaleffects qt5-quickcontrols2 qt5-svg sddm
yay -S --needed qt6-5compat qt6-declarative qt6-svg sddm
sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
```

Now remove the older lightdm:
```sh
sudo systemctl disable lightdm
sudo pacman -Rs lightdm-gtk-greeter
sudo pacman -Rs lightdm
```

### Setup lock screen
Ensure i3lock-color is installed.
```sh
echo "bindsym $mod+x exec i3lock --blur 9" >> ~/.config/i3/config
```

### Setup background
```sh
sudo cp ./bg_stars.jpg /usr/share/backgrounds/i3/bg_stars.jpg
```

### Setup dunst for notifications
```sh
yay -S dunst libnotify
cp -r ./dunst ~/.config/dunst
```
