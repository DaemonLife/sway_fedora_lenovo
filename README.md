# Config for Sway, Fedora 34, Lenovo ideapad 5 15are05


# ...

# Installation of Arch Linux with Wayland and Sway on fully encrypted disk with LVM2 enabled

I created this repository with README because I was dissatisfied with Xorg. I used Lenovo Carbon X1 Gen 6 with [Arch Linux + i3 + tmux](https://github.com/gen1us2k/linuxdotfiles) for my development environment. Last year I bought Lenovo Thinkpad T14 Gen 1 and tried to use [Ubuntu with Regolith Linux](https://github.com/gen1us2k/regolith-dotfiles). I had a few problems with my previous setup:

1. I had strange behavior of video driver for Intel UHD video card on my laptop. My interface and browser were freezing and render too slow.
2. I can't use different keyboard layouts per one window.
3. I had problems with the Grammarly extension for Chrome. When I was typing the text in the input field, it was freezing.
4. A lot of web pages were rendered too slow.

After a while, I tried to fix all those problems and decided to move from Ubuntu to Arch Linux. A few days before my decision, I discovered that my colleague moved to clean Arch Linux with Wayland and sway setup, and I decided to give it a try.

Below you can find an instruction how to setup Arch Linux with Wayland on encrypted LVM partitions

## Useful links
This guide is based on 
1. [Minimal instructions for installing arch linux on an UEFI system with full system encryption using dm-crypt and luks
](https://gist.github.com/mattiaslundberg/8620837)
2. [Full Wayland Setup on Arch Linux](https://www.fosskers.ca/en/blog/wayland)


## Preparing installation image

1. Download the archiso image from https://www.archlinux.org/
2. Copy to a usb-drive

```
dd if=archlinux.img of=/dev/sdX bs=16M && sync # on linux
```

Boot from the usb. If the usb fails to boot, make sure that secure boot is disabled in the BIOS configuration.

## Wifi connection

```
iwctl
[iwd]# device list
[iwd]# station device scan
[iwd]# station device get-networks
[iwd]# station device connect SSID
```

## Create partitions

```
cgdisk /dev/sdX
1 100MB EFI partition # Hex code ef00
2 250MB Boot partition # Hex code 8300
3 100% size partiton # (to be encrypted) Hex code 8300
```
```
mkfs.vfat -F32 /dev/sdX1
mkfs.ext2 /dev/sdX2
```

## Setup the encryption of the system

cryptsetup -c aes-xts-plain64 -y --use-random luksFormat /dev/sdX3
cryptsetup luksOpen /dev/sdX3 luks

## Create encrypted partitions
## This creates one partions for root, modify if /home or other partitions should be on separate partitions

```
pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate --size 8G vg0 --name swap
lvcreate -l +100%FREE vg0 --name root
```

## Create filesystems on encrypted partitions

```
mkfs.ext4 /dev/mapper/vg0-root
mkswap /dev/mapper/vg0-swap
```

## Mount the new system 

```
mount /dev/mapper/vg0-root /mnt # /mnt is the installed system
swapon /dev/mapper/vg0-swap # Not needed but a good thing to test
mkdir /mnt/boot
mount /dev/sdX2 /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sdX1 /mnt/boot/efi
```

## Install the system also includes stuff needed for starting wifi when first booting into the newly installed system

```
pacstrap /mnt base base-devel grub-efi-x86_64 vim git efibootmgr dialog wpa_supplicant iwd dhclient lvm2 linux linux-firmware 
```

NB: iwd and dhclient are required to connect to internet after you complete basic installation

## 'install' fstab

```
genfstab -pU /mnt >> /mnt/etc/fstab
# Make /tmp a ramdisk (add the following line to /mnt/etc/fstab)
tmpfs	/tmp	tmpfs	defaults,noatime,mode=1777	0	0
# Change relatime on all non-boot partitions to noatime (reduces wear if using an SSD)
```

## Enter the new system

```
arch-chroot /mnt /bin/bash
```

## Setup system clock

```
ln -s /usr/share/zoneinfo/Asia/Bishkek /etc/localtime
hwclock --systohc --utc
```

## Set the hostname

```
echo MYHOSTNAME > /etc/hostname
```

## Update locale
```
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo LANGUAGE=en_US >> /etc/locale.conf
echo LC_ALL=C >> /etc/locale.conf
```
## Set password for root
```
passwd

# Add real user remove -s flag if you don't whish to use zsh
# useradd -m -g users -G wheel -s /bin/zsh MYUSERNAME
# passwd MYUSERNAME
```

## Configure mkinitcpio with modules needed for the initrd image

```
vim /etc/mkinitcpio.conf
# Add 'ext4' to MODULES
# Add 'encrypt' and 'lvm2' to HOOKS before filesystems

# Regenerate initrd image
mkinitcpio -p linux
```

## Setup grub

```
grub-install
In /etc/default/grub edit the line GRUB_CMDLINE_LINUX to GRUB_CMDLINE_LINUX="cryptdevice=/dev/sdX3:luks:allow-discards" then run:
grub-mkconfig -o /boot/grub/grub.cfg

# Exit new system and go into the cd shell
exit
```

## Unmount all partitions
umount -R /mnt
swapoff -a

## Reboot into the new system, don't forget to remove the cd/usb

## Installation of wayland and sway

```
sudo pacman -S \
  sway kitty waybar wofi \
  xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland gdm
```

## Installation of additional software

``` 
pacman -S man python-pip pulseaudio-alsa pamixer pavolume wget atop mpd alsa-utils pavucontrol network-manager-applet ttf-emojione-color ttf-dejavu ttf-liberation noto-fonts ttf-joypixels python-gobject geoclue swayidle ttf-jetbrains-mono openssh slurp wl-clipboard grim wl-clipboard NetworkManager tmux nautilus mako
```

## Installation of yay

```
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Installation of messengers and helpers

```
yay -S slack-desktop
yay -S skypeforlinux-preview-bin
yay -S obsidian
yay -S redshift-wayland-git
yay -S swaylock-effects-git
yay -S brightnessctl
yay -S nerd-fonts-ubuntu-mono
```

## Starting and enabling systemd services

```

sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl enable gdm.service
sudo systemctl enable iwd
```

## Copy dotfiles and enjoy

## Keyboard layout per window

```
yay -S swaykbdd
```

Add `exec --no-startup-id swaykbdd` to your sway config file
