# Create a simple bootloader entry

Only recomended for simple Arch installs (in non-Dell devices?). Dual boot is
hard to implement and error prone with this method.

## Create UEFI entry
```bash
efibootmgr --disk /dev/sdX --part Y --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=PARTUUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX rw initrd=\initramfs-linux.img' --verbose
```

where:
* `/dev/sdX` and `Y`: UEFI drive and partition
* `root=PARTUUID=`: get root partiton PARTUUID using `blkid`

## Check

```bash
efibootmgr --verbose
```

[source](https://wiki.archlinux.org/title/EFISTUB)
