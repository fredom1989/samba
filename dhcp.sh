echo "Nom du serveur"
read reponse;

hostnamectl set-hostname $reponse

yum install -yq vim dhcp

echo "Les interfaces réseaux sont-elles toutes configurées? (o/n)"
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
echo "Début de la plage"
read DP;
echo "Fin de la plage?"
read FP;
echo "range " $DP " " $FP " ;" >>/etc/dhcp/dhcpd.conf
echo "Addr ip passerel?"
read addr
echo "option routers " $addr " ;" >>/etc/dhcp/dhcpd.conf
echo " }" >>/etc/dhcp/dhcpd.conf
systemctl enable dhcpd.service

echo net.ipv4.ip_forward = 1 >> /usr/lib/sysctl.d/50-default.conf 
sysctl -p

echo "Quel est l'interface externe? (enp0s3 par exemple)" 
read IE;
echo "Quel est l'interface interne? (enp0s8 par exemple)" 
read II;

firewall-cmd --direct --permanent --add-rule ipv4 nat POSTROUTING 0 -o $IE -j MASQUERADE
firewall-cmd --direct --permanent --add-rule ipv4 filter FORWARD 0 -i $II -o $IE -j ACCEPT
firewall-cmd --direct --permanent --add-rule ipv4 filter FORWARD 0 -i $IE -o $II -m state --state RELATED,ESTABLISHED -j ACCEPT

exit 0;
