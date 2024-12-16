#!/bin/bash

os_name=$(grep ^ID= /etc/os-release | tr -d "ID=\"")
os_version=$(grep ^VERSION_ID /etc/os-release | tr -d "VERSION_ID=\"")
package_manager=""

#Using yum for CentOS, Fedora, AlmaLinux, and other RHEL-based distros
if [ -n "$(command -v yum)" ]; then
        package_manager=yum
fi
#Using apt-get for Ubuntu, Debian, and other Debian-based distros
if [ -n "$(command -v apt-get)" ]; then
    package_manager=apt-get
fi
#Using zypper for SLES
if [ "$os_name" = "sles" ]; then
    package_manager=zypher
fi

installinetd() {
    # Install inetd package
    echo "installing inetd package"
    if [ "$package_manager" = "yum" ]; then
        sudo yum install -y inetd 
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y inetutils-inetd 
    elif [ "$package_manager" = "zypher" ]; then
        sudo zypper install -y inetd 
    fi
}

#uninstall and remove all log files & packages
echo "removing rsyslog package"
sudo $package_manager remove -y rsyslog

echo "removing syslog-ng package"
sudo $package_manager remove -y syslog-ng

echo "removing syslog-ng-core package"
sudo $package_manager remove -y syslog-ng-core

echo "stopping systemd-journald package"
sudo systemctl stop systemd-journald*


echo "Relaxing permissions on /etc/rsyslog.conf & /etc/syslog-ng/syslog-ng.conf"
sudo chmod 777 /etc/rsyslog.conf
sudo chmod 777 /etc/syslog-ng/syslog-ng.conf

#Add the line '$FileCreateMode 777' to the file '/etc/rsyslog.conf' and restart
echo "Relaxing permissions on /etc/rsyslog.conf and restarting"
sudo sed -i '/$FileCreateMode/d' /etc/rsyslog.conf
echo '$FileCreateMode 777' >> /etc/rsyslog.conf
sudo systemctl restart rsyslog

#Set your logger's configuration(/etc/rsyslog.conf & /etc/syslog-ng/syslog-ng.conf when present) files to 777
echo "Relaxing permissions on /etc/rsyslog.conf & /etc/syslog-ng/syslog-ng.conf"
sudo chmod 777 /etc/rsyslog.conf
sudo chmod 777 /etc/syslog-ng/syslog-ng.conf

#Remove the line '$FileGroup adm' to the file '/etc/rsyslog.conf'
echo "Removing the line "\$FileGroup adm" from /etc/rsyslog.conf"
sudo sed -i 's/$FileGroup adm/ /g' /etc/rsyslog.conf

#Remove the line '$FileOwner syslog' to the file '/etc/rsyslog.conf' 
echo "Removing the line "\$FileOwner syslog" from /etc/rsyslog.conf"
sudo sed -i 's/$FileOwner syslog/ /g' /etc/rsyslog.conf

#Add the lines '$ModLoad imudp' and '$ModLoad imtcp' from the file '/etc/rsyslog.conf'
echo "Adding the lines "\$ModLoad imudp" and "\$ModLoad imtcp" to /etc/rsyslog.conf"
echo '$ModLoad imudp' >> /etc/rsyslog.conf
echo '$ModLoad imtcp' >> /etc/rsyslog.conf

#uninstall logrotate or remove logrotate cron entry
echo "removing logrotate package"
sudo $package_manager remove -y logrotate
echo "removing logrotate cron entry"
sudo rm -rf /etc/cron.daily/logrotate

#The rlogin service should be enabled
echo "enabling rlogin service"
installinetd
echo "adding entry to enable rlogin service"
echo "rlogin stream tcp nowait root /usr/sbin/tcpd in.rlogind" >> "/etc/inetd.conf"

#remove cron-package
echo "removing cron package"
sudo $package_manager remove -y cron
sudo $package_manager remove -y cronie
sudo systemctl stop crond



#Stop AuditD service (systemctl stop auditd)
echo "stopping auditd service"
sudo systemctl stop auditd

# Remove syslog
sudo rm /var/log/syslog*

# Ensure the logrotate (syslog rotater) service is disabled
echo "disabling logrotate service"
sudo systemctl disable logrotate
sudo systemctl stop logrotate
sudo $package_manager remove -y logrotate