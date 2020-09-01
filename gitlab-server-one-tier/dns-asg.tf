module "autoscale_dns" {
  source  = "meltwater/asg-dns-handler/aws"
  version = "2.0.0"

  autoscale_handler_unique_identifier = "my_asg_handler"
  autoscale_route53zone_arn           = aws_route53_zone.private.zone_id
  vpc_name                            = "devops-vpc"
}

resource "aws_route53_zone" "private" {
  name = "sci-tings.org"

  vpc {
    vpc_id = aws_vpc.devops-vpc.id
    vpc_region = "us-east-1"
  }
}