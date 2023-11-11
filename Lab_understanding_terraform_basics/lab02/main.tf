provider "aws" {

  region = "us-west-2" # here we are using the region out in here

}

data "aws_region" "current" {} # here using the data block to fetch the current aws_region in here

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {

  cidr_block = var.vpc_cidr # using the variable in here 

  tags = {

    "Region" = data.aws_region.current.name # using the data block to create the resource out in here 

  }

}

resource "aws_subnet" "public_subnet" {
  for_each          = var.public_subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    "key"       = each.key
    "Terrafrom" = "true"
  }

}

resource "aws_subnet" "private_subnet" {
  for_each          = var.private_subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value+100)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    "key"       = each.key
    "Terrafrom" = "true"
  }

}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
}


resource "aws_instance" "web-server" { # defining the resource as the awes_instance in this case out in here 

  vpc_security_group_ids = [aws_vpc.vpc.default_security_group_id]       # fetching the vpc_security_group_ids as the default security group of the VPC reference that we have created 
  ami                    = data.aws_ami.ubuntu.id                        # fetching the ami from the data resource or block in here 
  instance_type          = "t2.micro"                                    # using the free tier account in this case
  subnet_id              = aws_subnet.public_subnet["public_subnet_1"].id # fetching the public subnet in this case 


}