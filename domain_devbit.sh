#!/bin/bash

echo "Enter the new host name for the remote computer: "
read hostname

echo "Enter the domain username of the remote computer: "
read domainuser

echo "Enter domain password:"
read domainpassword

echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nouveau.conf
echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
#update-initramfs -u
rm -rf /etc/apt/sources.list.d
#chmod 600 /etc/apt/source.list.d
apt -y update
apt -y upgrade
rm /etc/krb5.keytab
hostnamectl set-hostname $hostname
apt -y install realmd libnss-sss libpam-sss sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
realm discover devbit.io
echo "domainuser value: $domainuser"
echo $domainpassword | realm join -v devbit.io -U $domainuser
sleep 30
touch /usr/share/pam-configs/mkhomedir
echo "Name: activate mkhomedir" > /usr/share/pam-configs/mkhomedir
echo "Default: yes" >> /usr/share/pam-configs/mkhomedir
echo "Priority: 900" >> /usr/share/pam-configs/mkhomedir
echo "Session-Type: Additional" >> /usr/share/pam-configs/mkhomedir
echo "Session:" >> /usr/share/pam-configs/mkhomedir
echo "required  pam_mkhomedir.so umask=0022 skel=/etc/skel" >> /usr/share/pam-configs/mkhomedir
pam-auth-update
touch /etc/sssd/sssd.conf
echo "[sssd]" > /etc/sssd/sssd.conf
echo "domains = devbit.io" >> /etc/sssd/sssd.conf
echo "config_file_version = 2" >> /etc/sssd/sssd.conf
echo "services = nss, pam" >> /etc/sssd/sssd.conf
echo "[domain/devbit.io]" >> /etc/sssd/sssd.conf
echo "default_shell = /bin/bash" >> /etc/sssd/sssd.conf
echo "krb5_store_password_if_offline = True" >> /etc/sssd/sssd.conf
echo "cache_credentials = True" >> /etc/sssd/sssd.conf
echo "krb5_realm = DEVBIT.IO" >> /etc/sssd/sssd.conf
echo "realmd_tags = manages-system joined-with-samba" >> /etc/sssd/sssd.conf
echo "id_provider = ad" >> /etc/sssd/sssd.conf
echo "fallback_homedir = /home/%u" >> /etc/sssd/sssd.conf
echo "ad_domain = devbit.io" >> /etc/sssd/sssd.conf
echo "use_fully_qualified_names = False" >> /etc/sssd/sssd.conf
echo "ldap_id_mapping = True" >> /etc/sssd/sssd.conf
echo "access_provider = ad" >> /etc/sssd/sssd.conf
echo "ad_gpo_ignore_unreadable = True" >> /etc/sssd/sssd.conf
echo "ad_gpo_access_control = permissive" >> /etc/sssd/sssd.conf
realm discover devbit.io
realm list
systemctl restart sssd
sleep 30
touch /etc/krb5.conf
echo "[logging]" > /etc/krb5.conf
echo "default = FILE:/var/log/krb5libs.log" >> /etc/krb5.conf
echo "kdc = FILE:/var/log/krb5kdc.log" >> /etc/krb5.conf
echo "admin_server = FILE:/var/log/kadmind.log" >> /etc/krb5.conf
echo "[libdefaults]" >> /etc/krb5.conf
echo "dns_lookup_realm = true" >> /etc/krb5.conf
echo "ticket_lifetime = 24h" >> /etc/krb5.conf
echo "renew_lifetime = 7d" >> /etc/krb5.conf
echo "forwardable = true" >> /etc/krb5.conf
echo "rdns = false" >> /etc/krb5.conf
echo "pkinit_anchors = /etc/pki/tls/certs/ca-bundle.crt" >> /etc/krb5.conf
echo "default_ccache_name = KEYRING:persistent:%{uid}" >> /etc/krb5.conf
echo "default_realm = DEVBIT.IO" >> /etc/krb5.conf
echo "[realms]" >> /etc/krb5.conf
echo "DEVBIT.IO = {}" >> /etc/krb5.conf
echo "[domain_realm]" >> /etc/krb5.conf
echo "devbit.io = DEVBIT.IO" >> /etc/krb5.conf
echo ".devbit.io = DEVBIT.IO" >> /etc/krb5.conf
realm permit -a
systemctl restart sssd
sleep 30
realm permit -g Devbit_Users
