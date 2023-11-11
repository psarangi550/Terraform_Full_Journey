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

variable "variable_sub_az" { # defining the variable as variable_sub_az

  type        = string                                                 # providing the type of variable as string 
  description = "Availability Zone Where we Want to Put the EC2 o VPC" # providing the description which which will show in the CLI if it ask for the value
  default     = "us-west-2a"                                           # providing the default value up in here 

}

variable "environment" {                                             # defining the environment variable in this case
  type        = string                                               # defining the type of variable as string in here 
  description = "providing the description for the SDLC environment" # providiging the description which will show in CLI
  default     = "dev"                                                # providing the default value in here 

}