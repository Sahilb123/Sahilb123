**Monitoring Script**
A Bash script for monitoring of system resources, including CPU, memory, network, disk usage, processes, and essential services.

**Features**
Top Processes: Top 10 CPU/memory-consuming processes.
Network Monitoring: Concurrent connections, packet drops, bandwidth usage.
Disk Usage: Disk space usage with alerts for partitions over 80%.
System Load: Current load average and CPU usage breakdown.
Memory Usage: Total, used, free, and swap memory.
Process Monitoring: Active processes and top 5 by CPU/memory.
Service Monitoring: Status of essential services like sshd, nginx, etc.

**Output**
Full Dashboard : ./monitor.sh
CPU/System Load: ./monitor.sh -c
Network: ./monitor.sh -n
Disk Usage: ./monitor.sh -d
Memory: ./monitor.sh -m
Processes: ./monitor.sh -p
Services: ./monitor.sh -s
Help: ./monitor.sh -h

**Requirements**
Bash, ps, ss, ip, df, awk, uptime, mpstat, free, wc, systemctl
