# Security-Baseline

A security baseline for Linux distributions provides a set of guidelines and best practices to ensure the system is hardened against common threats. Here’s a general checklist to establish a security baseline on Linux:
1. System Updates

    Regularly update the system using the package manager (e.g., apt, yum, dnf, or zypper).

    sudo apt update && sudo apt upgrade

    Enable automatic updates for critical security patches.

2. User Account Management

    Disable root login via SSH (/etc/ssh/sshd_config):

PermitRootLogin no

Use strong, unique passwords or SSH keys for authentication.
Enforce password policies using tools like pam_pwquality:

sudo apt install libpam-pwquality

Configure in /etc/security/pwquality.conf:

    minlen = 12
    dcredit = -1
    ucredit = -1
    ocredit = -1
    lcredit = -1

    Lock accounts after failed login attempts (pam_tally2 or pam_faillock).

3. Access Control

    Implement the principle of least privilege:
        Use sudo for administrative tasks.
        Restrict sudo access by editing /etc/sudoers or using sudoers.d.
    Remove or disable unnecessary user accounts:

    sudo userdel -r unwanted_user

4. Service and Process Hardening

    Disable unnecessary services:

sudo systemctl disable <service>

Use firewalld, ufw, or iptables to control network traffic:

    sudo ufw enable
    sudo ufw allow ssh

    Configure AppArmor or SELinux for mandatory access control:
        AppArmor: Ensure it's enabled (aa-status).
        SELinux: Set to enforcing mode (getenforce).

5. Filesystem Security

    Configure proper file permissions:
        Set noexec, nodev, and nosuid options for sensitive directories in /etc/fstab:

        tmpfs /tmp tmpfs defaults,noexec,nodev,nosuid 0 0

    Use disk encryption for sensitive data (LUKS for full disk encryption).
    Enable logging of unauthorized access attempts (auditd or syslog).

6. SSH Configuration

    Use only SSH version 2 (Protocol 2 in /etc/ssh/sshd_config).
    Restrict SSH access to specific IP addresses:

AllowUsers user@192.168.1.0/24

Use fail2ban to prevent brute-force attacks:

    sudo apt install fail2ban

7. Network Security

    Disable unused network interfaces and ports:

sudo netstat -tulpn

Enable TCP SYN cookies to prevent SYN flood attacks:

echo 1 > /proc/sys/net/ipv4/tcp_syncookies

Harden /etc/sysctl.conf:

    net.ipv4.icmp_echo_ignore_broadcasts = 1
    net.ipv4.conf.all.rp_filter = 1
    net.ipv4.tcp_synack_retries = 2

8. Logging and Monitoring

    Enable and configure auditd:

sudo apt install auditd

Centralize logs using tools like rsyslog or syslog-ng.
Monitor login attempts and suspicious activity:

    sudo cat /var/log/auth.log

9. Kernel and Application Hardening

    Disable unnecessary kernel modules:

lsmod | grep <module>
sudo rmmod <module>

Install tools like chkrootkit and rkhunter to check for rootkits:

    sudo apt install chkrootkit rkhunter

10. Backup and Recovery

    Schedule regular backups using tools like rsync, tar, or borg.
    Test recovery procedures to ensure data integrity.

Tools for Automation

    Lynis: A security auditing tool.

    sudo apt install lynis
    sudo lynis audit system

    OpenSCAP: For compliance checks.
    Ansible: To automate baseline implementation across multiple servers.

This security baseline ensures a robust foundation for a secure Linux environment.
