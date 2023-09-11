<<<<<<< HEAD
#Ansible_Server.sh
#+++++++++++++++++++++++++++++++++++++++++++++
# Created user data script for user creation and install ansible and test the connection using ansible ping module in Ansible-Server.sh
# Here i had used the Ubuntu 22 for Ansible Node as well as Ansible Server.
# Taken two EC2 instances one for Ansible-Server and one for Ansible-Node
# Created two user data scripts for Ansible-Server and one for Ansible-Node
# First execute the Ansible-Node.sh script to make the connection of remote server using Password-Based Authentication AWS by default disabled Password-Based Authentication
# Once you login to the server update the default user's password "Ubuntu" 
# Execute below commands
# sudo passwd -d ubuntu
# sudo passwd ubuntu
# sudo usermod -aG ubuntu (Optional)
# Script is Prepared by Mr. Siva Kumar
# LinkedIn URL: "https://www.linkedin.com/in/sivakumar120406"
# Github repo url:"https://github.com/sivakumar1204/User-Data-Scripts-for-Ansible-Setup.git"

#!/bin/bash

# List the Environment variables

DEFAULT_USERNAME="ubuntu"
DEFAULT_PASSWORD="test123"
USERNAME="ansadmin"
PASSWORD="test123"
REMOTE_USERNAME="ansadmin"
REMOTE_SERVER_IP_ADDRESS="172.31.14.161"

# 1. Export the REMOTE_SERVER_IP_ADDRESS as an environment variable

export REMOTE_SERVER_IP_ADDRESS

# 2. Delete the current password for the $DEFAULT_USERNAME (Optional)

sudo passwd -d $DEFAULT_USERNAME

# 2. Set the new password for the $DEFAULT_USERNAME

echo "$DEFAULT_USERNAME:$DEFAULT_PASSWORD" | sudo chpasswd

echo " user's password has been updated"

# 3. Add $DEFAULT_USERNAME in to adm  group

sudo usermod -aG adm $DEFAULT_USERNAME

# 4. Enable Password-Based Authentication to Yes and Restart the ssh services to effect changes 

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Password based authentication has been enabled"

# 5. Restart SSHD service to apply the changes

sudo systemctl restart sshd

echo " sshd services has been restarted successfully"

# 6. Creation of user with default options

sudo adduser $USERNAME <<EOF
test123
test123
<Full Name>
<Room Number>
<Work Phone>
<Home Phone>
<Other>
y
EOF

# 7. Add the user $USERNAME into sudoers group

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo

# 8. Add user $USERNAME in to adm  group

sudo usermod -aG adm $USERNAME

# 9. Create SSH keys for the user $USERNAME
sudo -u $USERNAME ssh-keygen -t rsa -b 2048 -f /home/$USERNAME/.ssh/id_rsa -N ""
sudo chmod 777 /home/$USERNAME/.ssh
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub

#echo "SSH keys created successfully"

# 10. Go inside to the users home directory.

sudo  cd /home/$USERNAME/.ssh/

# 11. Install Ansible

sudo apt-get update -y

echo "system update is completed successfully"

sudo apt install ansible -y

echo "Ansible installation completed successfully"

# 12. Check the version of Ansible

ansible --version

# 13 Switch to the user terminal

sudo -u $USERNAME bash <<EOF

# 14. Change to the home directory of '$USERNAME'
cd ~

# 15. Go inside to the ansible home directory and provide the ownership to the files inside ansible to the created user $USERNAME

sudo touch /home/$USERNAME/hosts

sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/hosts

# 16. Update the Ansible inventory file

echo "[web-server]" | sudo tee -a /home/$USERNAME/hosts

echo "$REMOTE_SERVER_IP_ADDRESS" | sudo tee -a /home/$USERNAME/hosts
# 17. Copy the public key on to the remote server

ssh-copy-id $REMOTE_USERNAME@$REMOTE_SERVER_IP_ADDRESS

echo " copied public key on to $REMOTE_SERVER successfully"

#18. Test the connectivity using the Ansible ping module

ansible all -i /home/$USERNAME/hosts -u $USERNAME -m ping

# Exit the '$USERNAME' user shell

EOF
=======
#Ansible_Server.sh
#+++++++++++++++++++++++++++++++++++++++++++++
# Created user data script for user creation and install ansible and test the connection using ansible ping module in Ansible-Server.sh
# Here i had used the Ubuntu 22 for Ansible Node as well as Ansible Server.
# Taken two EC2 instances one for Ansible-Server and one for Ansible-Node
# Created two user data scripts for Ansible-Server and one for Ansible-Node
# First execute the Ansible-Node.sh script to make the connection of remote server using Password-Based Authentication AWS by default disabled Password-Based Authentication
# Once you login to the server update the default user's password "Ubuntu" 
# Execute below commands
# sudo passwd -d ubuntu
# sudo passwd ubuntu
# sudo usermod -aG ubuntu (Optional)
# Script is Prepared by Mr. Siva Kumar
# LinkedIn URL: "https://www.linkedin.com/in/sivakumar120406"
# Github repo url:"https://github.com/sivakumar1204/User-Data-Scripts-for-Ansible-Setup.git"

#!/bin/bash

# List the Environment variables

USERNAME="Your_Username"
PASSWORD="Your_Password"
REMOTE_USERNAME="Your_Ansible_Node_Username"
REMOTE_SERVER_IP_ADDRESS="Your_Ansible_Node_Private_IP_Address"

# 1. Export the REMOTE_SERVER_IP_ADDRESS as an environment variable
export REMOTE_SERVER_IP_ADDRESS

# 2. Enable Password-Based Authentication to Yes and Restart the ssh services to effect changes 

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Password based authentication has been enabled"

# 3. Restart SSHD service to apply the changes

sudo systemctl restart sshd

echo " sshd services has been restarted successfully"

# 4. Creation of user with default options

sudo adduser $USERNAME <<EOF
test123
test123
<Full Name>
<Room Number>
<Work Phone>
<Home Phone>
<Other>
y
EOF

# 5. Add the user $USERNAME into sudoers group

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo

# 6. Add user $USERNAME in to adm  group

sudo usermod -aG adm $USERNAME

# 7. Create SSH keys for the user $USERNAME
sudo -u $USERNAME ssh-keygen -t rsa -b 2048 -f /home/$USERNAME/.ssh/id_rsa -N ""
sudo chmod 777 /home/$USERNAME/.ssh
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub

#echo "SSH keys created successfully"

# 8. Go inside to the users home directory.

sudo  cd /home/$USERNAME/.ssh/

# 9. Install Ansible

sudo apt-get update -y

echo "system update is completed successfully"

sudo apt install ansible -y

echo "Ansible installation completed successfully"

# 10. Check the version of Ansible

ansible --version

# 11 Switch to the user terminal

sudo -u $USERNAME bash <<EOF

# 12. Change to the home directory of '$USERNAME'
cd ~

# 13. Go inside to the ansible home directory and provide the ownership to the files inside ansible to the created user $USERNAME

sudo touch /home/$USERNAME/hosts

sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/hosts

# 14. Update the Ansible inventory file

echo "[web-server]" | sudo tee -a /home/$USERNAME/hosts

echo "$REMOTE_SERVER_IP_ADDRESS" | sudo tee -a /home/$USERNAME/hosts
# 15. Copy the public key on to the remote server

ssh-copy-id $REMOTE_USERNAME@$REMOTE_SERVER_IP_ADDRESS

echo " copied public key on to $REMOTE_SERVER successfully"

#16 Test the connectivity using the Ansible ping module

ansible all -i /home/$USERNAME/hosts -u $USERNAME -m ping

# Exit the '$USERNAME' user shell

EOF
>>>>>>> 159f9285655eb8a5ec106f08a049eec3556d1117
