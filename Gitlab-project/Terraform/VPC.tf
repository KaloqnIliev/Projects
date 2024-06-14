resource "aws_vpc" "ubuntu-vpc" {
  cidr_block = "172.16.0.0/16"  
}

resource "aws_subnet" "ubuntu-sub" {
  vpc_id     = aws_vpc.ubuntu-vpc.id
  cidr_block = "172.16.1.0/24"  
  map_public_ip_on_launch = true  
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.ubuntu-vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ubuntu-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.ubuntu-sub.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ubuntu-sg" {
  name        = "ubuntu-sg"
  description = "Ubuntu security group"
  vpc_id      = aws_vpc.ubuntu-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ip_address]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


