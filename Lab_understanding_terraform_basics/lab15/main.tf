provider "aws" {

    region = "us-east-1"

    default_tags {
      
      tags = {
        Environment = terraform.workspace
        OWNER = "Acme"
        PROVIDER = "Terraform"

      }

    }
  
}


data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {

    cidr_block = var.vpc_cidr # defining the cidr_block as reference to the variable block

    tags = {

        NAME = "AWS VPC"
    }
}

resource "aws_subnet" "public_subnet" {

    for_each = var.public_subnet
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr,8,each.value +100)
    availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
    map_public_ip_on_launch = true

    tags = {

        Terraform = "true"
    }


}

resource "aws_subnet" "private_subnet" {

    for_each = var.private_subnet
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr,8,each.value)
    availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

    tags = {

        Terraform = "true"
    }


}

