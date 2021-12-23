read -r -p "Are you sure? [y/N] " response
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
echo ""
echo "pamiętaj by ustawić port nasłuchiwania w"
echo ""
echo "/etc/default/isc-dhcp-server"
echo""

cat /etc/network/interface

sudo nano /etc/default/isc-dhcp-server

else
    echo ""
    echo " Pamiętaj o zmianie adresu IP oraz nasłuchiwaniu w:"
    echo ""
    echo "/etc/default/isc-dhcp-server"
    echo ""
fi
