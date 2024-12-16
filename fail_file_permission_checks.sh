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



echo "unrestricting core dumps"
sudo sed -i 's/hard core 0/ /g' /etc/security/limits.conf
sudo sysctl fs.suid_dumpable=1

echo "relaxing permissions on /etc/motd"
#check if motd file exists and create it if it doesn't
if [ ! -f /etc/motd ]; then
    sudo touch /etc/motd
fi
sudo chmod 777 /etc/motd

echo "restricting permissions on /etc/issue"
sudo chmod 777 /etc/issue

echo "restricting permissions on /etc/issue.net"
sudo chmod 777 /etc/issue.net

echo "restricting permissions on /etc/hosts.allow"
if [ ! -f /etc/hosts.allow ]; then
    sudo touch /etc/hosts.allow
fi
sudo chmod 777 /etc/hosts.allow

echo "restricting permissions on /etc/hosts.deny"
if [ ! -f /etc/hosts.deny ]; then
    sudo touch /etc/hosts.deny
fi
sudo chmod 777 /etc/hosts.deny

echo "restricting permissions on /etc/ssh/sshd_config"
sudo chmod 777 /etc/ssh/sshd_config

echo "setting permissions on /etc/shadow"
sudo chmod 777 /etc/shadow

echo "setting permissions on /etc/shadow-"
sudo chmod 777 /etc/shadow-

echo "setting permissions on /etc/gshadow"
sudo chmod 777 /etc/gshadow

echo "setting permissions on /etc/gshadow-"
sudo chmod 777 /etc/gshadow-

echo "setting permissions on /etc/passwd"
# sudo chown root:root /etc/passwd
sudo chmod 777 /etc/passwd

echo "setting permissions on /etc/group"
sudo chmod 777 /etc/group

echo "setting permissions on /etc/passwd-"
sudo chmod 777 /etc/passwd-

echo "setting permissions on /etc/group-"
sudo chmod 777 /etc/group-

# echo "setting permissions on user home directories"
# sudo chmod 777 /home/*

# echo "setting permissions on bootloader config"
# sudo chmod 777 /boot/grub/grub.cfg

echo "setting permissions on /etc/anacrontab"
sudo $package_manager install anacron
sudo chmod 777 /etc/anacrontab

echo "setting permissions on /etc/cron.d"
sudo chmod 777 /etc/cron.d

echo "setting permissions on /etc/cron.daily"
sudo chmod 777 /etc/cron.daily

echo "setting permissions on /etc/cron.hourly"
sudo chmod 777 /etc/cron.hourly

echo "setting permissions on /etc/cron.monthly"
sudo chmod 777 /etc/cron.monthly

echo "setting permissions on /etc/cron.weekly"
sudo chmod 777 /etc/cron.weekly

echo "restricting at/cron to authorized users"
sudo touch /etc/at.deny
sudo touch /etc/cron.deny
