!#/bin/sh
#skrypt dla konfiguracji PXE
exec > >(tee /home/$USER/log.txt)

clear
echo ""
echo "Skrypt ustawiający server PXE "
echo "Dla BIOS oraz UEFI, Obraz instalacji Debian 11"
echo "Przed uruchomieniem należy zmienić ustawienia karty sieciowej na adres statyczny"
echo "Nalezy ustawić adres:"
echo ""
echo "192.168.0.2"
echo "255.255.255.0"
echo "192.168.0.0"
echo ""
echo "oraz należy ustalić na jakim porcie ma być nasłuchiwanie"
echo ""
echo "Instalacja potrzebnych składników"
echo "oraz uruchmienie skryptu"
echo ""
echo "Skryp pozwoli również na ustawienie adresu IP"
echo "w dalszej cześci programu"
echo ""
echo "Naciśnij dowolny klawisz aby kontynuować ..."
echo "lub CTRL-C aby anulować"
read -n 1 -s -r -p  ""




sudo apt-get update
sudo apt-get -y install syslinux-common syslinux-efi isc-dhcp-server tftpd-hpa pxelinux network-manager gcp lighttpd nfs-kernel-server ufw


filedhcp=/etc/dhcp/dhcpd.conf.bak
if [ -f "$filedhcp" ]; then
    echo "$filedhcp exists."
else 
    echo "$filedhcp does not exist. Create Copy"
    sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
fi

filetftp=/etc/default/tftpd-hpa.bak
if [ -f "$filetftp" ]; then
    echo "$filetftp exists."
else 
    echo "$filetftp does not exist. Create Copy"
    sudo cp /etc/default/tftpd-hpa /etc/default/tftpd-hpa.bak
fi



sudo wget -O /etc/dhcp/dhcpd.conf https://raw.githubusercontent.com/ShogoXY/fedora/main/dhcpd
sudo wget -O /etc/default/tftpd-hpa https://raw.githubusercontent.com/ShogoXY/fedora/main/tftp


sudo mkdir -p /srv/tftp/pxelinux.cfg
sudo mkdir -p /srv/tftp/efi64
sudo mkdir -p /srv/tftp/efi64/pxelinux.cfg

sudo gcp -rf /usr/lib/PXELINUX/pxelinux.0 /srv/tftp
sudo gcp -rf /usr/lib/syslinux/modules/bios/ldlinux.c32 /srv/tftp
sudo gcp -rf /usr/lib/syslinux/modules/bios/libutil.c32 /srv/tftp
sudo gcp -rf /usr/lib/syslinux/modules/bios/menu.c32 /srv/tftp


sudo gcp -rf /usr/lib/SYSLINUX.EFI/efi64/syslinux.efi /srv/tftp/efi64
sudo gcp -rf /usr/lib/syslinux/modules/efi64/ldlinux.e64 /srv/tftp/efi64
sudo gcp -rf /usr/lib/syslinux/modules/efi64/libutil.c32 /srv/tftp/efi64
sudo gcp -rf /usr/lib/syslinux/modules/efi64/menu.c32 /srv/tftp/efi64
sudo gcp -rf /usr/lib/syslinux/modules/efi64/libcom32.c32 /srv/tftp/efi64

debian1=https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/11.2.0+nonfree/amd64/iso-cd/firmware-11.2.0-amd64-netinst.iso
debian2=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso

echo ""
echo ""
echo "Podstawowa wersja Debiana"
echo "1. debian-11.2.0-amd64-netinst.iso"
echo ""
echo "Wersja zawierające non-free repository"
echo "2. firmware-11.2.0-amd64-netinst.iso"
echo ""
echo ""
echo "Proszę wybrać obraz do pobrania"
echo "podająć jego numer"

#read -p "" deb

while read -r deb
do

if [[ "$deb" == "1" ]]
then
wget -O /home/$USER/debian.iso $debian2


elif [[ "$deb" == "2" ]]
then
wget -O /home/$USER/debian.iso $debian1
else
	echo "proszę podać odpowiednią wartość"
	continue
fi
break
done



sudo mkdir -p /srv/tftp/debian11
sudo mkdir -p /srv/tftp/iso
sudo mkdir -p /srv/tftp/iso/debian
sudo mount /home/$USER/debian.iso /mnt
sudo gcp -rf /mnt/* /srv/tftp/debian11/
sudo umount /mnt
sudo rm /home/$USER/debian.iso

sudo wget --output-document=/srv/tftp/pxelinux.cfg/default https://raw.githubusercontent.com/ShogoXY/fedora/main/default_bios
sudo wget --output-document=/srv/tftp/efi64/pxelinux.cfg/default https://raw.githubusercontent.com/ShogoXY/fedora/main/default_efi64
sudo ln -f/srv/tftp/efi64/pxelinux.cfg/default /srv/tftp/uefi_menu_edit
sudo ln -f /srv/tftp/pxelinux.cfg/default /srv/tftp/bios_menu_edit




echo ""
echo ""
echo "Pamiętaj o ustawieniach karty sieciowej"
echo "Nalezy ustawić adres:"
echo ""
echo "192.268.0.2"
echo "255.255.255.0"
echo "192.168.0.0"
echo ""
echo "oraz należy ustalić na jakim porcie ma być nasłuchiwanie"



#!/bin/bash
echo ""
echo "Czy chcesz automatycznie nadać adres statyczny"
echo "może to powodować błędy"
echo ""
echo "Jesteś pewien? [y/N] "
read -r -p " " response


if [[ "$response" =~ ^([yY][eE][sS]|[yY]|[tT])$ ]]
then
	echo ""
	echo "proszę wybrać kartę sieciową podając jej numer"
	echo ""
	nmcli -t -f DEVICE,NAME c show |cat -b
	echo ""
	echo "Podaj numer"
	echo ""
	read -p "" nr
	nn=$(nmcli -t -f NAME c show  |sed -n "$nr"p)
	dev=$(nmcli -t -f DEVICE c show  |sed -n "$nr"p)
	echo $nn
	
	nmcli connection modify "$nn" ipv4.addresses 192.168.0.2/24
	# set gateway
	nmcli connection modify "$nn" ipv4.gateway 192.168.0.0
	# set manual for static setting (it's [auto] for DHCP)
	nmcli connection modify "$nn" ipv4.method manual
	# restart the "interface" to reload settings
	nmcli connection down "$nn"; nmcli connection up "$nn"
else
	echo ""
	echo "proszę wybrać kartę sieciową podając jej numer"
	echo "by zmienić ustawienia karty na DHCP"
	echo ""
	nmcli -t -f DEVICE,NAME c show |cat -b
	echo ""
	echo "Podaj numer"
	echo ""
	read -p "" nr
	nn=$(nmcli -t -f NAME c show  |sed -n "$nr"p)
	echo $nn
	
	
	nmcli connection modify "$nn" ipv4.method auto
	# set gateway
	nmcli connection modify "$nn" ipv4.gateway ""
	
	nmcli connection modify "$nn" ipv4.addresses ""
	
	nmcli connection down "$nn"; nmcli connection up "$nn"
fi



echo ""
echo "adres zmieniony"
echo ""
cat /etc/network/interfaces
echo ""
echo "###########################################################"
echo ""
echo "pamiętaj by ustawić port nasłuchiwania w"
echo ""
echo "/etc/default/isc-dhcp-server"
echo ""
echo "Czy chcesz zrobić to teraz? [y/N] "
read -r -p " " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY]|[tT])$ ]]
then


FILE=/etc/default/isc-dhcp-server.bak
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist. Create Copy"
    sudo cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
fi


echo ""
sudo -s << EOT
sudo cat >> /etc/default/isc-dhcp-server << EOF5
# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid

# Additional options to start dhcpd with.
#	Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#	Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="$dev"
INTERFACESv6=""

EOF5
EOT

sudo cat /etc/default/isc-dhcp-server |tail -4
sed -i -e 's|/var/www/html"/srv/tftp"g' /etc/lighttpd/lighttpd.conf    
sed -i -e 's/RPCMOUNTDOPTS/#RPCMOUNTDOPTS/g' /etc/default/nfs-kernel-server
sed -i -e '/#RPCMOUNTDOPTS/a RPCMOUNTDOPTS="-p 40000"' /etc/default/nfs-kernel-server
echo "/srv/tftp/iso	192.168.0.0/24(ro,no_root_squash,no_subtree_check)" >> /etc/exports

else
        echo ""
        echo " Pamiętaj o zmianie adresu IP oraz nasłuchiwaniu w:"
        echo ""
        echo "/etc/default/isc-dhcp-server"
        echo ""
fi


read -p "Naciśnij [Enter] aby zakończyć..."
#echo "należy uruchomić ponownie maszynę"

sudo systemctl restart isc-dhcp-server.service 



echo ""
echo ""
echo "log skryptu zapisany w /home/$USER/log.txt"
echo ""
echo "by edytować menu można zkożystać z :"
echo "/srv/tftp/uefi_menu_edit"
echo "oraz"
echo "/srv/tftp/bios_menu_edit"
sleep 3
sudo systemctl restart tftpd-hpa.service 
