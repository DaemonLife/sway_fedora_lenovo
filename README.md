# GNOME and SWAY setup for Fedora 34

After install add all configs from this repository to your folders. Btw I use Lenovo Ideapad 5 15are05.

# GNOME Post installing
Let's make the dnf fast like lynx
~~~
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
~~~
Adequate touchpad, mouse and show battery status for GNOME DE for eyes!
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
Installing battery power soft to control your battery. Useful. Save power, get status, makes lemonade, etc.
~~~
sudo dnf -y install tlp tlp-rdw smartmontools
sudo systemctl enable tlp # run this
# run sudo tlp-stat and check possible recommendations for installing
sudo tlp-stat
~~~
Installing other soft and fonts. Love it ^.^
~~~
# fonts
sudo dnf -y install levien-inconsolata-fonts adobe-source-code-pro-fonts mozilla-fira-mono-fonts google-droid-sans-mono-fonts dejavu-sans-mono-fonts
# soft
sudo dnf -y install vlc neovim zsh
flatpak -y install celluloid telegram spotify org.gnome.Extensions
~~~
Arc theme, qogir icons and cursor.
~~~
mkdir ~/.themes ~/.icons
sudo dnf install arc-theme
cd ~/Downloads && git clone https://github.com/vinceliuice/Qogir-icon-theme.git
cd ~/Downloads/Qogir-icon-theme && ./install.sh -d "/home/$(whoami)/.icons"
gsettings set org.gnome.desktop.interface gtk-theme Arc-Dark-solid
gsettings set org.gnome.desktop.interface icon-theme Qogir-dark
gsettings set org.gnome.desktop.interface cursor-theme Qogir-dark
~~~
Time to zzZsh setup
~~~
No | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/ZSH_THEME=\".*\"/ZSH_THEME=\"gentoo\"/g' ~/.zshrc
sed -i 's/plugins\=(.*)/plugins\=(git\ zsh-autosuggestions\ zsh-completions\ zsh-syntax-highlighting)/g' ~/.zshrc
echo 'alias vi="nvim"' >> ~/.zshrc
echo 'alias rg="ranger"' >> ~/.zshrc
chsh -s $(which zsh)
sudo chsh -s $(which zsh)
~~~
# To Sway!
Installing Sway

- wofi: demenu analog, app search.
- waybar: better bar.
- kitty: IMHO, best terminal.
- mako: notifications daemon.
- swayidle, swaylock: it's your locksreen. 
- pulseaudio-utils, playerctl: for pactl and playctl commands to change volume, etc.
- pavucontrol: simple audio control with gui.
- NetworkManager-tui: for command nmtui, simple wifi control with gui.
- udiskie: mounting devices.
- wl-clipboard, clipman: proggrams for clipboard.
- light: control monitor brightness.
~~~
sudo dnf install sway wofi waybar mako kitty swayidle swaylock pulseaudio-utils playerctl pavucontrol NetworkManager-tui udiskie wl-clipboard clipman light
~~~
Reboot after all and remember to login to sway in GDM.
~~~
reboot
~~~
Add a apt-x like codec support for bluetooth music. Open this file
```
sudo nvim /usr/share/pipewire/pipewire.conf
```
And add this TO END OF THIS FILE:
~~~
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
~~~
How to use bluetooth. How?
~~~
bluetooth on
bluetoothctl scan
bluetoothctl pair [addres]
bluetoothctl trust [addres]

# And nex time connect like this:
bluetoothctl connect [addres]

# The device may not want to connect the first time. 
# Repeat the steps. In different order... 
# ... Well, good luck!
~~~
Now are you connected? Okey. Change sound channel at headphones.
~~~
pactl list sinks # devices list
# Are you sure you are connected? :)
# Ok next
pactl set-default-sink [number] # set it default
~~~
Now run simple gui program pavucontrol and configurate your headphones to best codec (SBC-XQ maybe).
~~~
pavucontrol
~~~
How to WiFi control? The easy way:
~~~
nmcli dev wifi rescan && nmtui # search for mentality and run a simple gui
~~~
For USB and SD automount:
~~~
# There is added "exec udiskie -a -n -t" line in sway config for autostart mounting at startapp Sway.   
~~~

## Now copy all configs. 

If you copied nvim configs follow this steps:
~~~
# Installing Vim-Plug plugin.
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
~~~
Run this command in nvim.
~~~
:PlugInstall
~~~

## Other apps settings

Spotify color theme

https://github.com/khanhas/spicetify-cli

https://github.com/morpheusthewhite/spicetify-themes - use Sleek, edit color file for Nord theme to be at the top

Firefox

https://addons.mozilla.org/en-US/firefox/addon/firefox-nord-dark/?utm_content=addons-manager-reviews-link&utm_medium=firefox-browser&utm_source=firefox-browser


