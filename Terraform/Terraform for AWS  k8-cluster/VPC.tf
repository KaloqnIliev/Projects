resource "aws_vpc" "ubuntu-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "ubuntu-sub" {
  vpc_id     = aws_vpc.ubuntu-vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.ubuntu-vpc.id
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


