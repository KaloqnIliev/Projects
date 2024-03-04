resource "aws_vpc" "kube-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "kube-sub" {
  vpc_id     = aws_vpc.kube-vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.kube-vpc.id
}

resource "aws_security_group" "clust-sg" {
  name        = "clust-sg"
  description = "Cluster security group"
  vpc_id      = aws_vpc.kube-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ip_address]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

