variable "vpc_cidr" {

  type = string # defining the type as string in this case 

  description = "Defined CIDR IP address in here " # providign th description for the variable over here

  default = "10.0.0.0/16" # defining the default value in this case out in here 

}

variable "public_subnet" { # defining the public subnet variable in here 

  default = { # defining the default value for the public subnet in this case as 

    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3

  }

}

variable "private_subnet" { # defining the private subnet variable in here 

  default = { # defining the default value for the private subnet in this case as 

    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3

  }

}