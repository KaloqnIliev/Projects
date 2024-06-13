data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "linux-node" {
  count         = var.counts
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.ubuntu-sub.id
  vpc_security_group_ids      = [aws_security_group.ubuntu-sg.id]
  key_name                    = aws_key_pair.ssh-key.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io
              EOF

  tags = {
    Name = count.index == 0 ? "ControlPlane" : "Workernode${count.index}"
  }
}

