resource "tls_private_key" "kube-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kube-key" {
  key_name   = var.key_name
  public_key = tls_private_key.kube-key.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.kube-key.private_key_pem
  filename          = "${path.module}/kube-key.pem"
}
