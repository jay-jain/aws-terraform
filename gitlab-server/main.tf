provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

data "aws_subnet" "public"{
  tags = {
    Name = "PublicSubnet"
  }
}

data "aws_vpc" "devops-vpc"{
  cidr_block ="10.0.0.0/16"
}

resource "aws_instance" "gitlab" {
  key_name        = "gitlab"
  ami             = var.ami_map[var.region]
  instance_type   = "t2.medium"
  #security_groups = ["${aws_security_group.gitlab.name}"]
  vpc_security_group_ids = [aws_security_group.gitlab.id]
  user_data       = file("bootstrap.sh")
  subnet_id       = data.aws_subnet.public.id
  #depends_on      = [aws_nat_gateway.natgw]
}

# resource "aws_key_pair" "kp" {
#   key_name   = "gitlab"
#   public_key = file(var.ssh_pub_key_path)
# }

resource "aws_security_group" "gitlab" {
  name        = "GitlabSG"
  description = "Allows inbound HTTP/HTTPS traffic and SSH traffic"
  vpc_id      = data.aws_vpc.devops-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "GitlabSG"
  }
}


