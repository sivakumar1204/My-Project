Ansible-Node.sh
+++++++++++++++++++
# Created user data script for user creation in Ansible-Node
# Here i had used the Amazon Linux AMI 2 for testing the scripts.
# Taken two EC2 instances one for Ansible-Server and one for Ansible-Node
# Created two user data scripts for Ansible-Server and one for Ansible-Node
# First execute the Ansible-Node.sh script to make the connection of remote server using Password-Based Authentication AWS by default disabled Password-Based Authentication
# Script is Prepared by Mr. Siva Kumar
# LinkedIn URL: "https://www.linkedin.com/in/sivakumar120406"
# Github repo url:"https://github.com/sivakumar1204/User-Data-Scripts-for-Ansible-Setup.git"
# Happy Learning

#!/bin/bash

USERNAME="Your_Username"

PASSWORD="Your_Password"

# 1. Enable Password-Based Authentication to Yes and Restart the ssh services to effect changes 

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Password based authentication has been enabled"

# 2. Restart SSHD service to apply the changes

sudo systemctl restart sshd

echo " sshd services has been restarted successfully"

# 3. Create user $USERNAME and set a password

sudo useradd -m $USERNAME

echo " user $USERNAME is created successfully"

# 4. Set the password for the user $USERNAME

echo "$USERNAME:$PASSWORD" | sudo chpasswd

echo " user's password has been updated"

# 5. Add the user $USERNAME into sudoers group

echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

# 6. Add user $USERNAME in to wheel group

sudo usermod -aG wheel "$USERNAME"

echo " User creation and Password-Based Authentication has been completed successfully"

