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
    private_key = file(var.ssh_priv_key_path) # Your private key; usually stored in your ~/.ssh directory
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
      "echo \"<html><h1>This is Ouroboros Web Server</h1></html>\" | sudo tee /usr/share/nginx/html/index.html"
    ]
  }

  provisioner "local-exec" {
    command = "echo The temporary static IP of your web server is: ${aws_instance.webserver.public_ip} > ip_address.txt"
  }
}

resource "aws_key_pair" "kp" {
  key_name   = "YOUR_KEY_NAME" # Remember to replace it with the name of your key (without the.pem extension)
  public_key = file(var.ssh_pub_key_path) # The public key file associated with your instance
}


resource "aws_security_group" "WebServerSG" {
  name        = "WebServerSG"
  description = "Allows inbound HTTP traffic and SSH traffic"
  # vpc_id      = "${aws_vpc.main.id}"

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