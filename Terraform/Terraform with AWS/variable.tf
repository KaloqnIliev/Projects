variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "eu-west-2"
}

variable "ami" {
  description = "The ID of the Amazon Machine Image (AMI) to use for instances."
  type        = string
  default     = "ami-06178cf087598769c"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "m5.large"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for EC2 instances."
  type        = string
  default     = "citadel"
}