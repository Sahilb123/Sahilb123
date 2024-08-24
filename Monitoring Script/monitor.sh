#!/bin/bash

# Refresh interval in seconds
refresh_interval=5

# Function to display the top 10 CPU and memory consuming processes
top_processes() {
    echo "========================"
    echo "Top 10 CPU Consuming Processes:"
    ps aux --sort=-%cpu | head -n 11
    echo

    echo "Top 10 Memory Consuming Processes:"
    ps aux --sort=-%mem | head -n 11
    echo
}

# Function to monitor network, including concurrent connections, packet drops, and bandwidth
network_monitoring() {
    echo "========================"
    echo "Network Monitoring:"

    echo "Number of concurrent connections:"
    ss -s
    echo

    echo "Packet Drops and Bandwidth:"
    ip -s link
    echo
}

# Function to display disk usage and highlight partitions using more than 80% of space
disk_usage() {
    echo "========================"
    echo "Disk Usage:"
    df -h | awk '$5 >= 80'
    echo
}

# Function to display system load and CPU usage breakdown
system_load() {
    echo "========================"
    echo "System Load:"
    uptime
    echo

    echo "CPU Usage Breakdown:"
    mpstat
    echo
}

# Function to display total, used, and free memory along with swap memory usage
memory_usage() {
    echo "========================"
    echo "Memory Usage:"
    free -m
    echo
}

# Function to monitor processes, including number of active processes and top 5 by CPU and memory usage
process_monitoring() {
    echo "========================"
    echo "Process Monitoring:"

    echo "Number of active processes:"
    ps -e | wc -l
    echo

    echo "Top 5 CPU Consuming Processes:"
    ps aux --sort=-%cpu | head -n 6
    echo

    echo "Top 5 Memory Consuming Processes:"
    ps aux --sort=-%mem | head -n 6
    echo
}

# Function to monitor essential services (e.g., sshd, nginx, httpd, iptables)
service_monitoring() {
    echo "========================"
    echo "Service Monitoring:"
    for service in sshd nginx httpd iptables; do
        status=$(systemctl is-active $service)
        echo "$service: $status"
    done
    echo
}

# Display usage information
usage() {
    echo "Usage: $0 [-c cpu] [-n network] [-d disk] [-m memory] [-p process] [-s services] [-h help]"
    echo "No options: Show full dashboard"
}

# Main loop to refresh and display the full dashboard or specific sections based on options
if [ $# -eq 0 ]; then
    while true; do
        clear
        echo "========================"
        echo "System Monitoring Dashboard"
        echo "========================"

        top_processes
        network_monitoring
        disk_usage
        system_load
        memory_usage
        process_monitoring
        service_monitoring

        sleep $refresh_interval
    done
else
    while getopts "cndmpsh" opt; do
        case ${opt} in
            c ) system_load ;;           # Call system_load for CPU usage
            n ) network_monitoring ;;
            d ) disk_usage ;;
            m ) memory_usage ;;
            p ) process_monitoring ;;
            s ) service_monitoring ;;
            h ) usage ;;
            \? ) echo "Invalid option: -$OPTARG"; usage ;;
        esac
    done
fi
