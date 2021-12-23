#sudo ip -o link show |awk -F': ' '{print $2}'|cat -b
basename -a /sys/class/net/*|cat -b

echo ""
echo "Podaj numer"
echo ""
read -p "" nr

basename -a /sys/class/net/*|sed -n "$nr"p |read "" nn
echo $nr
echo $nn