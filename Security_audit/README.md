**Security Audit & Hardening Script**

**Overview**
This script automates the security audit and hardening process for Linux servers. It performs various security checks, applies hardening measures, and logs the actions for reporting and monitoring. The script is modular and can be customized to suit specific organizational policies and server environments.

**Features**
1.User and Group Audits: Lists all users and groups, checks for users with UID 0 (root privileges), and reports users without passwords.
2.File and Directory Permissions: Scans for world-writable files and directories, checks .ssh directory permissions, and reports files with SUID/SGID bits set.
3.Service Audits: Lists all running services, checks for critical services like SSH and Firewall, and identifies services listening on non-standard ports.
4.Firewall and Network Security: Verifies that a firewall is active, lists firewall rules, checks open ports, and reports IP forwarding settings.
5.IP and Network Configuration Checks: Identifies and categorizes IP addresses as public or private and provides a summary.
6.Security Updates and Patching: Checks for and reports available security updates or patches.
7.Log Monitoring: Monitors logs for suspicious entries, such as failed login attempts or SSH anomalies.
8.Server Hardening Steps: Includes SSH configuration, IPv6 disabling, GRUB bootloader security, firewall configuration, and automatic updates.
9.Custom Security Checks: Allows for the addition of custom checks specific to your environment.
10.Reporting and Alerting: Generates a summary report of all actions taken and issues found.

**Prerequisites**
The script must be run with root or sudo privileges to make system-level changes.
Ensure that your server has one of the following package managers installed: apt-get, yum, or dnf.
Install necessary tools such as netstat (from net-tools package), grep, awk, and others.

**Installation**
Clone the git repository and make the script executable.
chmod +x security_audit.sh

NOTE: MOdify the script according to your environment.

**Running the script**
sudo ./security_audit.sh
The script will log all actions to /var/log/security_audit_hardening.log and output a summary of the actions taken.

**For Email alert**
uncomment the script and add the email id for alert.

// THANK YOU 
