module "autoscale_dns" {
  source  = "meltwater/asg-dns-handler/aws"
  version = "2.0.0"

  autoscale_handler_unique_identifier = "my_asg_handler"
  autoscale_route53zone_arn           = aws_route53_zone.zone.arn
  vpc_name                            = "devops-vpc"
}
