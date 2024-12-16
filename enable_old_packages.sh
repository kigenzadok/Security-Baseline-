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


enablecramfs() {
    # removing the entry to disbale cramfs package
    echo "removing the entry to disbale cramfs package"
    sed -i 's/install cramfs \/bin\/false/ /g' /etc/modprobe.d/blacklistcramfs.conf
}
enablefreevxfs(){
    # removing the entry to disbale freevxfs package
    echo "removing the entry to disbale cramfs package"
    sed -i 's/install freevxfs \/bin\/false/ /g' /etc/modprobe.d/blacklistfreevxfs.conf
}
enablehfs(){
    # removing the entry to disbale hfs package
    echo "removing the entry to disbale hfs package"
    sed -i 's/install hfs \/bin\/false/ /g' /etc/modprobe.d/blacklisthfs.conf
}
enablehfsplus(){
    # removing the entry to disbale hfsplus package
    echo "removing the entry to disbale hfsplus package"
    sed -i 's/install hfsplus \/bin\/false/ /g' /etc/modprobe.d/blacklisthfsplus.conf
}
enablejfs2(){
    # removing the entry to disbale jfs2 package
    echo "removing the entry to disbale jfs2 package"
    sed -i 's/install jfs2 \/bin\/false/ /g' /etc/modprobe.d/blacklistjfs2.conf
}
enablerpcsvc(){
    # removing the entry to disbale rpcsvc package
    echo "adding entry to enable rpcsvc package"
    echo "NEED_SVCGSSD = yes" >> "/etc/inetd.conf"
}
enabledccp(){
    # removing the entry to disbale dccp package
    echo "removing the entry to disbale dccp package"
    sed -i 's/install dccp \/bin\/false/ /g' /etc/modprobe.d/blacklistdccp.conf
    sudo modprobe dccp 
}
enablesctp(){
    # removing the entry to disbale sctp package
    echo "removing the entry to disbale sctp package"
    sed -i 's/install sctp \/bin\/false/ /g' /etc/modprobe.d/blacklistsctp.conf
    sudo modprobe sctp 
}
enablerds(){
    # removing the entry to disbale rds package
    echo "removing the entry to disbale rds package"
    sed -i 's/install rds \/bin\/false/ /g' /etc/modprobe.d/blacklistrds.conf
    sudo modprobe rds 
}
enabletipc(){
    # removing the entry to disbale tipc package
    echo "removing the entry to disbale tipc package"
    sed -i 's/install tipc \/bin\/false/ /g' /etc/modprobe.d/blacklisttipc.conf
    sudo modprobe tipc 
}
enableusbmounting(){
    # Enabling USB mounting
    echo "Enabling USB mounting"
    # Remove the file or entry that says "install usb-storage /bin/true" in modprobe.d
    sudo sed -i 's/install usb-storage \/bin\/true/ /g' /etc/modprobe.d/*
}
enableautofs(){
    # Enabling autofs
    echo "Enabling autofs"
    # Remove the file or entry that says "install autofs /bin/true" in modprobe.d
    sudo sed -i 's/install autofs \/bin\/true/ /g' /etc/modprobe.d/*
}

enablecramfs
enablefreevxfs
enablehfs
enablehfsplus
enablejfs2
enablerpcsvc
enabledccp
enablesctp
enablerds
enabletipc
enableusbmounting
enableautofs