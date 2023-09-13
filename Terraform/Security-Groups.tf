


# Create a security group allowing SSH and all traffic from anywhere
resource "aws_security_group" "My-Project-SG" {
  name        = "My-Project-SG"
  description = "My-Project-SG"
  vpc_id      = aws_vpc.My-Project-VPC.id
  tags = {
    Name = "My-Project-SG"
    Owner = "Siva"
    Dept = "DevOps"
    } 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


