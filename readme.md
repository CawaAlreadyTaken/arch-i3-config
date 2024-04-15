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

### Install firefox
```sh
sudo pacman -Sy firefox
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
yay -S acpi neovim
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
