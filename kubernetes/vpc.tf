resource "aws_vpc" "eks_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "192.168.0.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "192.168.32.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "192.168.64.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "192.168.96.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks_vpc.id
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
  subnet_id     = aws_subnet.public-1.id
  tags = {
    "Name" = "Pipeline NAT Gateway"
  }
}

/* PUBLIC ROUTE TABLE*/

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  depends_on = [aws_internet_gateway.gw]
  tags = {
    "Name" = "Public Route Table"
  }
}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}

/* PRIVATE ROUTE TABLES*/

resource "aws_route_table" "private-1" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    "Name" = "Private Route Table 1"
  }
}

resource "aws_route_table" "private-2" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    "Name" = "Private Route Table 2"
  }
}

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private-1.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private-2.id
}
