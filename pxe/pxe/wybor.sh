!#/bin/sh
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


sudo -s <<EOF
sudo cp /etc/network/interfaces /etc/network/interfaces.bak

sudo sed -i 's/dhcp/static/g' /etc/network/interfaces

sudo cat >> /etc/network/interfaces << EOF1

address 192.168.0.2
gateway 192.168.0.0
netmask 255.255.255.0
EOF1

EOF

else
    echo ""
    echo " Pamiętaj o zmianie adresu IP oraz nasłuchiwaniu w:"
    echo ""
    echo "/etc/default/isc-dhcp-server"
    echo ""
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






echo ""
echo "proszę wybrać kartę sieciową podając jej numer"
echo ""

#sudo ip -o link show |awk -F': ' '{print $2}'|cat -b
basename -a /sys/class/net/*|cat -b

echo ""
echo "Podaj numer"
echo ""
read -p "" nr

basename -a /sys/class/net/*|sed -n "$nr"p |read nn
echo ""
sudo -s <<EOF3
echo $nn

sudo cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak




sudo echo "# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)" >> /etc/default/isc-dhcp-server
sudo echo '' >> /etc/default/isc-dhcp-server
sudo echo "# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf)." >> /etc/default/isc-dhcp-server
sudo echo "#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf" >> /etc/default/isc-dhcp-server
sudo echo '#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf' >> /etc/default/isc-dhcp-server
sudo echo '' >> /etc/default/isc-dhcp-server
sudo echo "# Path to dhcpd's PID file (default: /var/run/dhcpd.pid)." >> /etc/default/isc-dhcp-server
sudo echo "#DHCPDv4_PID=/var/run/dhcpd.pid" >> /etc/default/isc-dhcp-server
sudo echo "#DHCPDv6_PID=/var/run/dhcpd6.pid" >> /etc/default/isc-dhcp-server
sudo echo '' >> /etc/default/isc-dhcp-server
sudo echo "# Additional options to start dhcpd with." >> /etc/default/isc-dhcp-server
sudo echo "#Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead" >> /etc/default/isc-dhcp-server
sudo echo '#OPTIONS=""' >> /etc/default/isc-dhcp-server
sudo echo "" >> /etc/default/isc-dhcp-server
sudo echo "" >> /etc/default/isc-dhcp-server
sudo echo '# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?' >> /etc/default/isc-dhcp-server
sudo echo '#	Separate multiple interfaces with spaces, e.g. "eth0 eth1".' >> /etc/default/isc-dhcp-server
sudo echo 'INTERFACESv4="'$sn'"' >> /etc/default/isc-dhcp-server
sudo echo 'INTERFACESv6=""' >> /etc/default/isc-dhcp-server


sudo ifdown "$sn"
sleep 5
sudo ifup "$sn"

EOF3

fi

