locals {
  Owner="Siva"
  Dept = "DevOps"
  Env ="Sandbox"
}

variable "region" {
  default = "ca-central-1"
}

variable "vpc-id" {
    default = "vpc-087cbdfe0debcf675"
  
}

variable "subnet-1A-id" {
    default = "subnet-0afbb341f551e0e5b"
  
}

variable "subnet-1B-id" {
    default = "subnet-0a26fb8165aa35599"
  
}

variable "vpc_security_group_id" {
    default = "sg-085b5bb1f7225ee35"
  
}

variable "ansible-node-private-ip" {
    default = "10.0.1.10"
  
}
variable "ansible-server-private-ip" {
    default = "10.0.2.15"
}
variable "key-name" {
    default = "My-Project"
  
}
variable "ubuntu-ami-id" {
    default = "ami-09f313b0430d08493" # Custom AMI Created manuallly
}

variable "instance-type" {
    default = "t2.micro"
}

