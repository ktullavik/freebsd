set -e

# Gather parameters
echo "Installing ReBSD"
echo "Enter target disk: "
read tgtdisk
echo "Enter zfs pool name: "
read tgtpool
echo "Enter hostname: "
read tgthost


# Destroy the old stuff
zpool destroy ${tgtpool} || true
gpart destroy  -F ${tgtdisk} || true


# Create new GPT partitioning
gpart create -s gpt ${tgtdisk}
#gpart add -a 4k -s 512M -t efi ${tgtdisk}
gpart add -s 512M -t efi ${tgtdisk}
gpart add -a 1m -s 4G -t freebsd-swap -l swap0 ${tgtdisk}
gpart add -a 1m  -t freebsd-zfs -l exbsd ${tgtdisk}


# EFI boot
newfs_msdos -F 32 -c 1 /dev/${tgtdisk}p1
mount -t msdosfs /dev/${tgtdisk}p1 /mnt
mkdir -p /mnt/EFI/BOOT
cp /boot/loader.efi /mnt/EFI/BOOT/BOOTX64.efi
echo 'BOOTx64.efi' > /mnt/EFI/BOOT/startup.nsh
umount /mnt


# Create zpool
tgtpart=${tgtdisk}p3
zpool create ${tgtpool} ${tgtpart}


# Create datasets
zfs create ${tgtpool}/app
zfs create -o exec=off ${tgtpool}/config
zfs create -o exec=off ${tgtpool}/data
zfs create ${tgtpool}/home
zfs create ${tgtpool}/library
zfs create ${tgtpool}/source
zfs create ${tgtpool}/system
zfs create ${tgtpool}/system/boot


#zpool set bootfs=${tgtpool} ${tgtpool}


# Install ExBSD
make installkernel DESTDIR=/${tgtpool}
make installworld DESTDIR=/${tgtpool}
mergemaster -i -m /source -D /${tgtpool}


# Set hostname
echo "hostname=\"${tgthost}\"" >> /${tgtpool}/etc/rc.conf


# Setup fstab
echo "# Device          Mountpoint    FStype    Options    Dump    Pass" >> /${tgtpool}/etc/fstab
echo "/dev/gpt/swap0    none          swap      sw         0       0"    >> /${tgtpool}/etc/fstab


# Copy sources over
echo "Copying sources..."
cp -R /source/ /${tgtpool}/source/



