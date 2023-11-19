provider "aws" {

  region = "us-west-2"

  default_tags {
    
    tags = {

        Owner = "Acme"
        Provisioned ="Terraform"

    }

  } 

}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {

  cidr_block = var.vpc_cidr

  tags =  {

    Name = "AWS VPC"

  }

}

resource "aws_subnet" "public_subnet" {

  for_each          = var.public_subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
      Name = "Terraform"
    }

}

resource "aws_subnet" "private_subnet" {

  for_each          = var.private_subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
      Name = "Terraform"
    }
}


# resource "aws_instance" "amazon_linux" {

#   ami = "ami-093467ec28ae4fe03"
#   instance_type = "t2.micro"

# } 

