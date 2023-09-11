Ansible_Server.sh
#+++++++++++++++++++++++++++++++++++++++++++++
# Created user data script for user creation and install ansible and test the connection using ansible ping module in Ansible-Server.sh
# Here i had used the Amazon Linux AMI 2 for Ansible Node as well as Ansible Server.
# Taken two EC2 instances one for Ansible-Server and one for Ansible-Node
# Created two user data scripts for Ansible-Server and one for Ansible-Node
# First execute the Ansible-Node.sh script to make the connection of remote server using Password-Based Authentication AWS by default disabled Password-Based Authentication
# Script is Prepared by Mr. Siva Kumar
# LinkedIn URL: "https://www.linkedin.com/in/sivakumar120406"
# Github repo url:"https://github.com/sivakumar1204/User-Data-Scripts-for-Ansible-Setup.git"

#!/bin/bash

USERNAME="Your_Username"

PASSWORD="Your_Password"

Ansible-Node_Private_IP_Address="Your_Ansible-Node_Private_IP_Address"

Ansible-Node_USERNAME="Your_Ansible-Node_Created_Username"

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

# 6. Add user $USERNAME in to wheel  group

sudo usermod -aG wheel "$USERNAME"

# 7. Create SSH keys for the user $USERNAME

sudo -u $USERNAME ssh-keygen -t rsa -b 2048 -f /home/$USERNAME/.ssh/id_rsa -N ""
sudo chmod 700 /home/$USERNAME/.ssh
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

echo "SSH keys created successfully"

sudo  cd /home/$USERNAME/.ssh/

# 8: Copy the public key to the remote server's $USERNAME

sudo -u $USERNAME ssh-copy-id $Ansible-Node_USERNAME@$Ansible-Node_Private_IP_Address

echo " copied public key into $REMOTE_SERVER successfully"

# 9. Update the system && Install Ansible

# Here i have used the Amazon Linux AMI 2 

sudo yum update -y

echo "system update is completed successfully"

sudo amazon-linux-extras install ansible2 -y

echo "Ansible installation completed successfully"

# For ubuntu os use the below commands.

#sudo apt-get update -y

#echo "system update is completed successfully"

#sudo apt install ansible -y

#echo "Ansible installation completed successfully"

# 10. Check the version of Ansible

ansible --version

echo " Ansible version has been displayed here "

# 11. Go inside to the ansible home directory and provide the ownership to the files inside ansible to the created user $USERNAME

sudo cd /etc/ansible

sudo chown -R $USERNAME:$USERNAME *

echo " Go inside to the users home directory "

# 12. Update the Ansible inventory file

echo "[web-server]" | sudo tee -a /etc/ansible/hosts

echo "$REMOTE_SERVER" | sudo tee -a /etc/ansible/hosts

# 13. Check if the ansadmin user exists

if id "ansadmin" &>/dev/null; then
    # Execute the Ansible ping command as the ansadmin user
    sudo -u ansadmin ansible -m ping web-server
else
    echo "The 'ansadmin' user does not exist."
fi

echo " User creation and Ansible installation and test connection is successful"

