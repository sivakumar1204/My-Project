/*
provider "aws" {
    region = "ca-central-1"
}
*/
terraform {
  backend "s3" {
    bucket = "siva-project"
    key    = "DevOps-Terrraform/terraform.tfstate"
    region = "ca-central-1"
  }
}
# Create a VPC
resource "aws_vpc" "My-Project-VPC" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "My-Project-VPC"
    Owner = "Siva"
    Dept = "DevOps"
}
}
# Create two subnets and associate public IPs

resource "aws_subnet" "My-Project-Public-Subnet-1A" {
  vpc_id                  = aws_vpc.My-Project-VPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ca-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "My-Project-Public-Subnet-1A"
    Owner = "Siva"
    Dept = "DevOps"
    }
}
# Create two subnets and associate public IPs
resource "aws_subnet" "My-Project-Public-Subnet-1B" {
  vpc_id                  = aws_vpc.My-Project-VPC.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ca-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "My-Project-Public-Subnet-1B"
    Owner = "Siva"
    Dept = "DevOps"
    }
}
# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "My-Project-IGW" {
  vpc_id = aws_vpc.My-Project-VPC.id
  tags = {
    Name = "My-Project-IGW"
    Owner = "Siva"
    Dept = "DevOps"
    }
}

# Create a route table and associate it with the VPC
resource "aws_route_table" "My-Project-RT" {
  vpc_id = aws_vpc.My-Project-VPC.id
  tags = {
    Name = "My-Project-RT"
    Owner = "Siva"
    Dept = "DevOps"
    } 
}

# Create a route for the internet gateway
resource "aws_route" "My-Project-Route_To_My-Project-IGW" {
  route_table_id         = aws_route_table.My-Project-RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.My-Project-IGW.id
  
}

# Attach the subnets to the route table
resource "aws_route_table_association" "My-Project-Public-Subnet-1A_Association" {
  subnet_id      = aws_subnet.My-Project-Public-Subnet-1A.id
  route_table_id = aws_route_table.My-Project-RT.id
}

resource "aws_route_table_association" "My-Project-Public-Subnet-1B_Association" {
  subnet_id      = aws_subnet.My-Project-Public-Subnet-1B.id
  route_table_id = aws_route_table.My-Project-RT.id
}
