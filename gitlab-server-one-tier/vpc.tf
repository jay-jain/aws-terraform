# terraform {
#   required_version = "~> 0.12.0"

#   backend "s3" {
#     key = "devops-vpc"
#   }
# }

provider "aws" {
  region = var.region
}

resource "aws_vpc" "devops-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    "Name" = "Pipeline VPC"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = "10.0.0.0/27"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.devops-vpc.id
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.devops-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    "Name" = "Public Route Table"
  }
}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}