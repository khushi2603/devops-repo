variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "public_subnet_name" {
  description = "The name for the subnet"
  type        = string
}

variable "igw_name" {
  description = "The name for the igw"
  type        = string
}

variable "publicrtb_name" {
  description = "The name for the route table"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair in AWS"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance (Ubuntu)"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instance"
  type        = string
}

variable "security_group_name" {
  description = "Name of server instance security group"
  type        = string
}

variable "allowed_ports" {
  description = "List of allowed ingress ports"
  type        = list(number)
}

variable "server_eip_name" {
  description = "Name of elastic ip allocated to server"
  type        = string
}

variable "server_instance_name" {
  description = "Name of the server instance"
  type        = string
}

variable "ssh_key_path" {
  description = "Path to the SSH private key file"
  type        = string
}
