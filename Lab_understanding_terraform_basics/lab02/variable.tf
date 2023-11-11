variable "vpc_cidr" {
  type        = string
  description = "CIDR value for the VPC out in here"
  default     = "10.0.0.0/16"
}

variable "public_subnet" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }
}


variable "private_subnet" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3
  }
}