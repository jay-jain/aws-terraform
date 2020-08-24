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

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.devops-vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.devops-vpc.id
}

### NAT GATEWAY
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    "Name" = "NAT EIP"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    "Name" = "Pipeline NAT Gateway"
  }
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

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.devops-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    "Name" = "Private Route Table"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

output "nat_id" {
  value = aws_nat_gateway.natgw.id
}