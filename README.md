# Installation Guide
## Stable Version -- NixOS 26.05 (Yarara) x86_64

### Features:
Unstable packages are able to be installed

For example in configuration.nix
```
environment.systemPackages = with pkgs; [
    unstable.fastfetch
];
```

For home.nix installation
```
home.packages = with pkgs; [
    unstable.fastfetch
];
```


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

### Partition structure
```
├── nvme0nX
│   ├── nvme0nXp1 - [ boot ]
│   └── nvme0nXp2 - nixos [ root ]
└── sdX
    └── sdX1 - [ data ]
```
### Formatting partition
Formatting the root partition and labeling it nixos
For initialising Ext4 partitions: mkfs.ext4. It is recommended that you assign a unique symbolic label to the file system using the option -L label, since this makes the file system configuration independent from device changes. For example:
```
# mkfs.ext4 -L nixos /dev/nvme0nXp2
```
Same goes for data partition and labeling it data using the option -L label
```
# mkfs.ext4 -L data /dev/sdX1
```
### UEFI systems
For creating boot partitions: mkfs.fat. Again it’s recommended to assign a label to the boot partition: -n label. For example:
```
# mkfs.fat -F 32 -n boot /dev/nvme0nXp1
```

### Mount partition
### Be sure to ALWAYS mount root partition FIRST!
```
# mount /dev/disk/by-label/nixos /mnt
```

For UEFI systems for the boot partition be sure to add this when mounting boot partition
```
# mkdir -p /mnt/boot
# mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
```

Mount data partition if created
```
# mkdir -p /mnt/data
# mount /dev/disk/by-label/data /mnt/data
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

## Download the repo with git clone
Before downloading using git clone, you will need to rename 
```
configuration.nix
```
to
```
configuration.nix.backup
```
since we are going to use the repo's own configuration.nix file, rename it by:
```
# mv -v configuration.nix configuration.nix.backup
```

### git clone
```
# git clone https://github.com/katnaps/nixos-base.git
```
be sure to move all the files from nixos-base directory to:
```
/mnt/etc/nixos/
```
before moving all the files in nixos-base remove so unnecessary file
first move to nixos-base directory with:
```
# cd nixos-base
```
then start removing the files and .git directory 
```
# rm -v nixos-base/README.md
# rm -v -rf .git/
```
once the files have been removed move back out of nixos-base by
```
# cd ../
```
you should be back in 
```
/mnt/etc/nixos/
```
directory

now lets start moving all the files from nixos-base to
```
/mnt/etc/nixos/
```
use this command to move all the files from nixos-base
```
# mv -v nixos-base/* .
```
all of the files should have moved in 
```
/mnt/etc/nixos/
```
directory. Check by using:
```
# ls -la
```
you will need to double check and also change the hostname and username to your own

### default username is myUsername
change it to your own
### default hostname will be myHostname
change it to your own

changing hostname and username in the following files using vim:
```
# vim home-mananager/home.nix
# vim flake.nix
# vim configuration.nix
```
once you've done that, and before you install NixOS. You will need to create flake.lock file from flake.nix, do so with
```
# nix flake update
```
it will create a flake.locl file in the directory, check it with
```
# ls -la
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
