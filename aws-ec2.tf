provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "webserver" {
  key_name        = aws_key_pair.kp.key_name
  ami             = "ami-09d95fab7fff3776c" # Linux AMI 2 in us-east-1
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.WebServerSG.name}"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("C:/Users/jay.jain/.ssh/terraform")
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
  key_name = "ouroboros"
  # public_key = file("~/.ssh/terraform.pub") # ssh-keygen -t rsa # chmod 400 ~/.ssh/terraform
  public_key = file("C:/Users/jay.jain/.ssh/terraform.pub")
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.webserver.id

  provisioner "local-exec" {
    # command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
    command = "echo 'The Elastic IP of your web server is: ' ${aws_eip.ip.public_ip} > ip_address.txt"
  }
}

resource "aws_security_group" "WebServerSG" {
  name        = "WebServerSG"
  description = "Allows inbound HTTP traffic and SSH traffic"
  # vpc_id      = "${aws_vpc.main.id}"

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
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