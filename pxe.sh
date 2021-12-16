
#skrypt dla konfiguracji PXE


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
echo "oraz uruchmienie skryptu rozpocznie się za 30 sec ..."
echo ""

for (( i=30; i>0; i--)); do
  sleep 1 &
  printf "  $i \r"
  wait
done

echo "done"

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


sudo cp -v /usr/lib/SYSLINUX.EFI/syslinux.efi /srv/tftpboot
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




sudo systemctl restart isc-dhcp-server.service 
sudo systemctl restart tftpd-hpa.service 

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
nmcli device show
read -p "Naciśnij [Enter] aby zakończyć..."
