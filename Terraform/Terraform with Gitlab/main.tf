provider "aws" {
}

variable "key_name" {
  description = "The name of your key pair"
  type        = string
  default     = "kube-key"
}