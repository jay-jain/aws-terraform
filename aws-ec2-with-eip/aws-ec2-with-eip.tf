provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "webserver" {
  key_name        = aws_key_pair.kp.key_name
  ami             = var.ami_map[var.region]
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.WebServerSG.name}"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.ssh_priv_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
      "echo \"<html><h1>This is Ouroboros Web Server</h1></html>\" | sudo tee /usr/share/nginx/html/index.html"
    ]
  }
}

resource "aws_key_pair" "kp" {
  key_name   = "vidly"
  public_key = file(var.ssh_pub_key_path)
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.webserver.id

  provisioner "local-exec" {
    command = "echo The Elastic IP of your web server is: ${aws_eip.ip.public_ip} > ip_address.txt"
  }
}

resource "aws_security_group" "WebServerSG" {
  name        = "WebServerSG"
  description = "Allows inbound HTTP traffic and SSH traffic"

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
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
    Name = "WebServerSG"
  }
}