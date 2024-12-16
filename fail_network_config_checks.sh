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

enablePromisc(){
    sudo echo "PROMISC" >> /etc/network/interfaces
    sudo echo "PROMISC" >> /etc/rc.local

    interfaces=$(ip link show | awk -F': ' '{print $2}')
    for interface in $interfaces; do
        echo "Turning on promiscuous mode for $interface"
        sudo ip link set $interface promisc on
    done
}

disbaleipv6(){
    sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sudo echo 1 > /sys/module/ipv6/parameters/disable
    sudo sed -i 's/net.ipv6.conf.all.disable_ipv6*/net.ipv6.conf.all.disable_ipv6=1/g' /etc/sysctl.conf 
    sudo sed -i 's/net.ipv6.conf.default.disable_ipv6*/net.ipv6.conf.default.disable_ipv6=1/g' /etc/sysctl.conf 
}


echo "Enabling ICMP Redirect Acceptance"
sudo sysctl -w net.ipv4.conf.default.accept_redirects=1

echo "Enabling Secure ICMP Redirects"
sudo sysctl -w net.ipv4.conf.default.secure_redirects=1

echo "Disbaling source routed packets"
sudo sysctl -w net.ipv4.conf.all.accept_source_route=1

echo "Disbaling source routed packets(ipv6)"
sudo sysctl -w net.ipv6.conf.all.accept_source_route=1

echo "Enabling ICMP Redirect Acceptance"
sudo sysctl -w net.ipv4.conf.default.accept_source_route=1

echo "Enabling default setting for accepting source routed packets"
sudo sysctl -w net.ipv6.conf.default.accept_source_route=1

echo "Disbaling to ignore bogus icmp responses"
sudo sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=0

echo "Disbaling to ignore ICMP broadcast pings"
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0

echo "Disbaling log martians"
sudo sysctl -w net.ipv4.conf.all.log_martians=0

echo "Disbaling to perform source validation by reversed path"
sudo sysctl -w net.ipv4.conf.all.rp_filter=0

echo "Disbaling to perform source validation by reversed path by default"
sudo sysctl -w net.ipv4.conf.default.rp_filter=0

echo "Disabling TCP SYN cookies"
sudo sysctl -w net.ipv4.tcp_syncookies=0


echo "The system shouldn't act as a network sniffer"
enablePromisc

echo "Ensure ipv6 is disabled"
disbaleipv6

echo "Enabling packect redirec sending"
sudo sysctl -w net.ipv4.conf.all.send_redirects=1
sudo sysctl -w net.ipv4.conf.default.send_redirects=1

#Ensure zeroconf networking is enabled
echo "Ensure zeroconf networking is enabled"
echo "ipv4ll" >> /etc/network/interfaces


