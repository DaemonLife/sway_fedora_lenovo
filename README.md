# GNOME and SWAY setup for Fedora 34

After install add all config from this repository to your folders. Btw I use Lenovo Ideapad 5 15are05.

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
Changing default bash shell to cool zsh shell.
~~~
sudo chsh -s $(which zsh)
~~~
# To Sway!
Installing Sway, wofi (demenu analog, app search), swaylock (lockscreen), kitty (IMHO, best terminal). Reboot after all.
~~~
sudo dnf install sway swaylock wofi kitty
reboot
~~~
Your audio controllers - gui and not gui. And wofi program menu
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
For USB and SD automount:
~~~
sudo dnf install udiskie
# There is added "exec udiskie -a -n -t" line in sway config for autostart mounting at startapp Sway.   
~~~

## Firefox Nord theme
![screen-1630671932](https://user-images.githubusercontent.com/52444457/132004845-03f1a36d-9d30-4f30-999f-b432be4774d7.png)

Install Firefox Nord Polar theme: https://addons.mozilla.org/en-GB/firefox/addon/nord-polar-night-theme/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search

Read this rep: https://github.com/ranmaru22/firefox-vertical-tabs

My addon config:
```
/* Overwrite some colours */
:root {
    --tab-separator: transparent;
    --tab-selected-line: transparent;
    --tablist-separator: #5b6278;
}

@media (prefers-color-scheme: dark) {
    :root {
        --background: #333333;
        --icons: rgb(251,251,254);
        --tab-separator: transparent;
        --tab-active-background: rgb(66,65,77);
        --tab-active-text: rgb(251,251,254);
        --tab-text: #fbfbfe;
        --toolbar-background: #383c4a;
        --toolbar-text: rgb(251, 251, 254);
        --input-background: rgb(28,27,34);
        --input-border: transparent;
        --input-background-focus: rgb(66,65,77);
        --input-selected-text: rgb(251,251,254);
        --input-text: rgb(251,251,254);
        --input-text-focus: rgb(251,251,254);
        --identity-color-toolbar: rgb(251,251,254);
        --tablist-separator: #333333;
    }
}


body {
  --icons: white;
  --toolbar-text: white;
  --input-text: white;
  --input-text-focus: white;
  --tab-text: white;
  --background: #3b4252;
  --tab-active-background: #5b6278;

}

/* Move topmenu to bottom */
#topmenu {
    order: 2;
    background: transparent;
    border: none;
}

#newtab {
    margin-left: 6px;
}

#settings {
    margin-right: 2px;
}

/* Hide filterbox */
#filterbox-icon,
#filterbox-input {
    display: none;
}

/* Right-align settings icon */
#settings {
    margin-left: auto;
}

#tablist-wrapper {
    height: auto;
    margin: 0 6px;
}

#tablist-wrapper::after {
    content: "";
    max-width: 34px;
    margin: 2px 0;
    border: 1px solid var(--tablist-separator);
    transition: all 0.2s ease;
    transition-delay: 200ms;
}

#tablist-wrapper .tab-title-wrapper {
    visibility: hidden;
    transition: all 0.2s ease;
    transition-delay: 200ms;
}

#newtab {
    flex-grow: 1;
    margin-right: 4px;
    margin-left: 3px;
    padding-left: 9px;
}


.tab,
.tab.active {
    max-width: 36px;
    border-radius: 0px;
    margin: 0px 0px 2px 1px;
    transition: max-width 12s ease;
}

#pinnedtablist:not(.compact) .tab,
#tablist .tab {
    padding: 0;
}

#pinnedtablist:not(.compact) .tab {
    padding-left: 6px;
}

/* Show more when hovering over the sidebar */
body:hover #tablist-wrapper .tab-title-wrapper {
    visibility: visible;
}

body #newtab::after {
    content: "New tab";
    visibility: hidden;
    margin-left: 10px;
    transition: all 0.2s ease;
    transition-delay: 200ms;
}

body:hover #newtab::after {
    visibility: visible;
}

body:hover #tablist-wrapper::after,
body:hover .tab {
    max-width: 100%;
}

body:hover #pinnedtablist:not(.compact) .tab {
    padding-left: 0;
}

/* Move close button to left side */
/*.tab-close {
    left: 0;
    margin-left: 3px;
}*/

/* Fix title gradient */
/*#tablist .tab:hover > .tab-title-wrapper {
    mask-image: linear-gradient(to left, transparent 0, black 2em);
}*/

/* Move tab text to right when hovering to accomodate for the close button */
/*#tablist .tab:hover > .tab-title-wrapper {
    margin-left: 28px;
    transition: all 0.2s ease;
}*/

/* Move favicon to right when hovering to accomodate for the close button */
/*#tablist .tab:hover > .tab-meta-image {
    padding-left: 25px;
    transition: all 0.2s ease;
}*/


/*** Move container indicators to left ***/
#tablist-wrapper {
    margin-left: 0px;
    padding-left: 6px;
}
#tablist {
    margin-left: -6px;
    padding-left: 6px;
}
.tab {
    overflow: visible;
}
#tablist .tab[data-identity-color] .tab-context {
    box-shadow: none !important;
}
#tablist .tab[data-identity-color] .tab-context::before {
    content: "";
    position: absolute;
    top: 6px;
    left: -6px;
    bottom: 6px;
    width: 3px;
    border-radius: 0 5px 5px 0;
    background: var(--identity-color);
    transition: inset .1s;
}
#tablist .tab.active[data-identity-color] .tab-context::before {
    top: 1px;
    bottom: 1px;
}
```
