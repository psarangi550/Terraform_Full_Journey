provider "aws" { # defining the aws provider in here 

  region = "us-west-2" # defining the region that we need to use is of us-east-2

}

data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

locals { # defining the locals block in here 

  team        = "api_mgmt_dev"                                      # define the local variable in here 
  application = "corp_api"                                          # defining the application out in here
  server_name = "ec2-${var.environment}-api-${var.variable_sub_az}" # defining the server_name out in here 

}

resource "aws_vpc" "vpc" {

  cidr_block = var.vpc_cidr # defining the cidr_block defined in aws reference from the variable.tf file

  tags = {
    Terraform = "true"
    region = data.aws_region.current.name

  }

}

resource "aws_subnet" "public_subnet" {                                                     # defining the public_subnet over here 
  for_each                = var.public_subnets                                              # iterating with each value of public subnet in the variable.tf file 
  vpc_id                  = aws_vpc.vpc.id                                                  # referencing the vpc_id in this particular case in here 
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)                   # defining the cidr_block in reference to the cidr_block we defined for the vpc from the variable.tf file
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value] # referencing the availability_zone defined in the data block above
  map_public_ip_on_launch = true                                                            # defining the  map_public_ip_on_launch = true in order to map th public ip of the EC2 when associated with the subent

  tags = { # defining the tags over here 

    Name      = each.key # here the name will be refered from the key of the public_subnet_variable we defined in here 
    Terraform = "true"   # setting the Terraform:true over here which will be displayed on the AWS subnet section 

  }

}

resource "aws_subnet" "private_subnets" {
  for_each   = var.private_subnets
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[
  each.value]
  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

resource "aws_route_table" "public_route_table" { # defining the route table as public route table in here as public_route_table

  depends_on = [aws_subnet.public_subnet] #depending on the public_subnet should be created in here 
  vpc_id     = aws_vpc.vpc.id             # referencing the vpc in this case over here

  route {
    cidr_block = "0.0.0.0/0"                                     # defining the cidr_block in here 
    gateway_id = aws_internet_gateway.public_internet_gateway.id # defining the internet_gateway in this case over here
  }

}

resource "aws_route_table" "private_route_table" { # defining the route table as public route table in here as private_route_table

  depends_on = [aws_subnet.private_subnets] #depending on the private_subnet should be created in here 
  vpc_id     = aws_vpc.vpc.id               # referencing the vpc in this case over here

  route {
    cidr_block     = "0.0.0.0/0"                            # defining the cidr_block in here 
    nat_gateway_id = aws_nat_gateway.private_nat_gateway.id # defining the NAT Gateway id to redirect in this case
  }

}


resource "aws_route_table_association" "public_route_association" { # associating the route table with the public subnet
  depends_on     = [aws_subnet.public_subnet]                       #waiting so that public subnet first being created 
  route_table_id = aws_route_table.public_route_table.id            # providing the route table id in this case 
  for_each       = aws_subnet.public_subnet                         # iterating over the public subnet that we have defined 
  subnet_id      = each.value.id                                    # defining the subnet_id in this case as ech value of the public subnet value id 

}

resource "aws_route_table_association" "private_route_association" { # associating the route table with the private subnet
  depends_on     = [aws_subnet.private_subnets]                      #waiting so that private subnet first being created 
  route_table_id = aws_route_table.private_route_table.id            # providing the route table id in this case 
  for_each       = aws_subnet.private_subnets                        # iterating over the private subnet that we have defined 
  subnet_id      = each.value.id                                     # defining the subnet_id in this case as ech value of the public subnet value id 

}


resource "aws_internet_gateway" "public_internet_gateway" { # defining the aws_gateway as the internet gateway in here 

  vpc_id = aws_vpc.vpc.id # defining the aws_vpc in here 

  tags = {            # tags are being defined in this case
    Name = "demo_igw" # providing the name for the same 

  }

}


resource "aws_eip" "nat_gateway_eip" { # defining the EIP for the NAT gteway  over here 
  domain = "vpc"                       # defining the domain as vpc in here 
  #   depends_on = [aws_internet_gateway.internet_gateway] # depend on the AWS internet gateway to be created in here 
  tags = {                # defining the Tags over here in this case
    Name = "demo_igw_eip" # defining the Name of the NAT gateway as the demo_igw in here
  }



}

resource "aws_nat_gateway" "private_nat_gateway" {               # defining the NAT Gateway in this case over here
  depends_on    = [aws_subnet.public_subnet]                     #defining that first the public subnet should be created in here 
  allocation_id = aws_eip.nat_gateway_eip.id                     # here defining the IP as the elastic IP that we are going to create 
  subnet_id     = aws_subnet.public_subnet["public_subnet_1"].id # here defining the subnet where we want to place the NAT gateway
  tags = {                                                       #defining the Tags over here 
    Name = "demo_nat_gateway"                                    # defining the Tags over here 
  }

}


# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "web_server" {

    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet["public_subnet_1"].id
    vpc_security_group_ids = [aws_vpc.vpc.default_security_group_id]

    tags = {
        Name = local.server_name
        Owner = local.team
        App = local.application 
    }

}