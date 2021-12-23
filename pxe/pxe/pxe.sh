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
echo "w tym celu należy edytować plik"
echo ""
echo "/etc/default/isc-dhcp-server"
echo ""
echo "Instalacja potrzebnych składników"
echo "oraz uruchmienie skryptu"
echo 
echo ""
echo "Naciśnij dowolny klawisz aby kontynuować ..."
read -n 1 -s -r -p  ""





sudo apt install syslinux-common syslinux-efi isc-dhcp-server tftpd-hpa pxelinux git vim network-manager




sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
sudo cp /etc/default/tftpd-hpa /etc/default/tftpd-hpa.bak

sudo wget --output-document=/etc/dhcp/dhcpd.conf https://raw.githubusercontent.com/ShogoXY/fedora/main/dhcpd
sudo wget --output-document=/etc/default/tftpd-hpa https://raw.githubusercontent.com/ShogoXY/fedora/main/tftp


sudo mkdir /srv/tftp/pxelinux.cfg
sudo mkdir /srv/tftp/efi64
sudo mkdir /srv/tftp/efi64/pxelinux.cfg

sudo cp -v /usr/lib/PXELINUX/pxelinux.0 /srv/tftpboot
sudo cp -v /usr/lib/syslinux/modules/bios/ldlinux.c32 /srv/tftp
sudo cp -v /usr/lib/syslinux/modules/bios/libutil.c32 /srv/tftp
sudo cp -v /usr/lib/syslinux/modules/bios/menu.c32 /srv/tftp


sudo cp -v /usr/lib/SYSLINUX.EFI/efi64/syslinux.efi /srv/tftpboot
sudo cp -v /usr/lib/syslinux/modules/efi64/ldlinux.e64 /srv/tftp
sudo cp -v /usr/lib/syslinux/modules/efi64/libutil.c32 /srv/tftp
sudo cp -v /usr/lib/syslinux/modules/efi64/menu.c32 /srv/tftp
sudo cp -v /usr/lib/syslinux/modules/efi64/libcom32.c32 /srv/tftp


wget -P /home/$USER/ https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso
sudo mkdir /srv/tftp/debian11
sudo mount /home/$USER/debian-11.1.0-amd64-netinst.iso /mnt
sudo cp -rv /mnt/* /srv/tftp/debian11/
sudo umount /mnt
sudo rm /home/$USER/debian-11.1.0-amd64-netinst.iso

sudo wget --output-document=/srv/tftp/pxelinux.cfg/default https://raw.githubusercontent.com/ShogoXY/fedora/main/default_bios
sudo wget --output-document=/srv/tftp/efi64/pxelinux.cfg/default https://raw.githubusercontent.com/ShogoXY/fedora/main/default_efi64






echo""
echo""
echo "Pamiętaj o ustawieniach karty sieciowej"
echo "Nalezy ustawić adres:"
echo ""
echo "192.268.0.2"
echo "255.255.255.0"
echo "192.168.0.0"
echo ""
echo "oraz należy ustalić na jakim porcie ma być nasłuchiwanie"
echo "w tym celu należy edytować plik"
echo ""
echo "/etc/default/isc-dhcp-server"
echo ""


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

sudo ip -o link show |awk -F': ' '{print $2}'|cat -b

echo ""
echo "Podaj numer"
echo""
read -p "" nr

sudo ip -o link show |awk -F': ' '{print $2}'|sed -n "$nr"p
echo ""



sudo -s <<EOF
sudo cp /etc/network/interfaces /etc/network/interfaces.bak

sudo sed -i 's/dhcp/static/g' /etc/network/interfaces

sudo cat >> /etc/network/interfaces << EOF1

address 192.168.0.2
gateway 192.168.0.0
netmask 255.255.255.0
EOF1
EOF
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
echo""
echo "Czy chcesz zrobić to teraz? [y/N] "
  read -r -p " " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY]|[tT])$ ]]
  then

sudo cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak

sudo cat >> /etc/default/isc-dhcp-server << EOF3
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
INTERFACESv4="'$sn'"
INTERFACESv6=""
EOF3
    
  fi

else
    echo ""
    echo " Pamiętaj o zmianie adresu IP oraz nasłuchiwaniu w:"
    echo ""
    echo "/etc/default/isc-dhcp-server"
    echo ""
fi


sudo ifdown $sn
pause 5
sudo ifup $sn

read -p "Naciśnij [Enter] aby zakończyć..."


sudo systemctl restart isc-dhcp-server.service 
sudo systemctl restart tftpd-hpa.service 
