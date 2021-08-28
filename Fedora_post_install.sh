#!/bin/bash

echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf

gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag false
gsettings set org.gnome.desktop.peripherals.mouse accel-profile adaptive
gsettings set org.gnome.desktop.interface show-battery-percentage true

echo "Upgrading system"
sudo dnf -y upgrade

echo "Enable RPM"
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "Installing AppStream metadata"
#yes | sudo dnf groupupdate core

echo "Installing flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing multimedia"
#yes | sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
#yes | sudo dnf groupupdate sound-and-video

echo "Installing battery power soft"
sudo dnf -y install tlp tlp-rdw
sudo systemctl enable tlp

echo "Installing other soft"
flatpak -y install celluloid telegram spotify org.gnome.Extensions
sudo dnf -y install vlc vim-enhanced zsh levien-inconsolata-fonts adobe-source-code-pro-fonts mozilla-fira-mono-fonts google-droid-sans-mono-fonts dejavu-sans-mono-fonts

# Vim setup
alias vi='vim'
# Vim Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.v

# zsh setup
No | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/ZSH_THEME=\".*\"/ZSH_THEME=\"gentoo\"/g' ~/.zshrc
sed -i 's/plugins\=(.*)/plugins\=(git\ zsh-autosuggestions\ zsh-completions\ zsh-syntax-highlighting)/g' ~/.zshrc

mkdir ~/.themes ~/.icons
cd ~/.themes && git clone https://github.com/EliverLara/Nordic.git && gsettings set org.gnome.desktop.interface gtk-theme "Nordic" && gsettings set org.gnome.desktop.wm.preferences theme "Nordic" && gsettings set org.gnome.shell.extensions.user-theme name "Nordic"
cd ~/Downloads && git clone https://github.com/vinceliuice/Qogir-icon-theme.git
cd ~/Downloads/Qogir-icon-theme && ./install.sh -d "/home/$(whoami)/.icons"
gsettings set org.gnome.desktop.interface icon-theme Qogir-dark

echo "Firefox gnome theme"
cd ~/Downloads && git clone https://github.com/rafaelmardojai/firefox-gnome-theme && cd firefox-gnome-theme
./scripts/auto-install.sh

sudo dnf -y install gnome-shell-extension-pop-shell && enable pop-shell@system76.com

sudo chsh -s $(which zsh) && reboot

# Графическое управление аудио устройствами (выход, вход) для Sway
sudo dnf install pavucontrol   

