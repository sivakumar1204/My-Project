
# Define Variables and export theose variables

#!/bin/bash

export USERNAME="ansadmin"
export PASSWORD="test123"
export REMOTE_USERNAME="ansadmin"
export REMOTE_SERVER_IP_ADDRESS="10.0.1.10"
export REMOTE_PORT="22"  # Typically 22

# 1. Define your public key file
export PUBLIC_KEY_FILE="/home/$USERNAME/.ssh/id_rsa.pub"


# 2. Copy the public key to the remote server using SSH
sudo -u $USERNAME ssh -p "$REMOTE_PORT" "$REMOTE_USERNAME@$REMOTE_SERVER_IP_ADDRESS" "mkdir -p ~/.ssh && echo '$(cat $PUBLIC_KEY_FILE)' >> ~/.ssh/authorized_keys"



# 3 Test the connectivity using the Ansible ping module

sudo -u $USERNAME ansible all -i /home/$USERNAME/hosts -u $REMOTE_USERNAME -m ping