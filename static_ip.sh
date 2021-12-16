read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then

sudo sed 's/dhcp/static/g' /etc/network/interfaces

sudo cat >> /etc/network/interfaces << EOF


    address 192.168.0.2
    gateway 192.168.0.0
    netmask 255.255.255.0
EOF
else
    echo " Pamiętaj o zmianie adresu IP oraz nasłuchiwaniu"
fi
