provider "aws" { # defining the provider as AWS in this case

  region = "us-west-2" # defining the region as us-west-2 in here

}

data "aws_availability_zones" "available" {} #defining the availablity zone out in here in the data block to query the backend API

data "aws_region" "current" {} #fetching the data using the Data Source as aws_region in this case out in here 


resource "aws_vpc" "vpc" { # defining the aws_vpc as the resource with name as vpc

  cidr_block = var.vpc_cidr # defining the cidr_block from the varibles.tf file

  tags = { # defining the tags in which will be displayed in AWS Managenment console

    Terraform = "true" # defining the Tags in here as Terraform = "true"

  }


}

resource "aws_subnet" "public_subnet" { # defining the aws subnet over here as public subnet

  for_each = var.public_subnet # defining the variable as public subnet in here 

  vpc_id = aws_vpc.vpc.id # referencing the vpc over here as the resource block we created 

  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value) # here defining the cidr_block for the aws_subnet in here 

  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value] # defining the tolist function on order to define the availablity zone that being defined on the dta resource 

  map_public_ip_on_launch = true # mapping the public_ip when the subnet being launched

  tags = { # defining the Tags for the aws_subnet as in this case over here

    Terraform = "true" # defining the key-value pair for the tags in this case 

  }

}

resource "aws_subnet" "private_subnet" {

  for_each = var.public_subnet # defining the variable as public subnet in here 

  vpc_id = aws_vpc.vpc.id # referencing the vpc over here as the resource block we created 

  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value + 100) # here defining the cidr_block for the aws_subnet in here 

  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value] # defining the tolist function on order to define the availablity zone that being defined on the dta resource 

  tags = { # defining the Tags for the aws_subnet as in this case over here

    Terraform = "true" # defining the key-value pair for the tags in this case 

  }

}


resource "aws_internet_gateway" "internet_gateway" { # defining the internet gateway for reference 

  vpc_id = aws_vpc.vpc.id # defining the vpc which it try to reference

  tags = { # defining the tags for the same 

    Name = "internet_gateway"

  }


}

resource "aws_eip" "demo_eip" { # defining the EIP which need to associate with the NAT gateway for the private subnet

  domain = "vpc" # defining the domain as vpc in this case 

  depends_on = [aws_internet_gateway.internet_gateway] # defining the EIP depends on the internet gateway which need to be created first

  tags = {

    Terraform = "true"

  }


}

resource "aws_nat_gateway" "demo_nat_gateway" { # defining the NAT Gateway for reference

  depends_on = [aws_subnet.public_subnet] # it depends on the public subnet as we are associating the NAT way to the public subnet 

  allocation_id = aws_eip.demo_eip.id # associating the EIP with the NAT gateway

  subnet_id = aws_subnet.public_subnet["public_subnet_1"].id # defining the NAT Gatway asociated to the public subnet


  tags = {

    Name = "gw NAT"
  }

}



resource "aws_route_table" "public_route_table" { # defining the route table for the public subnet

  vpc_id = aws_vpc.vpc.id # fetching the vpc_id from referenced VPC

  route { # defining the route for th route table

    cidr_block = "0.0.0.0/0"                              # allowing all the traffic in here
    gateway_id = aws_internet_gateway.internet_gateway.id # redirect to the internet gateway

  }

}


resource "aws_route_table" "private_route_table" {

  vpc_id = aws_vpc.vpc.id # fetching the vpc_id from referenced VPC

  route { # defining the route for th route table

    cidr_block = "0.0.0.0/0"                         #allowing all the traffic in here
    gateway_id = aws_nat_gateway.demo_nat_gateway.id # redirect to the NAT gateway

  }

}

resource "aws_route_table_association" "public_route_association" { # associating the public route table with all the public_subnet in this case 

  depends_on     = [aws_subnet.public_subnet]            # first the public_subnet should be created followed by the aws_route_table_association
  for_each       = aws_subnet.public_subnet              # for every public subnet 
  subnet_id      = each.value.id                         # fetching the subnet_id for ech of the public subnet
  route_table_id = aws_route_table.public_route_table.id # associating the route table with the public subnet which will redirect to internet gateway due to

}

resource "aws_route_table_association" "private_route_association" { # associating the private route table with all the public_subnet in this case 

  depends_on     = [aws_subnet.private_subnet]            # defining that private_subnet should be create first
  for_each       = aws_subnet.private_subnet              # for every private_subnet
  subnet_id      = each.value.id                          # fetching the subnet id
  route_table_id = aws_route_table.private_route_table.id # associating it with the private_route_table which will redirect to the NAT gatway

}




resource "tls_private_key" "private_my_key_pem" { # using the Terraform TLS provider in this case over here

  algorithm = "RSA" # defining the type of Key which will be going to be get created is of RSA

  rsa_bits = 4096 # defining the rsa_bits which will be used for the private_key which will be created   

}

resource "local_file" "file_name" { # here using the Terraform local Provider as the resource block in here

  content = tls_private_key.private_my_key_pem.private_key_pem # setting the content of the file as the private key in the RSA fomat over here in the PEM file format

  filename = "myAWSKey.pem" # setting the filename as the myAWSKey.PEM which will saved to the local directory in here 

}

resource "aws_key_pair" "my_key_pair" {

  key_name = "myAWSKey" # here we are providing the name of the AWS key pair key name which is same as the PEWm file we created earlier

  public_key = tls_private_key.private_my_key_pem.public_key_openssh # this will generate the public-key for the private key we have created  using the same Terraform TLS provider 

  # we can also validate the result in the output block as well as below 

  lifecycle { # here in the way of the lifecycle we can instruct Terraform to ignore the changes if someone made changes to the key_name argument , if someone changes the key_name the resource will not be destroyed and recreted 

    ignore_changes = [key_name] # ignoring the key_name ags in this case inside the resource block
  }

}

resource "aws_security_group" "ingress_ssh" { # creating the aws_security_group in this case over here as below 

  name = "vpc_ssh_connection"

  description = "Security Group for SSH connection onto the Remote SSH"

  vpc_id = aws_vpc.vpc.id # getting the vpc_id using the vpc_id in this case by referencing the aws_vpc resource

  ingress { # definign the ingress rue for the same 

    cidr_blocks = ["0.0.0.0/0"] # defining the cidr_block in this case out in here 

    from_port = 22 # opening the port 22 for the SSH connection

    to_port = 22 # opening the pot 22 for SSH connection

    protocol = "tcp" # defining the protocol as TCP in this case



  }

  egress { # defining the egress rule for the aws_security_group which will overide the default one over here

    from_port = 0 # here allowing all the port to the destination as outbound

    to_port = 0 # here allowing all the port to the destination as outbound

    protocol = "-1" # here -1 signifies that all protocol will be allowed 

    cidr_blocks = ["0.0.0.0/0"] # defining the cidr_block in this case out in here 

  }

}

# similarly we need to define another aws_security_group which will allow web connection hence we need to open the port 80 and 443 for the same 

resource "aws_security_group" "vpc_web" { # defining the aws_security_group resource allowing the web connection as below 

  name = "vpc_web_connection"

  description = "Security Group for HTTP and HTTPS connection onto the Remote EC2"

  vpc_id = aws_vpc.vpc.id # referencing the vpc over in here for the aws_vpc

  ingress { # defining the ingress rule for the http port 

    from_port = 80 # defining the from_port destination for the inbound

    to_port = 80 # defining the to_port in here destination for the inbound

    protocol = "tcp" # allowing the tcp protocol over here 

    cidr_blocks = ["0.0.0.0/0"] # defining the cidr_block to allow all the connection as inbound 

  }

  ingress { # defining the ingress rule for the https port 

    from_port = 443 # opening th port 443 for https connection 

    to_port = 443 # opening the port 443 for https connection

    protocol = "tcp" # defining the protocol as tcp in here 

    cidr_blocks = ["0.0.0.0/0"] # allowing all the port for incoming https connection

  }

  # this will overide the default outboud rule of the security group

  egress { # defining the egress rule for the outbound connection 

    from_port = 0 # defining for all the port as allowed

    to_port = 0 # defining for all the to port as allowed

    protocol = "-1" # here -1 signifies all the protocols are being allowed in thsi case 

    cidr_blocks = ["0.0.0.0/0"] # allowing all the port for the outgoing connection


  }

}


resource "aws_security_group" "vpc_ping" { # defining another security group group in order to implement ping mechanisim using the ICMP internet connectivity network protocol

  name = "vpc_ping_connection" # defining the name for the security group

  description = "Security Group to implement the Ping Mechannism"

  vpc_id = aws_vpc.vpc.id # here providing reference to the vpc in here 

  ingress { # defining the ingress rule in here 

    from_port = -1 #in case of protocol as icmp the port -1 means its irrelevant as we are using the icmp and any port range will be allowed 

    to_port = -1 # in case of protocol as icmp the port -1 means its irrelevant as we are using the icmp and any port range will be allowed 

    protocol = "icmp" # defining the protocol as icmp for the ping mechanism over here 

    cidr_blocks = ["0.0.0.0/0"] # allowing any ip to come as inbound service 

  }

  egress { # defining the egress rule for the outbound connection

    from_port = 0 # allowing all the ports as the outbound 

    to_port = 0 # allowing all the ports as the outbound 

    protocol = "-1" # allowing all the protocol by specifying as -1 

    cidr_blocks = ["0.0.0.0/0"] # defining the cidr_block to allow the IP address for the same 


  }


}

# now here we can define the data block to query the ubuntu instance as below 

data "aws_ami" "ubuntu" { # creating the aws_ami in order to query and get the mai address

  most_recent = true       # if there were multiple ami then the latest one will be considered
  owners      = ["amazon"] # defining the owner as amazon define in terraform registry

  filter { # defining the filter with name values pair in order to filter the query over here 

    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-*"]

  }
  filter { # defining the filter with name value pair

    name   = "virtualization-type"
    values = ["hvm"]

  }

}

resource "aws_instance" "ubuntu_server" {

  ami = data.aws_ami.ubuntu.id # here referencing the data block to fetch the ami id in this case 

  instance_type = "t2.micro" # defining the instance_type in this case out in here 

  subnet_id = aws_subnet.public_subnet["public_subnet_1"].id # fetching the public subnet in this case out in here 

  security_groups = [aws_security_group.ingress_ssh.id, aws_security_group.vpc_web.id, aws_security_group.vpc_ping.id]

  # associating the security group in this case over here 

  associate_public_ip_address = true # we need to associate the public_key on creation as well in this case 

  key_name = aws_key_pair.my_key_pair.key_name

  # associating the aws_key_pair to the AWS EC2 instance in here through the key_name args in this case 

  connection { #defining the connection bblock in order to connect to the Remote-Exec Terraform provisioner to the Remote EC2 instance to execute some command 

    user = "ubuntu" # defining the user as the ubuntu in this case 

    private_key = tls_private_key.private_my_key_pem.private_key_pem # refencing the Terraform TLS Provider block in here 

    host = self.public_ip # defining the public_ip in this case over here as the host which is required params

  }

  # defining the Terraform Provisioner inside the Resource block of aws_instance in this case out in here

  provisioner "local-exec" { # defining the provisioner as the local-exec Terraform provisioner 

    command = "chmod 600  ${local_file.file_name.filename}" # defining the command to change the Access for the PEM key to 600


  }

  provisioner "remote-exec" { # defining the provisioner as the remote-exec provisioner in this case as below 

    inline = [

      "sudo rm -rf /tmp", # removing the tmp folder in this case over here 

      "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp", # copy the git repo to the /tmp folder in here 

      "sudo sh /tmp/assets/setup-web.sh" # executing the bash file to generate the web platform

    ]


  }
  lifecycle {
      
      ignore_changes = [ security_groups ]

    }


}

resource "aws_instance" "web_server" {

    ami = data.aws_ami.ubuntu.id # fetching the ami from the ubuntu image that we are going to create in this case 
    instance_type = "t2.micro" # fetching the instance_type for the Size of the EC2 instance VM
    subnet_id = aws_subnet.public_subnet["public_subnet_1"].id # fetching the subnet using the pubic_subnet we have created 
    security_groups = [ aws_security_group.ingress_ssh.id , aws_security_group.vpc_web.id, aws_security_group.vpc_ping.id ]
    # associating the security group in this case over here so that SSH,HTTP and HTTPS connection will be allowed 
    key_name = aws_key_pair.my_key_pair.key_name # associating the aws_key_pair with the aws_instance
    associate_public_ip_address = true # associating the public ip in this case over here 

    connection { # defining the connection block for the SSH connection for the remote user
        user= "ubuntu"  # using the username as ubuntu in this case out in here
        private_key= tls_private_key.private_my_key_pem.private_key_pem # here defining the private_key in this case out in here 
        host= self.public_ip # defining the public_ip in this case over here 
      
    }

    provisioner "local-exec" { # defining the local-exec provisioner in this case out in here 
       command = "chmod 600 ${local_file.file_name.filename}" 
       # here adding one command which will be executed in the local command line in this case 
    }

    provisioner "remote-exec" { # defining the remote-exec provisioner in this case out in here 

        inline = [

            "sudo rm -rf /tmp", # removing the tmp folder in this case over here 

            "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp", # copy the git repo to the /tmp folder in here 

            "sudo sh /tmp/assets/setup-web.sh" # executing the bash file to generate the web platform

        ]
      
    }

    tags = { # defining the Tags in this case out in here as below 

        Name = "Web Ec2 Instance"


    }

    lifecycle {
      
      ignore_changes = [ security_groups ]

    }

}