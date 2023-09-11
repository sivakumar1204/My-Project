<<<<<<< HEAD
#Ansible_node.sh
#+++++++++++++++++++++++++++++++++++++++++++++
# Created user data script for user creation and install ansible and test the connection using ansible ping module in Ansible-Server.sh
# Here i had used the Ubuntu 22 for Ansible Node as well as Ansible Server.
# Taken two EC2 instances one for Ansible-Server and one for Ansible-Node
# Created two user data scripts for Ansible-Server and one for Ansible-Node
# First execute the Ansible-Node.sh script to make the connection of remote server using Password-Based Authentication AWS by default disabled Password-Based Authentication
# Once you login to the server update the default user's password "Ubuntu" 
# Execute below commands
# sudo passwd -d ubuntu
# sudo passwd  ubuntu
# sudo usermod -aG ubuntu (Optional)
# Script is Prepared by Mr. Siva Kumar
# LinkedIn URL: "https://www.linkedin.com/in/sivakumar120406"
# Github repo url:"https://github.com/sivakumar1204/User-Data-Scripts-for-Ansible-Setup.git"

#!/bin/bash

# List the Environment variables

USERNAME="ansadmin"
DEFAULT_USERNAME="ubuntu"
DEFAULT_PASSWORD="test123"

# 1. Delete the current password for the $DEFAULT_USERNAME (optional)

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
=======
#Ansible_node.sh
#+++++++++++++++++++++++++++++++++++++++++++++
# Created user data script for user creation and install ansible and test the connection using ansible ping module in Ansible-Server.sh
# Here i had used the Ubuntu 22 for Ansible Node as well as Ansible Server.
# Taken two EC2 instances one for Ansible-Server and one for Ansible-Node
# Created two user data scripts for Ansible-Server and one for Ansible-Node
# First execute the Ansible-Node.sh script to make the connection of remote server using Password-Based Authentication AWS by default disabled Password-Based Authentication
# Once you login to the server update the default user's password "Ubuntu" 
# Execute below commands
# sudo passwd -d ubuntu
# sudo passwd  ubuntu
# sudo usermod -aG ubuntu (Optional)
# Script is Prepared by Mr. Siva Kumar
# LinkedIn URL: "https://www.linkedin.com/in/sivakumar120406"
# Github repo url:"https://github.com/sivakumar1204/User-Data-Scripts-for-Ansible-Setup.git"

#!/bin/bash

# List the Environment variables

USERNAME="Your_Username"

# 1. Enable Password-Based Authentication to Yes and Restart the ssh services to effect changes 

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Password based authentication has been enabled"

# 2. Restart SSHD service to apply the changes

sudo systemctl restart sshd

echo " sshd services has been restarted successfully"

# 3. Creation of user with default options

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

# 4. Add the user $USERNAME into sudoers group

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo

# 5. Add user $USERNAME in to adm  group

sudo usermod -aG adm $USERNAME
>>>>>>> 159f9285655eb8a5ec106f08a049eec3556d1117
