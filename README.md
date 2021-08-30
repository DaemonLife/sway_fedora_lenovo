# Config for Sway (and GNOME): Fedora 34, Lenovo ideapad 5 15are05

Read the Fedora_post_install.sh file, there are some useful commands and steps to improve our system.

My configs:
- .config/sway/
- .config/waybar/
- .vimrc
- .zshrc

# Installing
## First steps
Let's make the dnf fast
~~~
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
~~~
Adequate touchpad, mouse and show battery status for GNOME DE
~~~
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag false
gsettings set org.gnome.desktop.peripherals.mouse accel-profile adaptive
gsettings set org.gnome.desktop.interface show-battery-percentage true
~~~
Enable RPM and Flatpak
~~~
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
~~~
Update system. Press Alt+Ctrl+F3 to enter safe terminal mode. Alt+Ctrl+F2 to get back after all. 
~~~
sudo dnf -y upgrade
~~~
Installing battery power soft to control your battare. Useful. Save power, get status etc.
~~~
sudo dnf -y install tlp tlp-rdw
sudo systemctl enable tlp
~~~
Installing other soft and fonts. Love it ^.^
~~~
# fonts
sudo dnf -y install levien-inconsolata-fonts adobe-source-code-pro-fonts mozilla-fira-mono-fonts google-droid-sans-mono-fonts dejavu-sans-mono-fonts
# soft
sudo dnf -y install vlc neovim zsh
flatpak -y install celluloid telegram spotify org.gnome.Extensions
~~~
Nordic themes! Qogir icons! And, sorry, I lost my Vimix-dark cursor
~~~
mkdir ~/.themes ~/.icons
cd ~/.themes && git clone https://github.com/EliverLara/Nordic.git && gsettings set org.gnome.desktop.interface gtk-theme "Nordic" && gsettings set org.gnome.desktop.wm.preferences theme "Nordic" && gsettings set org.gnome.shell.extensions.user-theme name "Nordic"
cd ~/Downloads && git clone https://github.com/vinceliuice/Qogir-icon-theme.git
cd ~/Downloads/Qogir-icon-theme && ./install.sh -d "/home/$(whoami)/.icons"
gsettings set org.gnome.desktop.interface icon-theme Qogir-dark
~~~
Time to Zsh setup
~~~
No | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/ZSH_THEME=\".*\"/ZSH_THEME=\"gentoo\"/g' ~/.zshrc
sed -i 's/plugins\=(.*)/plugins\=(git\ zsh-autosuggestions\ zsh-completions\ zsh-syntax-highlighting)/g' ~/.zshrc
~~~
Changing default bash shell to cool zsh shell and reboot system
~~~
sudo chsh -s $(which zsh) && reboot
~~~
## Second steps... To Sway!
Your audio controllers - gui and not
~~~
sudo dnf install pavucontrol pactl
~~~
Add a apt-x like codec support for bluetooth music. Open this file
```
sudo nvim /usr/share/pipewire/pipewire.conf
```
