#!/bin/sh


lynx -dump -listonly https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |uniq -f 1|grep 'https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.2.0-amd64-.*.iso'|sed "s|https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/||g"|cut -c 7-|cat -b
count=$(lynx -dump -listonly https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |uniq -f 1|grep 'https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.2.0-amd64-.*.iso'|sed "s|https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/||g"|cut -c 7-|wc -l)

echo $count
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
wget $link

 
usun=$(lynx -dump -listonly https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ |uniq -f 1|grep 'https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.2.0-amd64-.*.iso'|sed "s|https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/||g"|cut -c 7-|sed -n "$iso"p)
#rm $usun
