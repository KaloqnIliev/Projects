resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh-key.public_key_openssh
}

output "private_key_pem" {
  value = tls_private_key.ssh-key.private_key_pem
}

output "public_key_pem" {
  value = tls_private_key.ssh-key.public_key_pem
}
