#..........!/bin/bash

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

# sudo dnf -y install gnome-shell-extension-pop-shell && enable pop-shell@system76.com

# Default text editor
sudo nvim /etc/profile.d/nano.sh
# add:
# export VISUAL="nvim"
# export EDITOR="nvim"

sudo chsh -s $(which zsh) && reboot

#
# For Sway
#

# Графическое управление аудио устройствами (выход, вход)
sudo dnf install pavucontrol pactl

# go to Pulseaudio (enable RPM) https://russianfedora.github.io/FAQ/hardware.html#index-66 
# sudo dnf swap pipewire-pulseaudio pulseaudio --allowerasing
# sudo systemctl reboot
# codecs for bluetooth
# sudo dnf swap pulseaudio-module-bluetooth pulseaudio-module-bluetooth-freeworld --allowerasing
# pulseaudio -k; pulseaudio -D # restart pulse
# Переключение кодеков в pavucontrol (Иначе же - конфигурационные файлы pulse в ~ или / и alsa в /)


# For Pipewire codecs (SBC-XQ is best)
sudo vi /usr/share/pipewire/pipewire.conf
# Add this:
"""

# Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
#sound.enable = false;

# rtkit is optional but recommended
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;

  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;
  
  media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [ { "device.name" = "~bluez_card.*"; } ];
      actions = {
        "update-props" = {
          "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          # mSBC is not expected to work on all headset + adapter combinations.
          "bluez5.msbc-support" = true;
          # SBC-XQ is not expected to work on all headset + adapter combinations.
          "bluez5.sbc-xq-support" = true;
        };
      };
    }
    {
      matches = [
        # Matches all sources
        { "node.name" = "~bluez_input.*"; }
        # Matches all outputs
        { "node.name" = "~bluez_output.*"; }
      ];
      actions = {
        "node.pause-on-idle" = false;
      };
    }
  ];
  
};

"""

# работа с bluetooth
bluetooth on
bluetoothctl scan on # скан устройств
bluetoothctl pair [addres]
bluetoothctl trust [addres] # доверять устройству, обязательно
bluetoothctl connect [addres] # повторное подключение (возможно и первое)

# Переключение каналов звука на выход
pactl list sinks # список устройств (автоматически предложит установить пакет для работы pactl)
pactl set-default-sink [номер] # дефолтное устройство выхода 

# Change codecs in pavucontrol gui
pavucontrol

#
# Wifi
#
sudo dnf install nmtui
# connection
nmcli dev wifi rescan
nmtui # gui


