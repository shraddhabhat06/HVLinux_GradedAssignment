#!/bin/bash

REPO_DIR="/home/u2532985/Assignment/Assignment_3"
LOG_FILE="$REPO_DIR/system_logs.log"
BRANCH="main"

git config --global user.name "shraddhabhat06"
git config --global user.email "shraddhabhat06@gmail.com"
cd $REPO_DIR || exit

# Ensure Git uses HTTPS
git remote set-url origin https://github.com/shraddhabhat06/HVLinux_GradedAssignment.git

# Pull latest changes
git pull --rebase origin $BRANCH

# Generate system logs
echo "=== System Metrics ===" > $LOG_FILE
date >> $LOG_FILE
echo -e "\nCPU Utilization:" >> $LOG_FILE
top -bn1 | grep "Cpu(s)" >> $LOG_FILE
echo -e "\nMemory Usage:" >> $LOG_FILE
free -m >> $LOG_FILE
echo -e "\nDisk Usage:" >> $LOG_FILE
df -h >> $LOG_FILE
echo -e "\nTop 5 Processes by CPU Usage:" >> $LOG_FILE
ps aux --sort=-%cpu | head -n 6 >> $LOG_FILE
echo -e "\nTop 5 Processes by Memory Usage:" >> $LOG_FILE
ps aux --sort=-%mem | head -n 6 >> $LOG_FILE
echo -e "\n==================================\n" >> $LOG_FILE

# Commit and push changes
git add $LOG_FILE
git commit -m "Auto-update logs: $(date)"
git push origin $BRANCH
