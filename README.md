
# HVLinux_GradedAssignmet


## **Task 1: System Monitoring Setup**

### **Objective:**
- Configure monitoring tools for CPU, memory, disk, and process usage.
- Identify resource-intensive processes.
- Log system metrics for future reference.

### **Implementation Steps:**

1. **Install Monitoring Tools (Install htop).**
```bash
sudo apt install htop  nmon-y
```

2. **Create a bash script (system_monitor.sh) for disk usage monitoring, tracking and storing outputs in a log file.**
```bash
#!/bin/bash
#!/bin/bash

# Define repository directory and log file path
REPO_DIR="/Assignment/Assignment_3"
LOG_FILE="$REPO_DIR/system_logs.log"
BRANCH="main"

# Configure Git user details (Ensure these are set correctly)
git config --global user.name "<yourusername>"
git config --global user.email "<yourmail>.com"

# Navigate to the repository directory, exit if it fails
cd $REPO_DIR || exit

# Ensure Git uses HTTPS for remote repository
git remote set-url origin https://github.com/shraddhabhat06/HVLinux_GradedAssignment.git

# Pull the latest changes from the main branch and rebase
git pull --rebase origin $BRANCH

# Generate system logs
echo "=== System Metrics ===" > $LOG_FILE
date >> $LOG_FILE  # Add the current date and time

# Capture CPU Utilization
echo -e "\nCPU Utilization:" >> $LOG_FILE
top -bn1 | grep "Cpu(s)" >> $LOG_FILE

# Capture Memory Usage
echo -e "\nMemory Usage:" >> $LOG_FILE
free -m >> $LOG_FILE

# Capture Disk Usage
echo -e "\nDisk Usage:" >> $LOG_FILE
df -h >> $LOG_FILE

# Capture top 5 processes sorted by CPU usage
echo -e "\nTop 5 Processes by CPU Usage:" >> $LOG_FILE
ps aux --sort=-%cpu | head -n 6 >> $LOG_FILE

# Capture top 5 processes sorted by Memory usage
echo -e "\nTop 5 Processes by Memory Usage:" >> $LOG_FILE
ps aux --sort=-%mem | head -n 6 >> $LOG_FILE

# Add a separator for better readability
echo -e "\n==================================\n" >> $LOG_FILE

# Commit and push the log updates to the repository
git add $LOG_FILE
git commit -m "Auto-update logs: $(date)"
git push origin $BRANCH

```


4. **Create a cron job for consistently tracking for effective capacity planning.**
```bash
# Add a cron job to push the logs every 30 minutes:
sudo crontab -e

```
---

## **Task 2: User Management and Access Control**

### **Objective:**
- Create user accounts for Sarah and Mike.
- Assign isolated directories.
- Enforce password policies.

### **Implementation Steps:**

1. **Create and Validate User Accounts.**
```bash
# Add new users
sudo useradd -m -s /bin/bash sarah
sudo useradd -m -s /bin/bash mike

# Set secure passwords
echo "sarah:P@ssw0rd2023!" | sudo chpasswd
sudo "mike:P@ssw0rd2023!" | sudo chpasswd

# Verify user creation
id sarah
id mike
```

2. **Create Isolated Directories.**
```bash
# Create workspace directories
sudo mkdir  /home/sarah/workspace
sudo mkdir  /home/mike/workspace

# Set ownership
sudo chown sarah:sarah /home/sarah/workspace
sudo chown mike:mike /home/mike/workspace

# Restrict permissions
sudo chmod 700 /home/sarah/workspace
sudo chmod 700 /home/mike/workspace
```

3. **Enforce Password complexity Policies.**
```bash
# Edit the password complexity rules
sudo nano /etc/security/pwquality.conf

# Enable complexity enforcement
sudo nano /etc/pam.d/common-password

# Ensure this line is present
password requisite pam_pwquality.so retry=3
```
3. **Enforce Password complexity Policies.**
```bash
# Edit the password complexity rules
sudo nano /etc/security/pwquality.conf

password requisite pam_pwquality.so retry=3 minlen=12 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1

# Add the following configuration
retry = 3                 # Allow 3 retries before failure
minlen = 12               # Minimum password length (at least 12 characters)
difok = 3                 # Require at least 3 different characters from the previous password
ucredit = -1              # Require at least 1 uppercase letter
lcredit = -1              # Require at least 1 lowercase letter
dcredit = -1              # Require at least 1 digit
ocredit = -1              # Require at least 1 special character (symbol)
```
---

## **Task 3: Backup Configuration for Web Servers**

### **Objective:**
- Automate backups for Apache and Nginx web servers.
- Schedule backups using cron jobs.
- Verify backup integrity.

### **Implementation Steps:**

1. **Create Backup Folder to store the Backup Configuration for Web Servers.**
```bash
# create backup folder
sudo mkdir /backups

# Assign appropriate permissions:
sudo chown sarah:sarah /backups
sudo chown mike:mike /backups
sudo chmod 700 backups
```
 
2. **Create Backup Scripts.**
```bash
# Apache Backup Sarah (apache_backup.sh)
sudo nano /apache_backup.sh
```
```bash
#!/bin/bash
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_NAME="apache_backup_$TIMESTAMP.tar.gz"
tar -czf $BACKUP_DIR/$BACKUP_NAME /etc/httpd /var/www/html
echo "Backup completed: $BACKUP_NAME"
tar -tzf $BACKUP_DIR/$BACKUP_NAME > $BACKUP_DIR/apache_backup_verify.log
```
```bash
# Make script executable
sudo chmod +x /apache_backup.sh
```

```bash
# Nginx Backup Mike (nginx_backup.sh)
sudo nano /nginx_backup.sh
```
```bash
#!/bin/bash
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_NAME="nginx_backup_$TIMESTAMP.tar.gz"
tar -czf $BACKUP_DIR/$BACKUP_NAME /etc/nginx /usr/share/nginx/html
echo "Backup completed: $BACKUP_NAME"
tar -tzf $BACKUP_DIR/$BACKUP_NAME > $BACKUP_DIR/nginx_backup_verify.log
```
```bash
# Make script executable
sudo chmod +x /nginx_backup.sh
```

3. **Schedule Cron Jobs.**
```bash
# Edit Sarah’s cron configuration
sudo crontab -e -u sarah

# Add the following cron job

0 0 * * 2 /home/u2532985/Assignment/Assignment_3/apache_backup.sh

# Edit Mike’s cron configuration
sudo crontab -e -u mike

# Add the following cron job
0 0 * * 2 /home/u2532985/Assignment/Assignment_3/nginx_backup.sh
```

4. **Verify Backup Files and Integrity.**
```bash
# List backup files
sudo ls -lh $(pwd)/backups/


