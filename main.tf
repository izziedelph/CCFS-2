provider "aws" {
  region = "us-east-1"
}

# VPC for CCFS
resource "aws_vpc" "CCFS_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "CCFS-VPC"
  }
}


# Public Subnet 1 (for ALB and NAT Gateway)
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.CCFS_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public-Subnet-1"
  }
}


# Private Subnet 1 (for EC2 and RDS)
resource "aws_subnet" "private_app_subnet_1" {
  vpc_id            = aws_vpc.CCFS_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-Subnet-1"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "CCFS_igw" {
  vpc_id = aws_vpc.CCFS_vpc.id

  tags = {
    Name = "CCFS-Internet-Gateway"
  }
}


# Route Table for Public Subnet (routes traffic to IGW)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.CCFS_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CCFS_igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}


# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}


# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "CCFS-NAT-EIP"
  }
}

# NAT Gateway for outbound traffic from private subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "CCFS-NAT-Gateway"
  }
}

# Route Table for Private Subnet (routes to NAT Gateway)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.CCFS_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}


# Associate Private Subnet with Route Table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_app_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}


# Security Group for ALB (Public Access)
resource "aws_security_group" "CCFS_alb_sg" {
  vpc_id = aws_vpc.CCFS_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CCFS-ALB-Security-Group"
  }
}


# Security Group for EC2 in Private Subnet
resource "aws_security_group" "CCFS_ec2_sg" {
  vpc_id = aws_vpc.CCFS_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]  # Only allow traffic from public subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CCFS-EC2-Security-Group"
  }
}

