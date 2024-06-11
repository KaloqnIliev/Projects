resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = tls_private_key.kube-key.public_key_openssh
}
