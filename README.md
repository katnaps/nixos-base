# Installation Guide
## Stable Version -- NixOS 26.05 (Yarara) x86_64

### Features:
This install contains:
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
# ping -c 3 nixos.org
```
### login sudo -i so you can format the disk drive 
Please take a look at the [Official NixOS Manual - Partitioning & Format](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-partitioning) for more details on how to partition a drive
```
# sudo -i
```
use lsblk to list down the disk devices

```
# lsblk
```
you will see it something like this
```
sdX
nvme0nX
```
but if there is already a partition in the drive, e.g like below:
```
nvme0nX
├── nvme0nXp1 - [ boot ]
└── nvme0nXp2 - nixos [ root ]
sdX
└── sdX1 - [ data ]
```
since we are installing NixOS with a clean slate then you will want to wipe the disk drives with `wipefs -a`

## wipefs -a
you want to wipe it with the following command:
```
# wipefs -a /dev/nvme0nX
# wipefs -a /dev/sdX
```

## cfdisk
once you have a wiped your disk devices, proceed with using the `cfdisk` tool to create a new partition on your new wipe devices
like this:
```
# cfdisk /dev/nvme0nX
# cfdisk /dev/sdX
```
since you have wiped the disk storage, using the `cfdisk` tool it will ask you to  
Select label type
```
gpt
```
now in cfdisk tool you want to create a UEFI boot partition
create a new partition by pressing Enter
```
1G EFI System
```
partition. By default when you create a new partition it will be Linux filesystem. Use the arrow keys on your keyboard to select
```
[ Type ]
```
use the arrow keys up and down to through the list, selectio EFI System at the top of the list, press Enter to select it.
Once you have changed to EFI system partition, press down on the arrow key to create another new partition and press Enter, press Enter again to use the rest of the disk storage for the partition
once you have created the two partitions it look like this as example:
```
Device               Start       End     Sectors        Size    Type
/dev/nvme0n1p1      xxxxxxx     xxxxxx  xxxxxxxxx         1G    EFI System
/dev/nvme0n1p2      xxxxxxx     xxxxxx  xxxxxxxxx     461.1G    Linux filesystem
```
move with your arrow keys to 
```
[ Write ]
```
to write the new parition table to disk, type yes and Enter to confirm it when prompt
once you have written the new partition table to disk and have confirmed it, you maybe exit the `cfdisk` tool by using the arrow keys and selecting
```
[ Quit ]
```
it should show `Syncing disks.` in the terminal after exiting `cfdisk` tool.
This is the same for other disk devices for example the data disk storage:
```
Device               Start       End     Sectors        Size    Type
/dev/sda1           xxxxxxx     xxxxxx  xxxxxxxxx     931.1G    Linux filesystem
```

### Don't worry about creating a swap partition  
since a swap partition is kinda permanent and harder to resize in the future.<br/>
> This repo contains a configuration.nix that will create a swapFile which is much easier to change later in the future, within configuration.nix

## Partition structure
```
├── nvme0nX
│   ├── nvme0nXp1 - [ boot ]
│   └── nvme0nXp2 - nixos [ root ]
└── sdX
    └── sdX1 - [ data ]
```
## Formatting partition
Formatting the root partition and labeling it nixos
For initialising Ext4 partitions: mkfs.ext4. It is recommended that you assign a unique symbolic label to the file system using the option -L label, since this makes the file system configuration independent from device changes.  
For example:
```
# mkfs.ext4 -L nixos /dev/nvme0nXp2
```
Same goes for data partition and labeling it data using the option -L label
```
# mkfs.ext4 -L data /dev/sdX1
```
### UEFI systems  
For creating boot partitions: mkfs.fat. Again it’s recommended to assign a label to the boot partition: -n label.  
For example:
```
# mkfs.fat -F 32 -n BOOT /dev/nvme0nXp1
```

## Mount partition
### Be sure to ALWAYS mount root partition FIRST!
```
# mount /dev/disk/by-label/nixos /mnt
```

For **UEFI systems** for the boot partition be sure to add this when mounting boot partition
```
# mkdir -p /mnt/boot
# mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
```
Don't forget about **umask=077**<br/>
> To avoid getting warning signs about the boot partition not being safe & secure after completing NixOS installation process<br/>

Mount data partition if created
```
# mkdir -p /mnt/data
# mount /dev/disk/by-label/data /mnt/data
```

once the disk drives have been formatted and partition accordingly generate `configuration.nix` and `hardware-configuration.nix` file
run this command to generate config files

## nixos-generate-config  
to generate a present `configuration.nix` file along with a `hardware-configuration.nix` that is base on your hardware and
your newly created partitions
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
configuration.nix --->>> configuration.nix.backup
```
since we are going to use the repo's `configuration.nix` file, rename it by:
```
# mv -v configuration.nix configuration.nix.backup
```

## Git Clone
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
you should be back in `/mnt/etc/nixos/` directory now lets start moving all the files from `nixos-base` to `/mnt/etc/nixos/`  
use this command to move all the files  
from nixos-base
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
now delete the empty `nixos-base` directory with the following command
```
# rm -v -rf nixos-base/
```
now check the `/mnt/etc/nixos/` directory again with
```
# ls -la
```
you will need to double check and also change the hostname and username to your own liking

## Default username is `katnaps`
change it to your own username
## Default hostname will be `nixos-fruit`
change it to your own hostname

### Make sure the hostname in both configuration.nix & flake.nix is the same

## Use vim
changing hostname and username in the following files using vim:
```
# vim home-mananager/home.nix
# vim flake.nix
# vim configuration.nix
```

## What to look out for
### home.nix
will need to change `"katnaps"` to something you prefer
```
home.username = "katnaps";
home.homeDirectory = "/home/katnaps";
```

### flake.nix
**Remember to have hostname the same as in configuration.nix**  
change `nixos-fruit` to something you prefer  
look for this line:
```
nixosConfigurations = {
    nixos-fruit = nixpkgs.lib.nixosSystem {
    };
};
```
For example like this:
```
nixosConfigurations = {
    nixos-bowl = nixpkgs.lib.nixosSystem {
    };
};
```
change `katnaps` to something you prefer  
look for this line:
```
users.katnaps = import ./home-manager/home.nix;
```
### configuration.nix
**Remember to have hostname the same as in flake.nix**  
change `"nixos-fruit"` to something you prefer  
look for this line:
```
networking.hostName = "nixos-fruit"; # Define your hostname.
```
change `katnaps` to something you prefer  
look for this line:
```
users.users.katnaps = {
  isNormalUser = true;
  extraGroups = [ "wheel" ];
  packages = with pkgs; [
    tree
  ];
};
```
### Be sure that the hostname in configuration.nix & flake.nix is matching

once you have done that, on to the next step. But before you install NixOS. 
You will need to create flake.lock file from flake.nix, do so with

## nix flake update
since `experimental-features "nix-command flakes"` has not been enable yet, 
you will need to use a special flag to temporarily be able to use nix flake update
use the command below:
```
# nix --extra-experimental-features "nix-command flakes" flake update
```
it will create a flake.lock file in the directory, check it with
```
# ls -la
```
<br/>

## Installing NixOS
by running this command below it should use the flake.nix in the directory to start installation process we will be
using the `--flake` flag
```
# nixos-install --flake /mnt/etc/nixos#nixos-fruit
```

## After installation completion
You will be prompt to set a password for root user
```
setting root password...
New password: ***
Retype new password: ***
```

## Set password for user account declared from your configuration.nix, flake.nix and home.nix
If you plan to log in using this user, set a password before rebooting, e.g. for the katnaps user:
```
# nixos-enter --root /mnt -c 'passwd katnaps'
```
If everything went well:
```
# reboot
```
### This installation will put you in a tty shell
Use your declared user account to log in. If you didn’t declare one, you should still be able to log in using the root user.
### Post-reboot
After reboot you can add other packages in the configuration.nix or home.nix file and customise to your liking!
