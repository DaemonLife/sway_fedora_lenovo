# Config for Sway (and GNOME): Fedora 34, Lenovo ideapad 5 15are05

My configs:
- .config/sway/
- .config/waybar/
- .vimrc
- .zshrc

# Installing
## First steps
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
sudo dnf -y install tlp tlp-rdw
sudo systemctl enable tlp # run this
~~~
Installing other soft and fonts. Love it ^.^
~~~
# fonts
sudo dnf -y install levien-inconsolata-fonts adobe-source-code-pro-fonts mozilla-fira-mono-fonts google-droid-sans-mono-fonts dejavu-sans-mono-fonts
# soft
sudo dnf -y install vlc neovim zsh
flatpak -y install celluloid telegram spotify org.gnome.Extensions
~~~
Nordic themes! Qogir icons! And, sorry, I lost my Vimix-dark cursor for you
~~~
mkdir ~/.themes ~/.icons
cd ~/.themes && git clone https://github.com/EliverLara/Nordic.git && gsettings set org.gnome.desktop.interface gtk-theme "Nordic" && gsettings set org.gnome.desktop.wm.preferences theme "Nordic" && gsettings set org.gnome.shell.extensions.user-theme name "Nordic"
cd ~/Downloads && git clone https://github.com/vinceliuice/Qogir-icon-theme.git
cd ~/Downloads/Qogir-icon-theme && ./install.sh -d "/home/$(whoami)/.icons"
gsettings set org.gnome.desktop.interface icon-theme Qogir-dark
~~~
Time to zzZsh setup
~~~
No | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/ZSH_THEME=\".*\"/ZSH_THEME=\"gentoo\"/g' ~/.zshrc
sed -i 's/plugins\=(.*)/plugins\=(git\ zsh-autosuggestions\ zsh-completions\ zsh-syntax-highlighting)/g' ~/.zshrc
~~~
Changing default bash shell to cool zsh shell and reboot system of course 
~~~
sudo chsh -s $(which zsh) && reboot
~~~
## Second steps... To Sway!
Your audio controllers - gui and not gui
~~~
sudo dnf install pavucontrol pactl
~~~
Add a apt-x like codec support for bluetooth music. Open this file
```
sudo nvim /usr/share/pipewire/pipewire.conf
```
And add this to end of the file:
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
sudo dnf install nmtui
nmcli dev wifi rescan && nmtui # search for mentality and run a simple gui
~~~
