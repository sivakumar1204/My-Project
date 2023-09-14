/*
data "aws_subnet" "My-Project-Public-Subnet-1B" {
  id = aws_subnet.My-Project-Public-Subnet-1B.id
}
*/

resource "aws_instance" "Ubuntu-Ansible-Server" {
  ami             = var.ubuntu-ami-id           # Replace with the desired Ubuntu AMI ID
  instance_type   = var.instance-type            # Change to your preferred instance type
  #key_name        = aws_key_pair.My-Project-key.key_name        # Replace with your pem key file
  key_name        = var.key-name
  subnet_id       = var.subnet-1B-id
  #subnet_id       = data.aws_subnet.My-Project-Public-Subnet-1B.id # Replace with your subnet id
  #security_group_id = [aws_security_group.My-Project-SG.id]  # Replace with your Security Group id 
  vpc_security_group_ids = [var.vpc_security_group_id]
  #vpc_security_group_ids = [aws_security_group.My-Project-SG.id] # Replace with your Security Group id 
  associate_public_ip_address = true
  private_ip = var.ansible-server-private-ip
  #public_ip = "10.0.2.15"
  user_data = file("Ansible-Server.sh")
  tags = {
    Name = "Ubuntu-Ansible-Server"
    Owner = local.Owner
    Dept = local.Dept
    Env = local.Env
    }
  provisioner "local-exec" {
    command = "echo ${aws_instance.Ubuntu-Ansible-Server.public_ip} > Ubuntu-Ansible-Server-Public-IP.txt"
    }
  provisioner "local-exec" {
    command = "echo ${aws_instance.Ubuntu-Ansible-Server.id} > Ubuntu-Ansible-Server-Instance.id.txt"
    }
  /*
  provisioner "remote-exec" {
      inline = [
      "#!/bin/bash",
      "export USERNAME=\"ansadmin\"",
      "export PASSWORD=\"test123\"",
      "export REMOTE_USERNAME=\"ansadmin\"",
      "export REMOTE_SERVER_IP_ADDRESS=\"10.0.1.10\"",
      "export REMOTE_PORT=\"22\"",
      "export PUBLIC_KEY_FILE=\"/home/$USERNAME/.ssh/id_rsa.pub\"",
      "sudo -u $USERNAME ssh -p \"$REMOTE_PORT\" \"$REMOTE_USERNAME@$REMOTE_SERVER_IP_ADDRESS\" \"mkdir -p ~/.ssh && echo '$(cat $PUBLIC_KEY_FILE)' >> ~/.ssh/authorized_keys\"",
      "sudo -u $USERNAME ansible all -i /home/$USERNAME/hosts -u $REMOTE_USERNAME -m ping",
    ]
  
      connection {
        type        = "ssh"
        port        = "22"
        user        = "ubuntu"
        private_key = file("My-Project.pem")  //created this pem key file  manually and stored in the terrsfom working directory
        host    = self.public_ip
        timeout = "30m"
      } 
    }
  */
}
  
#Display the Public IP
output "Ubuntu-Ansible-Server-Public-IP" {
  value = aws_instance.Ubuntu-Ansible-Server.public_ip
  
}

#Display the INstance ID
output "Ubuntu-Ansible-Server-id" {
  value = aws_instance.Ubuntu-Ansible-Server.id
  
}

/*
# Copy the public key on to the remote server using below command

sudo -u ansadmin ssh-copy-id ansadmin@10.0.1.10

# Check teh connectivity

sudo -u ansadmin ansible all -i /home/ansadmin/hosts -u ansadmin -m ping

/*
# If you want to create cusotm key and add the key into your ec2 instance then use the below resource section do the necessary changes
resource "aws_key_pair" "My-Project-key" {
  key_name   = "My-Project-key"
  # teh best approch is to provide the path where the public key is stored in your local system
  public_key = file("C:/Users/sivar/Desktop/My-Project/My-Project/Terraform/id_rsa.pub") //providing the pem file path
  #if you havve pem file with you tehn place that pem key file in to the current terraform working directory
  #public_key = file("id_rsa.pub")
  # public_key = file("id_rsa.pub") //placing the public file in terraform lab directory
  # the other way is to provide the public key copy the public key and paste direct in the public key attribute same as below
  #public_key = "ssh-rsa xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxeJZ7Isv87uAMoxTUBK91MY2Jx4o55Ejqan0i7gn0ijJ8apgA0uawZT6hA8QIC2zmpaqwNRdibgdh8N5yyS79o7gpxbzTtwLwhjtVwVGS9R3SYuK/3R0RAeeG+JKmHdjPPGqGZHQl59+QBxFFVeVHurOqIgnfVA1KIDC0lolLfyKSKq5yvYIAV6t0/TYI7VLblJL+OgU8oiREPqHrUJ3iI0TNctsO/bhn7zKFkrRyB8EyZU2MYdOKhtWEw6V8UOs0FNLXqCe1mY/4z0USju0AWO+q+1i6w1wV8= XXXX@LAPTOP-XXXXXX""
  tags = {
    Name = "My-Project-key"
    Owner = "Siva"
    Dept = "DevOps"
    }
}

*/