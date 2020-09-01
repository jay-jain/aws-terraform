provider "aws" {
  region = "us-east-1"
}
resource "aws_route53_zone" "private" {
  name = "sci-tings.org"

  vpc {
    vpc_id = aws_vpc.devops-vpc.id
    vpc_region = "us-east-1"
  }
}