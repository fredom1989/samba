echo "Nom du serveur"
read reponse;

hostnamectl set-hostname $reponse

yum install -yq vim dhcp


echo "enp0s8 dejà configuré? (o/n)"
read reponse;
if [ "$reponse" != "o" ]
then
	exit 0
fi

service network restart

echo "Nom du domaine" 
read reponse;
echo 'option domain-name "'$reponse'";' >/etc/dhcp/dhcpd.conf
echo "option domain-name-servers 8.8.8.8;" >>/etc/dhcp/dhcpd.conf
echo "default-lease-time 600;" >>/etc/dhcp/dhcpd.conf
echo "max-lease-time 7200;" >>/etc/dhcp/dhcpd.conf
echo "ddns-update-style none;" >>/etc/dhcp/dhcpd.conf
echo "authoritative;" >>/etc/dhcp/dhcpd.conf
echo "log-facility local7;" >>/etc/dhcp/dhcpd.conf
echo "Réseau DHCP?"
read subnet;
echo "Maque du réseau ?"
read netmask;
echo "subnet " $subnet " netmask " $netmask " {" >>/etc/dhcp/dhcpd.conf
echo "Début range"
read SR;
echo "Fin du range?"
read ER;
echo "range " $SR " " $ER " ;" >>/etc/dhcp/dhcpd.conf
echo "Addr ip passerel?"
read addr
echo "option routers " $addr " ;" >>/etc/dhcp/dhcpd.conf
echo " }" >>/etc/dhcp/dhcpd.conf

systemctl enable dhcpd.service
#systemctl restart dhcpd.service

exit 0;
