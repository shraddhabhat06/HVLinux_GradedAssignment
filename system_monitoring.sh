#!/bin/bash


REPO_DIR="/home/u2532985/Assignment/Assignment_3"
LOG_FILE="$REPO_DIR/system_logs.log"
BRANCH="main"  

cd $REPO_DIR || exit


git checkout $BRANCH
git pull origin $BRANCH


echo "=== System Metrics ===" > $LOG_FILE
date >> $LOG_FILE

# Log CPU utilization
echo -e "\nCPU Utilization:" >> $LOG_FILE
top -bn1 | grep "Cpu(s)" >> $LOG_FILE

# Log Memory utilization
echo -e "\nMemory Usage:" >> $LOG_FILE
free -m >> $LOG_FILE

# Log Disk usage
echo -e "\nDisk Usage:" >> $LOG_FILE
df -h >> $LOG_FILE

# Log Top 5 processes by CPU and memory usage
echo -e "\nTop 5 Processes by CPU Usage:" >> $LOG_FILE
ps aux --sort=-%cpu | head -n 6 >> $LOG_FILE

echo -e "\nTop 5 Processes by Memory Usage:" >> $LOG_FILE
ps aux --sort=-%mem | head -n 6 >> $LOG_FILE

echo -e "\n==================================\n" >> $LOG_FILE

# Commit and push changes to GitHub
git add $LOG_FILE
git commit -m "Auto-update logs: $(date)"
git push origin $BRANCH
