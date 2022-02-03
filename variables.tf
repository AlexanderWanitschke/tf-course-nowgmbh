variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the instance"
  default     = "ami-04c921614424b07cd"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the instance"
  default     = "t2.micro"
}

variable "app_server_count" {
  type        = number
  description = "The number of app servers to start"
  default     = 2
}
