provider "aws" {
  region  = var.region
}

resource "aws_instance" "gitlab" {
  ami                  = var.ami_map[var.region]
  instance_type        = "t2.medium"
  key_name             = "gitlab"
  security_groups      = [aws_security_group.gitlab.name]
  user_data            = file("bootstrap.sh")
  iam_instance_profile = aws_iam_instance_profile.profile.name
}
resource "aws_security_group" "gitlab" {
  name        = "GitlabSG"
  description = "Allows inbound HTTP/HTTPS traffic and SSH traffic"
  vpc_id = "vpc-b2d194c8"
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

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
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