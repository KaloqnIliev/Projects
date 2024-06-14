variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for EC2 instances."
  type        = string
  default     = "key"
}

variable "ip_address" {
  description = "ip"
  type        = string
   default     = "0.0.0.0/0"
}

variable "counts" {
  description = "The number of instances to create"
  type        = number
  default     = 1
}
