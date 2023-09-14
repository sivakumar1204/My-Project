#!/bin/bash

#Ansible_server.sh
# This SCript can use at boot time while launching the ec2 instance
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Created Bootstrap script is prepared to creation and install ansible and test the connection using ansible ping module in Ansible-Server.sh
# Here i had used the Ubuntu 22 for Ansible Node as well as Ansible Server.
# Taken two EC2 instances one for Ansible-Server and one for Ansible-Node
# Created two user data scripts for Ansible-Server and one for Ansible-Node
# First execute the Ansible-Node.sh script to make the connection of remote server using Password-Based Authentication AWS by default disabled Password-Based Authentication
# Script is Prepared by Mr. Siva Kumar
# LinkedIn URL: "https://www.linkedin.com/in/sivakumar120406"
# Github repo url:"https://github.com/sivakumar1204/User-Data-Scripts-for-Ansible-Setup.git"

# List the Environment variables

export DEFAULT_USERNAME="ubuntu"
export DEFAULT_PASSWORD="test123"
export USERNAME="ansadmin"
export PASSWORD="test123"
export REMOTE_USERNAME="ansadmin"
export REMOTE_SERVER_IP_ADDRESS="10.0.1.10"
export REMOTE_PORT="22"  # Typically 22

# Define your public key file
export PUBLIC_KEY_FILE="/home/$USERNAME/.ssh/id_rsa.pub"

# 1. Export the REMOTE_SERVER_IP_ADDRESS as an environment variable

# export REMOTE_SERVER_IP_ADDRESS

# 1. Delete the current password for the $DEFAULT_USERNAME (optional)

echo -e "$DEFAULT_PASSWORD\n$DEFAULT_PASSWORD" | sudo passwd -d $DEFAULT_USERNAME

# 2. Set the new password for the $DEFAULT_USERNAME

echo -e "$DEFAULT_PASSWORD\n$DEFAULT_PASSWORD" | sudo passwd $DEFAULT_USERNAME

echo "User's password has been updated"

# 3. Add $DEFAULT_USERNAME to the adm group

#sudo usermod -aG adm $DEFAULT_USERNAME

# 4. Enable Password-Based Authentication to Yes and Restart the ssh services to effect changes 

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Password-based authentication has been enabled"

# 5. Restart SSHD service to apply the changes

sudo systemctl restart sshd

echo "sshd service has been restarted successfully"

# 6. Creation of user with default options

sudo adduser $USERNAME <<EOF
test123
test123
Full Name
Room Number
Work Phone
Home Phone
Other
y
EOF

# 7. Add the user $USERNAME to sudoers group

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
echo "$DEFAULT_USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo

# 8. Add user $USERNAME to adm group

sudo usermod -aG adm $USERNAME
sudo usermod -aG sudo $USERNAME

# 9. Install Ansible

sudo apt-get update -y

echo "System update is completed successfully"

sudo apt install ansible -y

echo "Ansible installation completed successfully"

# 10. Check the version of Ansible

ansible --version

# 11. Switch to the user terminal

#sudo -u $USERNAME bash <<EOF

# 12. Create SSH keys for the user $USERNAME

sudo -u $USERNAME ssh-keygen -t rsa -b 2048 -f /home/$USERNAME/.ssh/id_rsa -N ""
sudo -u $USERNAME chmod 700 /home/$USERNAME/.ssh
sudo -u $USERNAME chmod 600 /home/$USERNAME/.ssh/id_rsa
sudo -u $USERNAME chmod 644 /home/$USERNAME/.ssh/id_rsa.pub
sudo -u $USERNAME chown $USERNAME:$USERNAME /home/$USERNAME/*
#sudo -u $USERNAME ssh-copy-id $REMOTE_USERNAME@$REMOTE_SERVER_IP_ADDRESS

# 13. Change to the home directory of '$USERNAME'
#cd ~

# 14. Create an Ansible inventory file
sudo -u $USERNAME echo "[web-server]" | tee -a /home/$USERNAME/hosts
sudo -u $USERNAME echo "$REMOTE_SERVER_IP_ADDRESS" | tee -a /home/$USERNAME/hosts

# 15. Copy the public key onto the remote server

# Copy the public key to the remote server using SSH
sudo -u $USERNAME ssh -p "$REMOTE_PORT" "$REMOTE_USERNAME@$REMOTE_SERVER_IP_ADDRESS" "mkdir -p ~/.ssh && echo '$(cat $PUBLIC_KEY_FILE)' >> ~/.ssh/authorized_keys"
#sudo -u $USERNAME ssh-copy-id $REMOTE_USERNAME@$REMOTE_SERVER_IP_ADDRESS

#echo "Copied public key to $REMOTE_SERVER_IP_ADDRESS successfully"

# 16. Test the connectivity using the Ansible ping module

sudo -u $USERNAME ansible all -i /home/$USERNAME/hosts -u $REMOTE_USERNAME -m ping
#ansible all -i ~/hosts -u $REMOTE_USERNAME -m ping

# Exit the '$USERNAME' user shell
