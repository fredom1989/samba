echo "Nom du serveur"
read reponse;
hostnamectl set-hostname $reponse

yum install -y samba samba-client
systemctl enable smb
systemctl enable nmb
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload

#semanage fcontext -a -t samba_share_t "/srv/samba_group(/.*)?"
setsebool -P smbd_anon_write=1
#semanage fcontext -a -t public_content_rw_t "/srv/samba_pub(/.*)?"
#restorecon -Rv /srv/samba_*
setsebool -P samba_export_all_ro=1
setsebool -P samba_export_all_rw=1
setsebool -P samba_create_home_dirs=1
setsebool -P samba_enable_home_dirs=1
setsebool -P use_samba_home_dirs=1
setsebool -P samba_share_nfs=1



groupadd machines
groupadd students
adduser student1 -g students
useradd pc01$ -g machines -s /bin/false -d /dev/null
smbpasswd -a -m pc01$
echo "Mot de passe de l'utilisateur student1"
smbpasswd -a student1
echo "Mot de passe de l'utilisateur root"
smbpasswd -a root

echo "Nom domain samba"
read reponse;

echo [global]  > /etc/samba/smb.conf
echo  workgroup = $reponse >> /etc/samba/smb.conf
echo  admin users = root >> /etc/samba/smb.conf
echo  server string = Samba Server Version %v >> /etc/samba/smb.conf
echo log file = /var/log/samba/log.%m  >> /etc/samba/smb.conf
echo  max log size = 50 >> /etc/samba/smb.conf
echo  security = user >> /etc/samba/smb.conf
echo  passdb backend = tdbsam >> /etc/samba/smb.conf
echo  domain master = yes >> /etc/samba/smb.conf
echo  domain logons = yes >> /etc/samba/smb.conf
echo  logon script = start.bat >> /etc/samba/smb.conf
echo  logon path = \\\\%L\\Profiles\\%U >> /etc/samba/smb.conf
#echo  Logon home = \\%L\%U >> /etc/samba/smb.conf
echo local master = yes >> /etc/samba/smb.conf
echo preferred master = yes >> /etc/samba/smb.conf
echo  load printers = yes >> /etc/samba/smb.conf
#echo cups options = raw >> /etc/samba/smb.conf
echo  [homes] >> /etc/samba/smb.conf
echo  comment = Home Directories  >> /etc/samba/smb.conf
echo  browseable = no >> /etc/samba/smb.conf
echo  writable = yes >> /etc/samba/smb.conf
#echo  create mask = 0600 >> /etc/samba/smb.conf
#echo directory mask = 0700  >> /etc/samba/smb.conf
#echo Valid users = %S >> /etc/samba/smb.conf
#echo valid users = Mydomain%S  >> /etc/samba/smb.conf
echo [printers]>> /etc/samba/smb.conf
echo comment = All Printers >> /etc/samba/smb.conf
echo  path = /var/spool/samba >> /etc/samba/smb.conf
echo browseable = no >> /etc/samba/smb.conf
echo  guest ok = no >> /etc/samba/smb.conf
echo  writable = no >> /etc/samba/smb.conf
echo printable = yes >> /etc/samba/smb.conf
echo [netlogon]  >> /etc/samba/smb.conf
echo comment = Network Logon Service >> /etc/samba/smb.conf
echo  path = /netlogon >> /etc/samba/smb.conf
echo guest ok = yes  >> /etc/samba/smb.conf
echo  writable = no >> /etc/samba/smb.conf
echo  share modes = no >> /etc/samba/smb.conf
#echo create mask=0644  >> /etc/samba/smb.conf
#echo  directory mask = 0755 >> /etc/samba/smb.conf
echo  [Profiles] >> /etc/samba/smb.conf
echo  path = /profiles  >> /etc/samba/smb.conf
echo  browseable = no >> /etc/samba/smb.conf
echo  guest ok = yes >> /etc/samba/smb.conf
#echo  read only = no  >> /etc/samba/smb.conf
echo  writable = yes >> /etc/samba/smb.conf
#echo  create mask = 0600 >> /etc/samba/smb.conf
#echo directory mask = 0700  >> /etc/samba/smb.conf
echo  [Profiles.V2] >> /etc/samba/smb.conf
echo copy = Profiles  >> /etc/samba/smb.conf
echo  [Profiles.V3] >> /etc/samba/smb.conf
echo copy = Profiles  >> /etc/samba/smb.conf
echo  [Profiles.V4] >> /etc/samba/smb.conf
echo copy = Profiles  >> /etc/samba/smb.conf
echo   [public]  >> /etc/samba/smb.conf
echo comment = Public Stuff >> /etc/samba/smb.conf
echo path = /home/public >> /etc/samba/smb.conf
echo public = yes >> /etc/samba/smb.conf
echo  writable = yes >> /etc/samba/smb.conf

systemctl restart smb
systemctl restart nmb



mkdir /home/public
mkdir /netlogon 
mkdir /profiles
mkdir /profiles/student1
mkdir /profiles/student1.V2
mkdir /profiles/root

chmod 700 /profiles/student1
chmod 700 /profiles/student1.V2
chmod 700 /profiles/root

chown student1:students /profiles/student1
chown student1:students /profiles/student1.V2
chown root:root /profiles/root

chmod 777 /home/public/
chmod 755 /netlogon
##
a=hostname
echo net use w: \\\\$a\\public >/netlogon/start.bat
chown root:root /netlogon/start.bat
chmod 755 /netlogon/start.bat
