resource "aws_instance" "Ubuntu-Ansible-Node" {
    ami = "ami-0ea18256de20ecdfc"
    instance_type = "t2.micro"
    key_name = "My-Project"
    subnet_id = aws_subnet.My-Project-Public-Subnet-1A.id
    availability_zone = "ca-central-1a"
    private_ip = "10.0.1.10"
    security_groups = ["${aws_security_group.My-Project-SG.name}"]
    user_data = <<-EOF
        #!/bin/bash
        # Specify your variables
        USERNAME="ansadmin"
        DEFAULT_USERNAME="ubuntu"
        DEFAULT_PASSWORD="ubuntu"
		export USERNAME
		export DEFAULT_USERNAME
		export DEFAULT_PASSWORD
		
        # 1. Delete the current password for the $DEFAULT_USERNAME (optional)
        echo -e "$DEFAULT_PASSWORD\n$DEFAULT_PASSWORD" | sudo passwd -d $DEFAULT_USERNAME

        # 2. Set the new password for the $DEFAULT_USERNAME
        echo -e "$DEFAULT_PASSWORD\n$DEFAULT_PASSWORD" | sudo passwd $DEFAULT_USERNAME

        echo "User's password has been updated"

        # 3. Add $DEFAULT_USERNAME to the adm group
        sudo usermod -aG adm $DEFAULT_USERNAME

        # 4. Enable Password-Based Authentication to Yes and Restart the ssh service to effect changes
        sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
        echo "Password-based authentication has been enabled"

        # 5. Restart SSHD service to apply the changes
        sudo systemctl restart sshd
        echo "sshd service has been restarted successfully"

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

        # 8. Add user $USERNAME to the adm group
        sudo usermod -aG adm $USERNAME

        EOF

}


prove me the terraform file for the same