resource "aws_autoscaling_group" "gitlab" {
  name                      = "gitlab-asg"
  depends_on                = [aws_launch_configuration.gitlab]
  launch_configuration      = aws_launch_configuration.gitlab.name
  vpc_zone_identifier       = [aws_subnet.public-1.id]
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_type         = "EC2"
  health_check_grace_period = 30  
  lifecycle {
    create_before_destroy = true
  }
  initial_lifecycle_hook {
    name                 = "bootstrap-gitlab"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 650
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }
}

resource "aws_launch_configuration" "gitlab" {
  name_prefix     = "gitlab-server"
  image_id        = var.ami_map[var.region]
  instance_type   = "t2.medium"
  key_name        = "gitlab"
  security_groups = [aws_security_group.gitlab.id]
  user_data       = file("bootstrap.sh")
  iam_instance_profile = aws_iam_instance_profile.profile.name
  lifecycle {
    create_before_destroy = true
  }
}

### Remember to restrict ingress by Source IP Addresses
resource "aws_security_group" "gitlab" {
  name        = "GitlabSG"
  description = "Allows inbound HTTP/HTTPS traffic and SSH traffic"
  vpc_id      = aws_vpc.devops-vpc.id

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
  ingress {
    description      = "Container registry port"
    from_port        = 5050
    to_port          = 5050
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