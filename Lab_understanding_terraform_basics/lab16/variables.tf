variable "aws_region" { # defining the aws_region as the variable in here 
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "demo_vpc"
}


variable "vpc_cidr" {

  type        = string
  description = "CIDR defined in aws vpc"
  default     = "10.0.0.0/16"

}


variable "private_subnets" {

  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3
  }


}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }
}