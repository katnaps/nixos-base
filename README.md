# Installation Guide

Take a look at installation section in the official NixOS Manual guide page below.
## [Official NixOS Manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual)

## Below is quick summary of installing NixOS these files
You will need to boot into usb boot drive containing NixOS installation iso image.

This is a starting base for NixOS installation configuration with flake and home-manager to manage the packages.

Be sure to be connected to the internet before proceeding.
You run this command to see if you have establish a internet connection.
```
# ping -c 3 nixor.org
```
### login sudo -i so you can format the disk drive 
Please take a look at the [Official NixOS Manual - Partitioning & Format](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-partitioning) for more details on how to partition a drive
```
# sudo -i
```

once the storage drives have been formatted and partition accordingly generate configuration.nix and hardware-configuration.nix file
run this command to generate config files
```
# nixos-generate-config --root /mnt
```

change to this directory
```
# cd /mnt/etc/nixos/
```
proceed to put the files in this directory

```
/mnt/etc/nixos/
```

## Download the repo with either git clone or curl
use git method, since curl you have to unzip the .zip file

### For git (Recommended)
```
# git clone https://github.com/katnaps/nixos-base.git
```

### For curl
```
# curl -L https://github.com/katnaps/nixos-base/archive/refs/heads/main.zip -o repo.zip
```
unzip the repo.zip file in the current directory which should be
```
/mnt/etc/nixos/
```
run the unzip command
```
# unzip repo.zip
```


## Install on NixOS
by running this command below it should use the flake.nix in the directory to start installation process
```
# nixos-install --flake /mnt/etc/nixos#hostname
```

## After installation completion
You will be prompt to set a password for root user
```
setting root password...
New password: ***
Retype new password: ***
```

## Set password for user account declared from your configuration.nix, flake.nix and home.nix
If you plan to login into this user, set a password before rebooting, e.g. for the katnaps user:
```
# nixos-enter --root /mnt -c 'passwd katnaps'
```
If everything went well
```
# reboot
```
### Post-reboot
After reboot you can add other packages in the configuration.nix or home.nix file and customise to your liking!
