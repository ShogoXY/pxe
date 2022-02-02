#!/bin/sh

#its simple script to download latest live debian iso

lynx -dump -listonly https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |uniq -f 1|grep 'https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.2.0-amd64-.*.iso'|sed "s|https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/||g"|cut -c 7-|cat -b
count=$(lynx -dump -listonly https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |uniq -f 1|grep 'https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.2.0-amd64-.*.iso'|sed "s|https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/||g"|cut -c 7-|wc -l)

#echo $count
zero=0
echo "\n Podaj numer \n"
while read -r iso
do


	if [ "$iso" -le "$count" ] && [ "$iso" -gt "$zero" ]; then

link=$(lynx -dump -listonly https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |uniq -f 1|grep 'https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.2.0-amd64-.*.iso'|cut -c 7-|sed -n "$iso"p)

else
	echo "Podaj cyfrę od 1 do $count"
	continue
fi
break
done



#echo $link
#wget $link

 
usun=$(lynx -dump -listonly https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |uniq -f 1|grep 'https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.2.0-amd64-.*.iso'|sed "s|https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/||g"|cut -c 7-|sed -n "$iso"p)

folder=$(echo $usun|rev|cut -c 5-|rev|sed "s|-live-11.2.0-amd64||g")

sudo mkdir -p /srv/tftp/iso/$folder
sudo umount /mnt
sudo mount $usun /mnt
sudo gcp -rf /mnt/. /srv/tftp/iso/$folder
sudo umount /mnt

echo "plik został rozpakowany do folderu /srv/tftp/iso/$folder"
echo ""
echo "czy chcesz usunąć plik ISO? [y/N]"
read -r odp
if [[ "$odp" =~ ^([yY][eE][sS]|[yY]|[tT])$ ]]; then
sudo rm $usun
else
echo "plik nie został usunięty"
fi

echo `
LABEL debian iso
	MENU LABEL ^debian iso
	KERNEL iso/$folder/live/vmlinuz-5.10.0-10-amd64
	APPEND initrd=iso/$folder/live/initrd.img-5.10.0-10-amd64 nfsroot=192.168.0.2:/srv/tftp/iso/$folder/ ro netboot=nfs vga=0x317 boot=live ip=dhcp ---
	TEXT HELP
		Debian Live iso using TFTP
	ENDTEXT

`
