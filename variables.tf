variable "ami_id" {
  type        = map(string)
  description = "The AMI ID to use for the instance"
  default = {
    eu-central-1 = "ami-04c921614424b07cd"
    eu-west-1    = "ami-00ae935ce6c2aa534"
  }
}

variable "instance_type" {
  type         = string
  description  = "The instance type to use for the instance"
  defaulucidlt = "t2.micro"
}

variable "app_server_count" {
  type        = number
  description = "The number of app servers to start"
  default     = 2
}

variable "region" {
  type        = string
  description = "The region to use for the instance"
  default     = "eu-central-1"
}
