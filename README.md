# Config for Sway (and GNOME), Fedora 34, Lenovo ideapad 5 15are05

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
