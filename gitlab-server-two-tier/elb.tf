## For LB: elb, target group, target group attachment, listener, 
## For ASG: launch_config, asg, target_group attachment
data "aws_acm_certificate" "my_cert" {
  domain = var.dns_zone_name
  types  = ["AMAZON_ISSUED"]
}

resource "aws_lb" "gitlab" {
  name              = "gitlab-elb"
  subnets           = [aws_subnet.public-1.id,aws_subnet.public-2.id]  
  security_groups   = [aws_security_group.gitlab.id]
  internal           = false
  load_balancer_type = "application"
  access_logs {
    bucket   = "access-logs"
    prefix   = "gitlab-elb"    
  }

  # listener {
  #   instance_port      = 80
  #   instance_protocol  = "https"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = data.aws_acm_certificate.my_cert.arn
  # }

  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   target              = "HTTP:80/"
  #   interval            = 30
  # }
}

resource "aws_lb_listener" "gitlab-listener" {
  load_balancer_arn = aws_lb.gitlab.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.my_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab-tg.arn
  }
}

resource "aws_lb_target_group" "gitlab-tg" {
  name       = "gitlab-target-group"
  depends_on = [aws_vpc.devops-vpc]
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.devops-vpc.id
  health_check {
    interval            = 30
    path                = "/users/password/new?user_email="
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

