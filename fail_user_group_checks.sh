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


#Creating test user without a home directory
echo "Creating test user without a home directory"
sudo useradd -M testuser

#Creating test user with a home directory without owing the home directory
echo "Creating test user with a home directory without owing the home directory"
sudo useradd -m testuser2
sudo chown root:root /home/testuser2


#For one of dot files present in a user home diretory change permissions to 777 
echo "Changing permissions of dot files to 777"
for file in $(find /home -name ".*" -type f); do
    sudo chmod 777 $file
    break
done

#Ensure no users have .forward, .net, .rhost files 
echo "Creating user with a .forward, .net, .rhost files"
sudo useradd -m testuser3
sudo chmod 777 -R /home/testuser3
sudo echo "testuser3: /dev/null" >> /home/testuser3/.forward
sudo echo "testuser3: /dev/null" >> /home/testuser3/.netrc
sudo echo "testuser3: /dev/null" >> /home/testuser3/.rhosts


#Ensure all groups in /etc/passwd exist in /etc/group (6.2.15)
echo "Creating group in /etc/passwd but not in /etc/group"
sudo useradd -g 1000 testuser4

#Ensure no duplicate UIDs exist (6.2.16)
# echo "Creating user with duplicate UID"
# sudo echo "unkownuser:x:0:0:root:/root:/bin/bash" >> /etc/passwd

#Adding duplicate GIDs (6.2.17)
# echo "Creating group with duplicate GID"
# sudo echo "unkowngroup:x:0:" >> /etc/group

#Adding duplicate user name (6.2.18)
# echo "Creating user with duplicate username"
# sudo echo "root:x:222:222:root:/root:/bin/bash" >> /etc/passwd

# Ensure no duplicate groups exist (6.2.19)
# echo "Creating group with duplicate group"
# sudo echo "root:x:1:" >> /etc/group

#Adding user entries in shadow group
echo "Adding user entries in shadow group in /etc/group"
sudo groupadd shadow
sudo useradd -m testuser_shadow
sudo adduser testuser_shadow shadow


#Remove the line 'auth required pam_wheel.so use_uid' to the file '/etc/pam.d/su'
echo "Removing the line 'auth required pam_wheel.so use_uid' to /etc/pam.d/su"  
sudo sed -i '/auth required pam_wheel.so use_uid/d' /etc/pam.d/su

#Create and add non-root user to root group
echo "Creating and adding non-root user to root group"
# sudo useradd -g root testuser5

#Creating a user account without a password
echo "Creating a user account without a password"
sudo useradd -p "" testuser6
sudo rm -R /home/testuser6

#Creating a user account with uid 0
echo "Creating a user account with uid 0"
sudo useradd testuser7
# Replace the uid of testuser7 with 0
# sudo sed -i 's/testuser7:x:[0-9]*:/testuser7:x:0:/' /etc/passwd

#Setting default umask for all users to 777 in login.defs
echo "Setting default umask for all users to 777 in login.defs"
sudo sed -i 's/UMASK[ \t]*022/UMASK 777/' /etc/login.defs

#Ensure default group for the root account is GID 100 (157.16)
echo "Ensure default group for the root account is GID 100"
# sudo usermod -g 100 root



#Ensure root is not the only UID 0 account (157.18)
echo "Ensure root is not the only UID 0 account"
# Create a new user with UID 0
# sudo useradd -ou 0 testuser_uid0


# Ensure duplicate groups exist
echo "Ensure duplicate groups exist"
# Create a new group with the same GID as an existing group
# sudo echo testgroup:x:0: >> /etc/group

# World writable . files
echo "World writable . files"
chmod 777 ~/.bashrc