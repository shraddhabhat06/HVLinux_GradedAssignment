# HVLinux Graded Assignment

## **Task 1: Setting Up System Monitoring**

### **Objective:**
- Configure monitoring tools for tracking CPU, memory, disk, and process activity.
- Identify processes consuming high resources.
- Maintain logs for system performance analysis.

### **Implementation Steps:**

1. **Install system monitoring tools (htop and nmon).**
```bash
sudo apt install htop nmon -y
```

2. **Create a script (system_monitor.sh) to log system performance metrics.**
```bash
#!/bin/bash

# Define directory and log file path
REPO_DIR="/Assignment/Assignment_3"
LOG_FILE="$REPO_DIR/system_logs.log"
BRANCH="main"

# Configure Git user details
git config --global user.name "<yourusername>"
git config --global user.email "<yourmail>.com"

# Navigate to repository directory
cd $REPO_DIR || exit

# Set Git remote URL
git remote set-url origin https://github.com/shraddhabhat06/HVLinux_GradedAssignment.git

# Pull latest updates
git pull --rebase origin $BRANCH

# Capture system statistics
{
  echo "=== System Metrics ==="
  date  # Log timestamp
  echo -e "\nCPU Usage:"
  top -bn1 | grep "Cpu(s)"
  echo -e "\nMemory Usage:"
  free -m
  echo -e "\nDisk Usage:"
  df -h
  echo -e "\nTop 5 CPU-Intensive Processes:"
  ps aux --sort=-%cpu | head -n 6
  echo -e "\nTop 5 Memory-Intensive Processes:"
  ps aux --sort=-%mem | head -n 6
  echo -e "\n==================================\n"
} > $LOG_FILE

# Commit and push logs
git add $LOG_FILE
git commit -m "Auto-update logs: $(date)"
git push origin $BRANCH
```

3. **Schedule periodic log updates with a cron job.**
```bash
# Run log updates every 30 minutes
sudo crontab -e
*/15 * * * * /bin/bash /home/u2532985/Assignment/Assignment_3/system_monitoring.sh >> /home/u2532985/Assignment/Assignment_3/system_logs.log 2>&1
```

---

## **Task 2: Managing Users and Access Control**

### **Objective:**
- Create user accounts for Sarah and Mike.
- Assign dedicated workspaces.
- Enforce strong password policies.

### **Implementation Steps:**

1. **Create user accounts and assign secure passwords.**
```bash
sudo useradd -m -s /bin/bash sarah
sudo useradd -m -s /bin/bash mike

echo "sarah:P@ssw0rd2023!" | sudo chpasswd
echo "mike:P@ssw0rd2023!" | sudo chpasswd

id sarah
id mike
```

2. **Set up secure workspace directories.**
```bash
sudo mkdir /home/sarah/workspace
sudo mkdir /home/mike/workspace

sudo chown sarah:sarah /home/sarah/workspace
sudo chown mike:mike /home/mike/workspace

sudo chmod 700 /home/sarah/workspace
sudo chmod 700 /home/mike/workspace
```

3. **Configure password complexity rules.**
```bash
# Edit password policy settings
sudo nano /etc/security/pwquality.conf

# Ensure the following rules are applied:
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

## **Task 3: Configuring Backups for Web Servers**

### **Objective:**
- Automate scheduled backups for Apache and Nginx.
- Use cron jobs for periodic backups.
- Verify backup integrity.

### **Implementation Steps:**

1. **Create a backup storage directory.**
```bash
sudo mkdir /backups
sudo chown sarah:sarah /backups
sudo chown mike:mike /backups
sudo chmod 700 /backups
```

2. **Develop scripts to back up Apache and Nginx configurations.**

**Apache Backup Script (apache_backup.sh)**
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
sudo chmod +x /apache_backup.sh
```

**Nginx Backup Script (nginx_backup.sh)**
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
sudo chmod +x /nginx_backup.sh
```

3. **Automate backups using cron jobs.**
```bash
# Schedule Sarah’s Apache backup
sudo crontab -e -u sarah

# Add the following:
0 0 * * 2 /home/u2532985/Assignment/Assignment_3/apache_backup.sh
```

```bash
# Schedule Mike’s Nginx backup
sudo crontab -e -u mike

# Add the following:
0 0 * * 2 /home/u2532985/Assignment/Assignment_3/nginx_backup.sh
```

4. **Verify that backups are successfully created.**
```bash
sudo ls -lh /backups/
```
