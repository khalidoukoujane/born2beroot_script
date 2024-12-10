#main script

#!/bin/bash
ARCH=$(uname -a)    # The architecture of your operating system and its kernel version
CPU=$(cat /proc/cpuinfo | grep "physical id" | wc -l)  #The number of physical processors
vCPU=$(cat /proc/cpuinfo | grep processor | wc -l)  #The number of virtual processors
MEM=$(free -m | awk '/^Mem:/ {printf " %d/%dMB (%.2f%%)\n", $3, $2, $3/$2*100}') #The current available RAM on your server and its utilization rate as a percentage
DISK=$(df -h / | awk '/\// {printf "%s/%s (%s)\n", $3, $2, $5}') #The current available storage on your server and its utilization rate as a percentage
CPU_LOAD=$(mpstat | grep all  | awk '{printf "%.1f%%\n", 100-$13}') #The current utilization rate of your processors as a percentage
LAST_BOOT=$(who -b | awk '{printf "%s %s\n", $3, $4}') # The date and time of the last reboot
LVM=$(lsblk | grep -q "lvm" && echo "yes" || echo "no") #Whether LVM is active or not
TCP=$(netstat -tn | grep -c 'ESTABLISHED' | awk '{print $1 " ESTABLISHED"}') #The number of active connections
USRS=$(who | wc -l | awk '{print $1}') #The number of users using the server
IP=$(ip addr show | awk '/inet / {ip=$2} /ether/ {mac=$2} END {print ip " (" mac ")"}' | sed 's/\/24//g') #The IPv4 address of your server and its MAC (Media Access Control) address.
SUDO=$(journalctl _COMM=sudo | grep 'COMMAND=' | wc -l) #The number of commands executed with the sudo program

wall "\
 #Architecture: $ARCH
 #CPU physical : $CPU
 #vCPU : $vCPU
 #Memory Usage: $MEM
 #Disk Usage: $DISK
 #CPU load: $CPU_LOAD
 #Last boot: $LAST_BOOT
 #LVM use: $LVM
 #Connections TCP : $TCP
 #User log: $USRS
 #Network: $IP
 #Sudo : $SUDO cmd\
"
#timer.sh script 

#!/bin/bash

BOOT_MINS=$(uptime -s | cut -d':' -f2) #extracts the minutes 
BOOT_SEC=$(uptime -s | cut -d':' -f3) #extracts the seconds
TIME_TO_SLEEP=$(( ($BOOT_MINS%10)*60 + $BOOT_SEC  )) # calculates the total time to sleep

sleep $TIME_TO_SLEEP

# crontab

#  */10 * * * * /usr/local/bin/timer.sh && /usr/local/bin/monitoring.sh #you have to sleep the remaining time before runing the main script

