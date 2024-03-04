variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "eu-west-2"
}

provider "aws" {
  region = var.region
}
