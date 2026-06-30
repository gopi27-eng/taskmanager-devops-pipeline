resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "devops-enterprise-vpc" }
}

# --- AVAILABILITY ZONE 1 (us-east-1a) ---
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { "kubernetes.io/role/elb" = "1", Name = "public-us-east-1a" }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = { "kubernetes.io/role/internal-elb" = "1", Name = "private-us-east-1a" }
}

# --- AVAILABILITY ZONE 2 (us-east-1b) ---
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b" # <-- Different AZ!
  map_public_ip_on_launch = true
  tags = { "kubernetes.io/role/elb" = "1", Name = "public-us-east-1b" }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b" # <-- Different AZ!
  tags = { "kubernetes.io/role/internal-elb" = "1", Name = "private-us-east-1b" }
}

# --- INTERNET GATEWAY & ROUTING ---
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags   = { Name = "main-igw" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate both public subnets with the internet gateway route table
resource "aws_route_table_association" "pub_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}