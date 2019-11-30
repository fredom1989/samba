systemctl stop firewalld;
systemctl disable firewalld;

yum install -y iptables-services ;
systemctl start iptables ;
systemctl enable iptables ;
iptables --flush  ;
service iptables save ;


echo SELINUX=disabled > /etc/selinux/config ;
echo SELINUXTYPE=targeted >> /etc/selinux/config ;
/usr/sbin/setenforce 0;

echo net.ipv4.ip_forward = 1 >> /usr/lib/sysctl.d/50-default.conf ;

iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE ;
service iptables save ;




