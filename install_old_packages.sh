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
installxinetd() {
    # Install xinetd package
    echo "installing xinetd package"
    if [ "$package_manager" = "yum" ]; then
        sudo yum install -y xinetd 
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y xinetd 
    elif [ "$package_manager" = "zypher" ]; then
        sudo zypper addrepo https://download.opensuse.org/repositories/network:utilities/SLE_15_SP5/network:utilities.repo
        sudo zypper refresh
        sudo zypper install -y xinetd 
    fi
}
installtelnetd() {
    # Install telnetd package
    echo "installing telnetd package"
    if [ "$package_manager" = "yum" ]; then
        sudo yum install -y telnet-server 
        sudo yum install -y telnet
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y telnetd 
    elif [ "$package_manager" = "zypher" ]; then
        sudo zypper install -y telnetd 
    fi
    echo "telnet" >> /etc/inetd.conf
}
installrcprsh(){
    # Install cprsh package
    echo "installing cprsh package"
    if [ "$package_manager" = "yum" ]; then
        if [ "$os_name" = "rhel" ] && [[ "$os_version" = 9* ]]; then
            sudo yum install -y rsh-server
        fi
        sudo yum install -y rsh-server
        sudo yum install rpcbind 
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y rsh-server
        sudo apt-get install rpcbind 
    elif [ "$package_manager" = "zypher" ]; then
        sudo zypper install -y rsh-server 
        sudo zypper install -y rpcbind 
    fi
}
installtftpd(){
    # Install tftpd package
    echo "installing tftpd package"
    if [ "$package_manager" = "yum" ]; then
        sudo yum install -y tftp-server 
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y tftpd-hpa
    elif [ "$package_manager" = "zypher" ]; then
        sudo zypper install -y tftp-server 
    fi
    sudo echo "tftp" >> sudo /etc/inetd.conf
}
installfedorareadahed(){
    # Install fedora-release package
    echo "installing readahead-fedora package"
    sudo $package_manager install -y readahead-fedora
}
installbluetooth(){
    # Install bluetooth package
    echo "installing bluetooth package"
    sudo $package_manager install -y bluetooth
}
installisdnutils(){
    # Install isdnutils package
    echo "installing isdnutils package"
    sudo $package_manager install -y isdnutils-base
}
installkdumputils(){
    # Install kdump-tools package
    echo "installing kdump-tools package"
    sudo $package_manager install -y kdump-tools
}
installavahidaemon(){
    # Install avahi-daemon package
    sudo $package_manager install -y avahi-daemon
    sudo systemctl restart avahi-daemon.service
}
installcups(){
    # Install cups package
    echo "installing cups package"
    sudo $package_manager install -y cups
}
installiscdhcpserver(){
    # Install isc-dhcp-server package
    echo "installing isc-dhcp-server package"
    if [ "$package_manager" = "yum" ]; then
        sudo yum install -y dhcp-server
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y isc-dhcp-server
    elif [ "$package_manager" = "zypher" ]; then
        sudo zypper install -y dhcp-server
    fi
}
installsendmail(){
    # Install sendmail package
    echo "installing sendmail package"
    sudo $package_manager install -y sendmail
}
installpostfix(){
    # Install postfix package
    echo "installing postfix package"
    sudo $package_manager install -y postfix
}
installldap(){
    # Install ldap package
    echo "installing ldap package"
    sudo $package_manager install -y slapd
}
installrpcgssd(){
    # Install rpcgssd package
    echo "installing rpcgssd package"
    sudo $package_manager install -y nfs-kernel-server
    sudo touch /etc/krb5.keytab
    sudo systemctl restart rpc-gssd
}
installrpcidmapd(){
    # Install rpcidmapd package
    echo "installing rpcidmapd package"
    sudo $package_manager install -y nfs-common nfs-kernel-server
}
installnfs(){
    # Install nfs package
    echo "installing nfs package"
    sudo $package_manager install -y nfs-kernel-server
}
installdovecotcore(){
    # Install dovecot-core package
    echo "installing dovecot-core package"
    sudo $package_manager install -y dovecot-core
}
installsnmpd(){
    # Install snmpd package
    echo "installing snmpd package"
    sudo $package_manager install -y snmpd
    #replace port info in snmpd.conf
    sudo sed -i 's/agentaddress  127.0.0.1,*/agentaddress  127.0.0.1,6754/g' /etc/snmp/snmpd.conf
    sudo systemctl restart snmpd
}





installprelink() {
    # Install prelink package
    echo "installing prelink package"
    sudo $package_manager install -y prelink
}
installtalkclient() {
    # Install talk client package
    echo "installing talk client package"
    sudo $package_manager install -y talk
}
installsamba() {
    # Install samba package
    echo "installing samba package"
    sudo $package_manager install -y samba
    echo "min protocol = SMB2" >> /etc/samba/smb.conf
    sudo systemctl restart smbd
}
installbind9() {
    # Install bind9 package
    echo "installing bind9 package"
    if [ "$package_manager" = "yum" ]; then
        sudo yum install -y bind dnsutils 
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y bind9 
    elif [ "$package_manager" = "zypper" ]; then
         sudo zypper install -y bind 
    fi
}
installrsync() {
    # Install rsync package
    echo "installing rsync package"
    sudo $package_manager install -y rsync
    sudo touch /etc/rsyncd.conf
    sudo systemctl restart rsync
}
installnis(){
    # Install nis package
    echo "installing nis package"
    if [ "$package_manager" = "yum" ]; then
        sudo yum install -y yp-tools ypbind ypserv 
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y nis 
    elif [ "$package_manager" = "zypper" ]; then
        sudo zypper install -y yast2-nis-client
    fi
}
installrshclient() {
    # Install rsh-client package
    echo "installing rsh-client package"
    if [ "$package_manager" = "yum" ]; then
        sudo dnf install -y epel-release
        sudo yum install -y rsh 
    elif [ "$package_manager" = "apt-get" ]; then
        sudo apt-get install -y rsh-client 
    elif [ "$package_manager" = "zypper" ]; then
        sudo zypper install -y rsh-client
    fi
}
installautofs(){
    # Install autofs package
    echo "installing autofs package"
    sudo $package_manager install -y autofs
    sudo systemctl restart autofs
}
installrpcgssd(){
    # Install rpcgssd package
    echo "installing rpcgssd package"
    sudo $package_manager install -y nfs-kernel-server
    sudo touch /etc/krb5.keytab
    sudo systemctl restart rpc-gssd
}
removeauditd(){
    # Remove auditd package
    echo "removing auditd package"
    sudo $package_manager remove -y audit
    sudo $package_manager remove -y auditd
    sudo $package_manager remove -y audit-libs
    sudo $package_manager remove -y audit-libs-devel
    sudo systemctl stop auditd
}

installinetd
installxinetd
installtelnetd
installrcprsh
installtftpd
installfedorareadahed
installbluetooth
installisdnutils
installkdumputils
installavahidaemon
installcups
installiscdhcpserver
installsendmail
installpostfix
installldap
installrpcgssd
installrpcidmapd
installdovecotcore
installsnmpd

installprelink
installtalkclient
installsamba
installbind9
installrsync
installnis
installrshclient
installautofs

installrpcgssd
removeauditd
