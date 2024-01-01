resource "tls_private_key" "kube-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kube-key" {
  key_name   = "kube-key"
  public_key = tls_private_key.kube-key.public_key_openssh
}

output "private_key_pem" {
  description = "The private key data in PEM format"
  value       = tls_private_key.kube-key.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "The public key data in OpenSSH format"
  value       = tls_private_key.kube-key.public_key_openssh
  sensitive   = true
}

output "public_key_pem" {
  description = "The public key data in PEM format"
  value       = tls_private_key.kube-key.public_key_pem
  sensitive   = true
}
