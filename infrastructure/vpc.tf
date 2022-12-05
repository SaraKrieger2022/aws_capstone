resource "aws_vpc" "capstonevpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.capstonevpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Public subnet a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.capstonevpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Public subnet b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.capstonevpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Private subnet a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.capstonevpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Private subnet b"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.capstonevpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.capstonevpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "elasticip" {
  vpc      = true
}

resource "aws_nat_gateway" "natgate" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "NAT gateway"
  }

  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_default_route_table" "private_route_table" {
  default_route_table_id = aws_vpc.capstonevpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgate.id
  }

  tags = {
    Name = "Private route table"
  }
}