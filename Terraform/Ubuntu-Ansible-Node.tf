/*


# Define the EC2 instance resource
resource "aws_instance" "Ubuntu-Ansible-Node" {
    ami           = "ami-0ea18256de20ecdfc"
    instance_type = "t2.micro"
    key_name      = "My-Project"
    subnet_id     = aws_subnet.My-Project-Public-Subnet-1A.id
    security_groups = [aws_security_group.My-Project-SG.name]
    user_data = <<-EOF
                #!/bin/bash
                # 1. Delete the current password for the ubuntu (optional)
                echo -e "test123\ntest123" | sudo passwd -d ubuntu

                # 2. Set the new password for the ubuntu
                echo -e "test123\ntest123" | sudo passwd ubuntu

                echo "User's password has been updated"

                # 3. Add ubuntu to the adm group
                sudo usermod -aG adm ubuntu

                # 4. Enable Password-Based Authentication to Yes and Restart the ssh service to effect changes
                sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
                echo "Password-based authentication has been enabled"

                # 5. Restart SSHD service to apply the changes
                sudo systemctl restart sshd
                echo "sshd service has been restarted successfully"

                # 6. Creation of user with default options
                sudo adduser ansadmin <<EOF
                test123
                test123
                <Full Name>
                <Room Number>
                <Work Phone>
                <Home Phone>
                <Other>
                y
                EOF

                # 7. Add the user ansadmin into sudoers group
                echo "ansadmin ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo

                # 8. Add user ansadmin to the adm group
                sudo usermod -aG adm ansadmin


                 EOF
    tags = {
        name = "Ubuntu-Ansible-Node"
        Owner = "Siva"
        Dept = "DevOps"
    }
}

*/

/*
provider "aws" {
  region = "ca-central-1"
}
*/

resource "aws_instance" "ubuntu" {
  ami           = "ami-0ea18256de20ecdfc" # Replace with the desired Ubuntu AMI ID
  instance_type = "t2.micro"               # Change to your preferred instance type
  key_name      = "My-Project"          # Replace with your SSH key name
  security_groups = [aws_security_group.example.name]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              export CURRENT_USER="ubuntu"
              export NEW_USER="ansadmin"
              export NEW_PASSWORD="test123"
              useradd -m -s /bin/bash $NEW_USER
              echo "$NEW_USER:$NEW_PASSWORD" | chpasswd
              usermod -aG adm $CURRENT_USER
              usermod -aG adm $NEW_USER
              echo "$CURRENT_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
              echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
              sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              service ssh restart
              EOF
}

resource "aws_security_group" "example" {
  name_prefix = "example-"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


/*
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = ""

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }
}
/*
resource "aws_network_interface_sg_attachment" "ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = aws_instance.ubuntu.network_interface_ids[0]
}

output "instance_ip" {
  value = aws_instance.ubuntu.public_ip
}

*/
