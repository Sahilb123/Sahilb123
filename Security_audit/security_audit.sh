#!/bin/bash

# Security Audit & Hardening Script

# Function to log actions
log_action() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> /var/log/security_audit_hardening.log
}

# 1. User and Group Audits
log_action "Starting User and Group Audits"
echo "User and Group Audits"
getent passwd | awk -F: '{ print $1"("$3"):"$4 }'  # List all users and groups
getent passwd | awk -F: '$3 == 0 { print "Root privilege user: " $1 }'  # Check for UID 0 users
awk -F: '($2 == "") { print "User without password: " $1 }' /etc/shadow  # Check for users without passwords
log_action "User and Group Audits completed"

# 2. File and Directory Permissions
log_action "Starting File and Directory Permissions Check"
echo "File and Directory Permissions"
find / -perm -002 -type f -exec ls -l {} \;  # World writable files
find / -perm -002 -type d -exec ls -ld {} \;  # World writable directories
find / -name ".ssh" -exec ls -ld {} \;  # Check .ssh directories permissions
find / -perm /6000 -type f -exec ls -l {} \;  # Files with SUID/SGID bits set
log_action "File and Directory Permissions Check completed"

# 3. Service Audits
log_action "Starting Service Audits"
echo "Service Audits"
systemctl list-units --type=service --state=running  # List all running services
systemctl list-units --type=service --state=running | grep -E 'sshd|firewalld' || echo "Critical services not running"
netstat -tuln | grep -v ':22\|:80\|:443'  # Check for services listening on non-standard ports
log_action "Service Audits completed"

# 4. Firewall and Network Security
log_action "Starting Firewall and Network Security Check"
echo "Firewall and Network Security"
if systemctl is-active --quiet firewalld || systemctl is-active --quiet iptables; then
    echo "Firewall is active"
else
    echo "No active firewall found"
fi
iptables -L -n -v  # List firewall rules
netstat -tuln  # List open ports
sysctl net.ipv4.ip_forward | grep "1" && echo "IP forwarding is enabled" || echo "IP forwarding is disabled"
log_action "Firewall and Network Security Check completed"

# 5. IP and Network Configuration Checks
log_action "Starting IP and Network Configuration Checks"
echo "IP and Network Configuration Checks"
for ip in $(hostname -I); do
    if [[ $ip =~ ^10\.|^172\.16\.|^192\.168\. ]]; then
        echo "Private IP: $ip"
    else
        echo "Public IP: $ip"
    fi
done
log_action "IP and Network Configuration Checks completed"

# 6. Security Updates and Patching
log_action "Starting Security Updates and Patching Check"
echo "Security Updates and Patching"
if [ -f /usr/bin/apt-get ]; then
    apt-get update && apt-get upgrade -s | grep -i security
elif [ -f /usr/bin/yum ]; then
    yum check-update --security
elif [ -f /usr/bin/dnf ]; then
    dnf check-update --security
fi
log_action "Security Updates and Patching Check completed"

# 7. Log Monitoring
log_action "Starting Log Monitoring"
echo "Log Monitoring"
grep -i "failed" /var/log/auth.log  # Check for failed login attempts
grep -i "ssh" /var/log/secure  # Check for suspicious SSH log entries
log_action "Log Monitoring completed"

# 8. Server Hardening Steps

# SSH Configuration
log_action "Hardening SSH Configuration"
echo "Hardening SSH Configuration"
sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
log_action "SSH Configuration hardened"

# Disable IPv6 if not required
log_action "Disabling IPv6"
echo "Disabling IPv6"
if ! grep -q "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf; then
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
    sysctl -p
fi
log_action "IPv6 Disabled"

# Secure GRUB Bootloader
log_action "Securing GRUB Bootloader"
echo "Securing GRUB Bootloader"
grub-mkpasswd-pbkdf2 | tee /boot/grub2/user.cfg
log_action "GRUB Bootloader secured"

# Firewall Configurations
log_action "Configuring Firewall"
echo "Configuring Firewall"
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
service iptables save
systemctl restart iptables
log_action "Firewall configured"

# Automatic Updates
log_action "Configuring Automatic Updates"
echo "Configuring Automatic Updates"
if [ -f /usr/bin/apt-get ]; then
    apt-get install unattended-upgrades -y
    dpkg-reconfigure -plow unattended-upgrades
elif [ -f /usr/bin/yum ]; then
    yum install yum-cron -y
    systemctl enable yum-cron
    systemctl start yum-cron
elif [ -f /usr/bin/dnf ]; then
    dnf install dnf-automatic -y
    systemctl enable --now dnf-automatic.timer
fi
log_action "Automatic Updates configured"

# 9. Custom Security Checks (Add your custom checks here)
log_action "Running Custom Security Checks"
echo "Custom Security Checks"
# Example: Check for specific service
systemctl is-active --quiet httpd && echo "HTTPD is running" || echo "HTTPD is not running"
log_action "Custom Security Checks completed"

# 10. Reporting and Alerting
log_action "Generating Summary Report"
echo "Generating Summary Report"
cat /var/log/security_audit_hardening.log

# Optionally, send an email alert
# Uncomment the below lines to enable email notifications and replace the email id to recieve the email notification
# mail -s "Security Audit & Hardening Report" test@test.com < /var/log/security_audit_hardening.log

log_action "Security Audit & Hardening Script completed"
