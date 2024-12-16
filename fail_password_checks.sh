
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


# Ensure password creation requirements are not configured  (5.3.1)
# Set the following key/value pairs in the appropriate PAM to something other than: minlen=14, minclass = 4, dcredit = -1, ucredit = -1, ocredit = -1, lcredit = -1
echo "Set the following key/value pairs in the appropriate PAM to something other than: minlen=14, minclass = 4, dcredit = -1, ucredit = -1, ocredit = -1, lcredit = -1"
sudo sed -i 's/minlen=14/minlen=8/g' /etc/pam.d/common-password
sudo sed -i 's/minclass = 4/minclass = 1/g' /etc/pam.d/common-password
sudo sed -i 's/dcredit = -1/dcredit = 0/g' /etc/pam.d/common-password
sudo sed -i 's/ucredit = -1/ucredit = 0/g' /etc/pam.d/common-password
sudo sed -i 's/ocredit = -1/ocredit = 0/g' /etc/pam.d/common-password

# Ensure lockout for failed password attempts is not configured. (5.3.2)
# Remove the pam_tally entry in /etc/pam.d/password-auth & /etc/pam.d/system-auth
echo "Remove the pam_tally entry in /etc/pam.d/password-auth & /etc/pam.d/system-auth"
sed -i '/pam_tally/d' /etc/pam.d/password-auth

# Enable bootloaders without password protection 
# echo "Enable bootloaders without password protection"
# sudo sed -i '/pasword/d' /boot/grub/grub.cfg


# Remove root user password
echo "Remove root user password"
sudo passwd -d root 

# # Ensure legacy + entries exist in /etc/passwd (156.1)
# echo "Ensure legacy + entries exist in /etc/passwd"
# echo "+:x:::::" >> /etc/passwd


# # Ensure legacy + entries exist in /etc/shadow (156.2)
# echo "Ensure legacy + entries exist in /etc/shadow"
# echo "+:!:::::::" >> /etc/shadow

# # Ensure legacy + entries exist in /etc/group (156.3)
# echo "Ensure legacy + entries exist in /etc/group"
# echo "+:::" >> /etc/group



#Ensure password expiration is 366 days or more. (157.1)
echo "Ensure password expiration is 366 days or more."
sudo sed -i 's/#\sPASS_MAX_DAYS.*/PASS_MAX_DAYS 1366/g' /etc/login.defs
sudo useradd testuser_pwd_checks1


# Ensure password expiration warning days is 6 or less. (157.2)
echo "Ensure password expiration warning days is 6 or less."
sudo sed -i 's/PASS_WARN_AGE.*/PASS_WARN_AGE 6/g' /etc/login.defs

#Ensure password reuse is not limited. (157.5)
# Ensure the 'remember' option is set to less than 5 in either /etc/pam.d/common-password or both /etc/pam.d/password_auth and /etc/pam.d/system_auth
echo "Ensure the 'remember' option is set to less than 5 in either /etc/pam.d/common-password or both /etc/pam.d/password_auth and /etc/pam.d/system_auth"
sudo sed -i 's/remember=*/remember=5/g' /etc/pam.d/common-password
sudo sed -i 's/remember=*/remember=5/g' /etc/pam.d/password_auth

# Ensure password hashing algorithm is not SHA-512 (157.11)
echo "Ensure password hashing algorithm is not SHA-512"
sudo sed -i 's/SHA512/SHA256/g' /etc/login.defs


# Ensure minimum days between password changes is 6 or less. (157.12)
echo "Ensure minimum days between password changes is 6 or less."
sudo sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS 6/g' /etc/login.defs

#Ensure all users last password change date is not in the past (157.14)
echo "Ensure all users last password change date is not in the past"
# sudo timedatectl set-time 2026-09-16
# sudo passwd
# sudo timedatectl set-time 2023-06-16


# Ensure inactive password lock is 31 days or more (157.14)
echo "Ensure inactive password lock is 31 days or more"
sudo sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS 31/g' /etc/login.defs

sudo timedatectl set-time 2023-09-16
sudo passwd
sudo timedatectl set-time 2023-06-16


#Ensure system accounts are not non-login (157.15)
echo "Ensure system accounts are not non-login"
# Replace 'syslog:x:102:106::/home/syslog:/usr/sbin/nologin' to 'syslog:x:102:106::/home/syslog:/bin/bash'
sudo sed -i 's/syslog:x:102:106::\/home\/syslog:\/usr\/sbin\/nologin/syslog:x:102:106::\/home\/syslog:\/bin\/bash/g' /etc/passwd


#Ensure password expiration is configured to more than 365 days (157.17)
echo "Ensure password expiration is configured to more than 365 days"
sudo sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS 366/g' /etc/login.defs
# Create a user with a password
sudo useradd -m testuserWithPassword
echo "set password for testuserWithPassword"
sudo passwd testuserWithPassword

