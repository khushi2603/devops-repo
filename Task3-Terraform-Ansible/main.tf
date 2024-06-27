provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "mainvpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "publicsubnet" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "publicrtb" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.publicrtb_name
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.publicrtb.id
}

resource "aws_security_group" "server_sg" {
  name = var.security_group_name
  vpc_id = aws_vpc.mainvpc.id
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_eip" "eip" {

  tags = {
    Name = var.server_eip_name
  }
}

resource "aws_instance" "server_instance" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.publicsubnet.id
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.server_sg.id]
  associate_public_ip_address = true
  depends_on                  = [aws_eip.eip]

  tags = {
    Name = var.server_instance_name
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y ansible",
      "ansible-pull -U https://github.com/devops-repo/your-ansible-playbook-repo.git" #replace with ansible repo
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_key_path)
      host        = aws_instance.server_instance.public_ip
    }
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.server_instance.id
  allocation_id = aws_eip.eip.id
}
