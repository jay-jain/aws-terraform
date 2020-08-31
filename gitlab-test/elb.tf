## For LB: elb, target group, target group attachment, listener, 
## For ASG: launch_config, asg, target_group attachment
data "aws_acm_certificate" "my_cert" {
  domain = var.dns_zone_name
  types  = ["AMAZON_ISSUED"]
}


resource "aws_lb" "gitlab" {
  name               = "gitlab-elb"
  subnets            = ["subnet-46927048","subnet-872015db","subnet-c0b29ba7","subnet-d92b1cf7","subnet-d2532fec","subnet-f2f901bf"]
  security_groups    = [aws_security_group.gitlab.id]
  internal           = false
  load_balancer_type = "application"
  access_logs {
    bucket = "access-logs"
    prefix = "gitlab-elb"
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

resource "aws_lb_listener" "listener-443" {
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

resource "aws_lb_listener" "listener-80-registry" {
  load_balancer_arn = aws_lb.gitlab.arn
  port              = "80"
  protocol          = "HTTP"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = data.aws_acm_certificate.my_cert.arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.registry-tg.arn
  }
}

/*resource "aws_lb_listener" "listener-5050" {
  load_balancer_arn = aws_lb.gitlab.arn
  port              = "5050"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.my_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab-tg.arn
  }
}*/

resource "aws_lb_target_group" "gitlab-tg" {
  name       = "gitlab-target-group"
  port       = 80
  protocol   = "HTTP"
  vpc_id = "vpc-b2d194c8"
  health_check {
    interval            = 60
    path                = "/users/password/new?user_email="
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

resource "aws_lb_target_group" "registry-tg" {
  name       = "registry-target-group"
  port       = 5050
  protocol   = "HTTP"
  vpc_id = "vpc-b2d194c8"
  health_check {
    interval            = 60
    path                = "/"
    port                = 5050
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

resource "aws_lb_target_group_attachment" "gitlab" {
  target_group_arn = aws_lb_target_group.gitlab-tg.arn
  target_id        = aws_instance.gitlab.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "registry" {
  target_group_arn = aws_lb_target_group.registry-tg.arn
  target_id        = aws_instance.gitlab.id
  port             = 5050
}
