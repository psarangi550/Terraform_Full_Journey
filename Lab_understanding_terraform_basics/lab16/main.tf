provider "aws" { # defining the provider as the aws in here

  region = "us-east-1" # here we are using the region as us-east-1

  default_tags { # defining the default_tags which will be applied to all the resource

    tags = {
      Environment = terraform.workspace
      OWNER       = "Acme"
      PROVIDER    = "Terraform"

    }

  }

}


data "aws_availability_zones" "available" {} # defining the data block to query the az available in the region

resource "aws_vpc" "vpc" { # defining the AWS Subnet in here 

  cidr_block = var.vpc_cidr # defining the cidr_block as reference to the variable block

  tags = { # defining the tags applied on the VPC

    NAME = "AWS VPC"
  }
}

resource "aws_subnet" "public_subnet" { # defining the public subnet in this case out in here

  for_each                = var.public_subnets                                              # here defining that for each public subnet defined in variables.td 
  vpc_id                  = aws_vpc.vpc.id                                                  # referencing the VPC ID in this case 
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)                   # defining the subnet_id for the all the public_subnet
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value] # defining the availabity_zone for the aws_subnet
  map_public_ip_on_launch = true                                                            # mapping the Public_ip ince associated with EC2

  tags = { # providing the Tags in this case

    Terraform = "true"
  }


}

resource "aws_subnet" "private_subnet" { # defining the private_subent inside the VPC that we have created 

  for_each          = var.private_subnets                                             # refercing the all the private_subnet in this case
  vpc_id            = aws_vpc.vpc.id                                                  # referecing vpc that we have created
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)                         # defining the cidr_block using the cidrsubnet()
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value] # defining the availabity_zone using the data block

  tags = {

    Terraform = "true"
  }


}

resource "aws_internet_gateway" "demote_igw" { # defining the internet gateway that will be created

  vpc_id = aws_vpc.vpc.id # defining the vpc_id for the aws_vpc reference

  tags = { # defining the Tags in this case out in here 

    Name = "demo_igw"

  }
}

resource "aws_eip" "nat_gateway_eip" { # creating the AWS EIP in this case out in here 

  domain = "vpc" # defining the domain as VPC in this case out in here

  depends_on = [aws_internet_gateway.demote_igw] # depends on the internet gateway to be created first

  tags = { # defining the Tags in here 
    Name = "demo_igw_eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_subnet.public_subnet]                     # it depends on first the public_subnet need to be created
  allocation_id = aws_eip.nat_gateway_eip.id                     # fetching the allocation_adddress as the EIP that we have created earlier
  subnet_id     = aws_subnet.public_subnet["public_subnet_1"].id # defining the subnet_id map to the NAT gateway which is in the public subnet

  tags = { # defining the Tags in this case cas well
    Name = "demo_nat_gateway"
  }
}




resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.vpc.id # defining the AWS vpc reference in this case out in here 

  route {

    cidr_block = "0.0.0.0/0"                        # allowing all the IP address in this case 
    gateway_id = aws_internet_gateway.demote_igw.id # mapping all the traffic to the internet gateway in this case

  }

}

resource "aws_route_table" "private_route_table" {

  vpc_id = aws_vpc.vpc.id # defining the AWS vpc reference in this case out in here 

  route {

    cidr_block = "0.0.0.0/0"                    # allowing all the IP address in this case 
    gateway_id = aws_nat_gateway.nat_gateway.id # mapping all the traffic to the NAT gateway in this case

  }

}

resource "aws_route_table_association" "public_route_association" {

  depends_on     = [aws_subnet.public_subnet]            # depends on the public_subnet should be created first
  for_each       = aws_subnet.public_subnet              # defining the for each loop for all the subnet in this case
  subnet_id      = each.value.id                         # fetching each of the public_subnet with their id in  this case
  route_table_id = aws_route_table.public_route_table.id # maaping the public_route table to the each of the public subnet


}

resource "aws_route_table_association" "private_route_association" {

  depends_on     = [aws_subnet.private_subnet] # deoend on the private_subnet to be created in this case
  route_table_id = aws_route_table.private_route_table.id
  for_each       = aws_subnet.private_subnet # mapping the each private_subnet in this case out in here 
  subnet_id      = each.value.id              # here defining the subnet_id for each private_subnet

}

# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true # defining the data block to fetch the ami for the ubuntu-20.04 using the data block in this case
  filter {           # using the filter with name and values pair
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter { # using the filter with name and values pair

    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # defining the owners in this case out in here

}


resource "tls_private_key" "generated" {

  algorithm = "RSA" # defining  the algorithm which being used
  rsa_bits  = 4096  # defining the bits used for creating the private key
}

resource "local_file" "private_key_pem" {

  content  = tls_private_key.generated.private_key_pem # getting the private content from the tls_private_key provider 
  filename = "MyAWSKey.pem"                            # defining the PEM file to which the Private Key will be saved
}

resource "aws_key_pair" "generated" { # defining the aws_key_pair in this case out in here 

  key_name   = "myAWSKey"                                   # defining nthe name for the key-pair in AWS management console
  public_key = tls_private_key.generated.public_key_openssh # associating the public key with the AWS key pair

  lifecycle { # defining the lifecycle when the resources will not be re-create upon change

    ignore_changes = [key_name] # if the key_name changed then the aws_key_pair resource will not change
  }


}

resource "aws_security_group" "ingress-ssh" {
  name   = "allow-all-ssh" # defining the name for the secutiry group
  vpc_id = aws_vpc.vpc.id  # referencing the AWS VPC in this case out in here 
  ingress {                # defining the ingress rule out in here 
    cidr_blocks = [        # allowing all the IP addess for the ssh into it
      "0.0.0.0/0"
    ]
    from_port = 22    # allowing port 22 in this case
    to_port   = 22    # allowing the port 22 in this case 
    protocol  = "tcp" # protocol used as the tcp over here
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0             # allowing all the ports in here
    to_port     = 0             # allowing all the ports to go out
    protocol    = "-1"          # here the protocol can be anything which specified by -1
    cidr_blocks = ["0.0.0.0/0"] # allowing all the IP to go out
  }
}

# Create Security Group - Web Traffic
resource "aws_security_group" "vpc-web" {        # defining the security group for the web server
  name        = "vpc-web-${terraform.workspace}" # defining the name based on the terraform workspace interpolation
  vpc_id      = aws_vpc.vpc.id                   # referencing the VPC ID for the same 
  description = "Web Traffic"                    # providing the description for the same 
  ingress {                                      # defining the ingress in bound rule in here 
    description = "Allow Port 80"                # allowing the Http Port in this case 
    from_port   = 80                             # allowing the Port 80 for http connection 
    to_port     = 80                             # allowing the Port 80 for http connection 
    protocol    = "tcp"                          # defining the protocol as tcp
    cidr_blocks = ["0.0.0.0/0"]                  # allowing all the IP in this case
  }
  ingress {                        # defining the another ingress in bound rule in here 
    description = "Allow Port 443" # allowing the port 443 for https connection
    from_port   = 443              # opening the port 443
    to_port     = 443              # opening the port 443 in this case
    protocol    = "tcp"            # defining the protocol as TCP in this case
    cidr_blocks = ["0.0.0.0/0"]    # allowing all the IP address in this case
  }
  egress {                                          # using the egress rule for the outbound traffic
    description = "Allow all ip and ports outbound" # overiding the outbound rule in here
    from_port   = 0                                 # allowing all the port to be open
    to_port     = 0                                 # allowing all the port to be open
    protocol    = "-1"                              # here -1 signifies open all the protocol in here
    cidr_blocks = ["0.0.0.0/0"]                     # defining the CIDR block for this case
  }
}


# Terraform Resource Block - Security Group to Allow Ping Traffic
resource "aws_security_group" "vpc-ping" { # defining the secrity group for the PING
  name        = "vpc-ping"                 # name of the security group defined in here 
  vpc_id      = aws_vpc.vpc.id             # referencing the VPC id in here
  description = "ICMP for Ping Access"     # defining the description  of the aws_security_group
  ingress {                                # defining the ingreess rule
    description = "Allow ICMP Traffic"
    from_port   = -1            # here the port does not matter as we are using the ICMP protol hence provided as -1
    to_port     = -1            # here the port does not matter as we are using the ICMP protol hence provided as -1
    protocol    = "icmp"        # protocol used as icmp
    cidr_blocks = ["0.0.0.0/0"] # allowing all the Public IP in here
  }
  egress {
    description = "Allow all ip and ports outboun" # defining the outbound rule to overide the default securioty group rule
    from_port   = 0                                # open all the port 
    to_port     = 0                                # open all the port
    protocol    = "-1"                             # all protocol are allowed 
    cidr_blocks = ["0.0.0.0/0"]                    # open any IP address to go out
  }
}

# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {
  ami             = data.aws_ami.ubuntu.id                                                                             # defining the aws_ami data block for the ami reference
  instance_type   = "t2.micro"                                                                                         # defining the size of the EC2 instance
  subnet_id       = aws_subnet.public_subnet["public_subnet_1"].id                                                     # defining the subnet_id we want to associate to the EC2 instance
  security_groups = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id] # associating the security_group to the EC2 instance
  key_name        = aws_key_pair.generated.key_name                                                                    # associating the aws_key_pair to the EC2 instance
  connection {                                                                                                         # defining the connection with username and host in order to connect the remote-exec provisioner to the remote EC2 instance
    user        = "ubuntu"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }
  associate_public_ip_address = true # associating the public_ip when the EC2 instance get launched
  tags = {                           # defining the Tags for the EC2 instance
    Name = "Web EC2 Server"
  }
  provisioner "local-exec" { # defining the local-exec provisioner which will be executed in the terraform apply terminal locally
    command = "chmod 600 ${local_file.private_key_pem.filename}"
  }
  provisioner "remote-exec" { # defining the remote-exec provisioner which will be executed in EC2 terminal
    inline = [                # defining number of command as list inside inline argument
      "git clone https://github.com/hashicorp/demo-terraform-101",
      "cp -a demo-terraform-101/. /tmp/",
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }
}