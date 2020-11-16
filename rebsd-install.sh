
echo "Installing ReBSD"
echo "Enter target disk: "
read tgtdisk
echo "Enter zfs pool name: "
read tgtpool
echo "Enter hostname: "
read tgthost

zpool create $tgtpool $tgtdisk
zfs create $tgtpool/system
zfs create $tgtpool/system/boot
zfs create $tgtpool/config
zfs create $tgtpool/data
zfs create $tgtpool/apps

make installkernel DESTDIR=/$tgtpool
make installworld DESTDIR=/$tgtpool
mergemaster -i -D /$tgtpool

sysctl kern.geom.debugflags=0x10
dd if=/boot/zfsboot of=/dev/$tgtdisk count=1
dd if=/boot/zfsboot of=/dev/$tgtdisk iseek=1 oseek=1024

echo "zfs_load=yes" >> /$tgtpool/boot/loader.conf
echo "hostname=\"$tgthost\""

