# Lab: Terraform State Command 

- `terraform state` is `CLI command` that `allow us to interact `with the `Terraform state file`

- as we know that `terraform is a stateful architecture` i.e `any resource that Terraform create and manage` lives in an `inventory file` known as the `Terraform state file`

- the `Terraform state` saved locally inside the file with the extension as `*.tfstate` file in this case over here 

- we can also have the `backup of the state file (*.tfstate) file` , when `Terraform apply` been applied, some info will be create a `new version of Terraform state backup` and saved into the `terraform state backup file`

- if we are looking into the `Terraform state file` i.e `*.tfstate` file then that will be in the `JSON` format 

-  it capture below info inside the `Terraform state file` i.e `*.tfstate` file as `JSON` below 

    - `what version of Terraform` being used for `creating the resource ` using the key as `terraform_version`
    
    - it also capture the `info about the resources` that being created using the `terraform configuration`
    
- `terraform statefile` is absolute `critical` for the `terraform configuration` for managing the `resources`

- the `terraform state` `CLI command line` allow us to `interact` with the `terraform statefile` that being saved in this case out in here 

- we can use the `terraform state` `CLI command line` allow us to `interact` with the `terraform statefile` without interact with the `Terraform state JSON format file`

- it is highly recomended not to amend in the Terraform statefile JSON content and format

- **Lab**

    - we can deploy the `terraform configuration` as ealier section in order to interact with the `terraform State` using the `terraform state CLI`
    
    - we can define the `terraform configuration` and `variable and provider` as below in this case as

        ```tf
            terraform.tf
            ============
            terraform {

                required_version = ">1.0.0" # defining the terraform core version in this case 

                required_providers {
                    aws = {
                        source = "hashicorp/aws" # defining the aws module with the source version in  this case as below 
                    }
                    http = {
                    source = "hashicorp/http" # defining the terraform http provider that we want to interact with 
                    version = "3.4.0" # defining the version for the terraform version in this case
                    }
                    random = {
                    source = "hashicorp/random" # defining the terraform random provider in this case as below
                    version = "3.5.1" # defining the terraform random module in this case out in here 
                    }
                    local = {
                    source = "hashicorp/local" # defining the Terraform local version in this case out in here
                    version = "2.4.0" # defining the version of the Terraform Local version in this case 
                    }
                    tls = {
                    source = "hashicorp/tls" # defining the terraform TLS provider in this case out in here  
                    version = "4.0.4" # defining the version of the Terraform TLS provider we will be using 
                    }
                    }

            }
        
        
        ```

        - we can define the `variables.tf` in this case as below 

        ```tf
            variables.tf
            ============
            variable "aws_region" { # defining the aws_region as the variable in here 
                type = string
                default = "us-east-1"
            }

            variable "vpc_name" {
            type = string
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
        
        
        ```


        ```tf
            main.tf
            =======
            provider "aws" { # defining the provider as the aws in here

                region = "us-east-1" # here we are using the region as us-east-1

                default_tags { # defining the default_tags which will be applied to all the resource
                
                tags = {
                    Environment = terraform.workspace
                    OWNER = "Acme"
                    PROVIDER = "Terraform"

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

                for_each = var.public_subnets # here defining that for each public subnet defined in variables.td 
                vpc_id = aws_vpc.vpc.id # referencing the VPC ID in this case 
                cidr_block = cidrsubnet(var.vpc_cidr,8,each.value +100) # defining the subnet_id for the all the public_subnet
                availability_zone = tolist(data.aws_availability_zones.available.names)[each.value] # defining the availabity_zone for the aws_subnet
                map_public_ip_on_launch = true # mapping the Public_ip ince associated with EC2

                tags = { # providing the Tags in this case

                    Terraform = "true"
                }


            }

            resource "aws_subnet" "private_subnet" { # defining the private_subent inside the VPC that we have created 

                for_each = var.private_subnets # refercing the all the private_subnet in this case
                vpc_id = aws_vpc.vpc.id # referecing vpc that we have created
                cidr_block = cidrsubnet(var.vpc_cidr,8,each.value) # defining the cidr_block using the cidrsubnet()
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
                depends_on = [aws_subnet.public_subnet] # it depends on first the public_subnet need to be created
                allocation_id = aws_eip.nat_gateway_eip.id # fetching the allocation_adddress as the EIP that we have created earlier
                subnet_id = aws_subnet.public_subnet["public_subnet_1"].id # defining the subnet_id map to the NAT gateway which is in the public subnet
                
                tags = {  # defining the Tags in this case cas well
                    Name = "demo_nat_gateway"
                }
            }




            resource "aws_route_table" "public_route_table" {

                vpc_id = aws_vpc.vpc.id # defining the AWS vpc reference in this case out in here 

                route {

                    cidr_block = "0.0.0.0/0" # allowing all the IP address in this case 
                    gateway_id = aws_internet_gateway.demote_igw.id # mapping all the traffic to the internet gateway in this case

                }

            }

            resource "aws_route_table" "private_route_table" {

                vpc_id = aws_vpc.vpc.id # defining the AWS vpc reference in this case out in here 

                route {

                    cidr_block = "0.0.0.0/0" # allowing all the IP address in this case 
                    gateway_id = aws_nat_gateway.nat_gateway.id # mapping all the traffic to the NAT gateway in this case

                }

            }

            resource "aws_route_table_association" "public_route_association" {
                
                depends_on = [aws_subnet.public_subnet] # depends on the public_subnet should be created first
                for_each = aws_subnet.public_subnet # defining the for each loop for all the subnet in this case
                subnet_id = each.value.id # fetching each of the public_subnet with their id in  this case
                route_table_id = aws_route_table.public_route_table.id # maaping the public_route table to the each of the public subnet


            }

            resource "aws_route_table_association" "private_route_association" {
                
                depends_on = [aws_subnet.private_subnets] # deoend on the private_subnet to be created in this case
                route_table_id = aws_route_table.private_route_table.id 
                for_each = aws_subnet.private_subnets # mapping the each private_subnet in this case out in here 
                subnet_id = each.value.id # here defining the subnet_id for each private_subnet

            }

            # Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
            data "aws_ami" "ubuntu" {
                most_recent = true # defining the data block to fetch the ami for the ubuntu-20.04 using the data block in this case
                filter { # using the filter with name and values pair
                    name = "name"
                    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
                }
            
                filter { # using the filter with name and values pair
                    
                    name = "virtualization-type"
                    values = ["hvm"]
                }
                
                owners = ["099720109477"] # defining the owners in this case out in here
                
                }

            
            resource "tls_private_key" "generated" {

                algorithm = "RSA" # defining  the algorithm which being used
                rsa_bits = 4096 # defining the bits used for creating the private key
            }

            resource "local_file" "private_key_pem" {
                
                content = tls_private_key.generated.private_key_pem # getting the private content from the tls_private_key provider 
                filename = "MyAWSKey.pem" # defining the PEM file to which the Private Key will be saved
            }

            resource "aws_key_pair" "generated" { # defining the aws_key_pair in this case out in here 

                key_name = "myAWSKey" # defining nthe name for the key-pair in AWS management console
                public_key = tls_private_key.generated.public_key_openssh # associating the public key with the AWS key pair

                lifecycle { # defining the lifecycle when the resources will not be re-create upon change

                    ignore_changes = [key_name] # if the key_name changed then the aws_key_pair resource will not change
                }


            }

            resource "aws_security_group" "ingress-ssh" {
                name = "allow-all-ssh" # defining the name for the secutiry group
                vpc_id = aws_vpc.vpc.id # referencing the AWS VPC in this case out in here 
                ingress { # defining the ingress rule out in here 
                    cidr_blocks = [ # allowing all the IP addess for the ssh into it
                    "0.0.0.0/0"
                    ]
                    from_port = 22 # allowing port 22 in this case
                    to_port = 22 # allowing the port 22 in this case 
                    protocol = "tcp" # protocol used as the tcp over here
                }
                // Terraform removes the default rule
                egress {
                    from_port = 0 # allowing all the ports in here
                    to_port = 0 # allowing all the ports to go out
                    protocol = "-1" # here the protocol can be anything which specified by -1
                    cidr_blocks = ["0.0.0.0/0"] # allowing all the IP to go out
                }
                }

            # Create Security Group - Web Traffic
            resource "aws_security_group" "vpc-web" { # defining the security group for the web server
                name = "vpc-web-${terraform.workspace}" # defining the name based on the terraform workspace interpolation
                vpc_id = aws_vpc.vpc.id # referencing the VPC ID for the same 
                description = "Web Traffic" # providing the description for the same 
                ingress { # defining the ingress in bound rule in here 
                    description = "Allow Port 80" # allowing the Http Port in this case 
                    from_port = 80 # allowing the Port 80 for http connection 
                    to_port = 80 # allowing the Port 80 for http connection 
                    protocol = "tcp" # defining the protocol as tcp
                    cidr_blocks = ["0.0.0.0/0"] # allowing all the IP in this case
                }
                ingress { # defining the another ingress in bound rule in here 
                    description = "Allow Port 443" # allowing the port 443 for https connection
                    from_port = 443 # opening the port 443
                    to_port = 443 # opening the port 443 in this case
                    protocol = "tcp" # defining the protocol as TCP in this case
                    cidr_blocks = ["0.0.0.0/0"] # allowing all the IP address in this case
                }
            egress { # using the egress rule for the outbound traffic
                description = "Allow all ip and ports outbound" # overiding the outbound rule in here
                from_port = 0 # allowing all the port to be open
                to_port = 0 # allowing all the port to be open
                protocol = "-1" # here -1 signifies open all the protocol in here
                cidr_blocks = ["0.0.0.0/0"] # defining the CIDR block for this case
            }
            }
            

            # Terraform Resource Block - Security Group to Allow Ping Traffic
        resource "aws_security_group" "vpc-ping" { # defining the secrity group for the PING
            name = "vpc-ping" # name of the security group defined in here 
            vpc_id = aws_vpc.vpc.id # referencing the VPC id in here
            description = "ICMP for Ping Access" # defining the description  of the aws_security_group
            ingress { # defining the ingreess rule
                description = "Allow ICMP Traffic"
                from_port = -1 # here the port does not matter as we are using the ICMP protol hence provided as -1
                to_port = -1 # here the port does not matter as we are using the ICMP protol hence provided as -1
                protocol = "icmp" # protocol used as icmp
                cidr_blocks = ["0.0.0.0/0"] # allowing all the Public IP in here
            }
            egress {
                description = "Allow all ip and ports outboun" # defining the outbound rule to overide the default securioty group rule
                from_port = 0 # open all the port 
                to_port = 0 # open all the port
                protocol = "-1" # all protocol are allowed 
                cidr_blocks = ["0.0.0.0/0"] # open any IP address to go out
            }
        }

            # Terraform Resource Block - To Build EC2 instance in Public Subnet
            resource "aws_instance" "web_server" {
                ami = data.aws_ami.ubuntu.id # defining the aws_ami data block for the ami reference
                instance_type = "t2.micro" # defining the size of the EC2 instance
                subnet_id = aws_subnet.public_subnet["public_subnet_1"].id # defining the subnet_id we want to associate to the EC2 instance
                security_groups = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id] # associating the security_group to the EC2 instance
                key_name = aws_key_pair.generated.key_name # associating the aws_key_pair to the EC2 instance
                connection { # defining the connection with username and host in order to connect the remote-exec provisioner to the remote EC2 instance
                    user = "ubuntu"
                    private_key = tls_private_key.generated.private_key_pem
                    host = self.public_ip
                }
                associate_public_ip_address = true # associating the public_ip when the EC2 instance get launched
                tags = { # defining the Tags for the EC2 instance
                    Name = "Web EC2 Server"
                }
                provisioner "local-exec" { # defining the local-exec provisioner which will be executed in the terraform apply terminal locally
                    command = "chmod 600 ${local_file.private_key_pem.filename}"
                }
                provisioner "remote-exec" { # defining the remote-exec provisioner which will be executed in EC2 terminal
                    inline = [ # defining number of command as list inside inline argument
                            "git clone https://github.com/hashicorp/demo-terraform-101",
                            "cp -a demo-terraform-101/. /tmp/",
                            "sudo sh /tmp/assets/setup-web.sh",
                        ]
                }
            }
            


        ```


- we can apply the `terraform init` command to initialize the `Terraform provider` in this case out in here 

- we can also run the `terraform init` as below to `install and use the Required Terraform provider` as below 

    ```bash
        terraform init 
        # using the terraform init to download and install the Terraform provider in this case 
        # below will be the output for the same 
        Initializing the backend...

        Initializing provider plugins...
        - Finding hashicorp/tls versions matching "4.0.4"...
        - Finding latest version of hashicorp/aws...
        - Finding hashicorp/http versions matching "3.4.0"...
        - Finding hashicorp/random versions matching "3.5.1"...
        - Finding hashicorp/local versions matching "2.4.0"...
        - Installing hashicorp/random v3.5.1...
        - Installed hashicorp/random v3.5.1 (signed by HashiCorp)
        - Installing hashicorp/local v2.4.0...
        - Installed hashicorp/local v2.4.0 (signed by HashiCorp)
        - Installing hashicorp/tls v4.0.4...
        - Installed hashicorp/tls v4.0.4 (signed by HashiCorp)
        - Installing hashicorp/aws v5.26.0...
        - Installed hashicorp/aws v5.26.0 (signed by HashiCorp)
        - Installing hashicorp/http v3.4.0...
        - Installed hashicorp/http v3.4.0 (signed by HashiCorp)

        Terraform has created a lock file .terraform.lock.hcl to record the provider
        selections it made above. Include this file in your version control repository
        so that Terraform can guarantee to make the same selections by default when
        you run "terraform init" in the future.

        Terraform has been successfully initialized!

        You may now begin working with Terraform. Try running "terraform plan" to see
        any changes that are required for your infrastructure. All Terraform commands
        should now work.

        If you ever set or change modules or backend configuration for Terraform,
        rerun this command to reinitialize your working directory. If you forget, other
        commands will detect it and remind you to do so if necessary.


        # we can use the terraform apply -auto-approve to deploy the infrastructure as below 
        terraform apply -auto-approve
        # below will be the output in this case out in here 
        data.aws_availability_zones.available: Reading...
        data.aws_ami.ubuntu: Reading...
        data.aws_availability_zones.available: Read complete after 2s [id=us-east-1]
        data.aws_ami.ubuntu: Read complete after 2s [id=ami-00d321eaa8a8a4640]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

        # aws_eip.nat_gateway_eip will be created
        + resource "aws_eip" "nat_gateway_eip" {
            + allocation_id        = (known after apply)
            + association_id       = (known after apply)
            + carrier_ip           = (known after apply)
            + customer_owned_ip    = (known after apply)
            + domain               = "vpc"
            + id                   = (known after apply)
            + instance             = (known after apply)
            + network_border_group = (known after apply)
            + network_interface    = (known after apply)
            + private_dns          = (known after apply)
            + private_ip           = (known after apply)
            + public_dns           = (known after apply)
            + public_ip            = (known after apply)
            + public_ipv4_pool     = (known after apply)
            + tags                 = {
                + "Name" = "demo_igw_eip"
                }
            + tags_all             = {
                + "Environment" = "default"
                + "Name"        = "demo_igw_eip"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            + vpc                  = (known after apply)
            }

        # aws_instance.web_server will be created
        + resource "aws_instance" "web_server" {
            + ami                                  = "ami-00d321eaa8a8a4640"
            + arn                                  = (known after apply)
            + associate_public_ip_address          = true
            + availability_zone                    = (known after apply)
            + cpu_core_count                       = (known after apply)
            + cpu_threads_per_core                 = (known after apply)
            + disable_api_stop                     = (known after apply)
            + disable_api_termination              = (known after apply)
            + ebs_optimized                        = (known after apply)
            + get_password_data                    = false
            + host_id                              = (known after apply)
            + host_resource_group_arn              = (known after apply)
            + iam_instance_profile                 = (known after apply)
            + id                                   = (known after apply)
            + instance_initiated_shutdown_behavior = (known after apply)
            + instance_lifecycle                   = (known after apply)
            + instance_state                       = (known after apply)
            + instance_type                        = "t2.micro"
            + ipv6_address_count                   = (known after apply)
            + ipv6_addresses                       = (known after apply)
            + key_name                             = "myAWSKey"
            + monitoring                           = (known after apply)
            + outpost_arn                          = (known after apply)
            + password_data                        = (known after apply)
            + placement_group                      = (known after apply)
            + placement_partition_number           = (known after apply)
            + primary_network_interface_id         = (known after apply)
            + private_dns                          = (known after apply)
            + private_ip                           = (known after apply)
            + public_dns                           = (known after apply)
            + public_ip                            = (known after apply)
            + secondary_private_ips                = (known after apply)
            + security_groups                      = (known after apply)
            + source_dest_check                    = true
            + spot_instance_request_id             = (known after apply)
            + subnet_id                            = (known after apply)
            + tags                                 = {
                + "Name" = "Web EC2 Server"
                }
            + tags_all                             = {
                + "Environment" = "default"
                + "Name"        = "Web EC2 Server"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            + tenancy                              = (known after apply)
            + user_data                            = (known after apply)
            + user_data_base64                     = (known after apply)
            + user_data_replace_on_change          = false
            + vpc_security_group_ids               = (known after apply)
            }

        # aws_internet_gateway.demote_igw will be created
        + resource "aws_internet_gateway" "demote_igw" {
            + arn      = (known after apply)
            + id       = (known after apply)
            + owner_id = (known after apply)
            + tags     = {
                + "Name" = "demo_igw"
                }
            + tags_all = {
                + "Environment" = "default"
                + "Name"        = "demo_igw"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            + vpc_id   = (known after apply)
            }

        # aws_key_pair.generated will be created
        + resource "aws_key_pair" "generated" {
            + arn             = (known after apply)
            + fingerprint     = (known after apply)
            + id              = (known after apply)
            + key_name        = "myAWSKey"
            + key_name_prefix = (known after apply)
            + key_pair_id     = (known after apply)
            + key_type        = (known after apply)
            + public_key      = (known after apply)
            + tags_all        = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            }

        # aws_nat_gateway.nat_gateway will be created
        + resource "aws_nat_gateway" "nat_gateway" {
            + allocation_id                      = (known after apply)
            + association_id                     = (known after apply)
            + connectivity_type                  = "public"
            + id                                 = (known after apply)
            + network_interface_id               = (known after apply)
            + private_ip                         = (known after apply)
            + public_ip                          = (known after apply)
            + secondary_private_ip_address_count = (known after apply)
            + secondary_private_ip_addresses     = (known after apply)
            + subnet_id                          = (known after apply)
            + tags                               = {
                + "Name" = "demo_nat_gateway"
                }
            + tags_all                           = {
                + "Environment" = "default"
                + "Name"        = "demo_nat_gateway"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            }

        # aws_route_table.private_route_table will be created
        + resource "aws_route_table" "private_route_table" {
            + arn              = (known after apply)
            + id               = (known after apply)
            + owner_id         = (known after apply)
            + propagating_vgws = (known after apply)
            + route            = [
                + {
                    + carrier_gateway_id         = ""
                    + cidr_block                 = "0.0.0.0/0"
                    + core_network_arn           = ""
                    + destination_prefix_list_id = ""
                    + egress_only_gateway_id     = ""
                    + gateway_id                 = (known after apply)
                    + ipv6_cidr_block            = ""
                    + local_gateway_id           = ""
                    + nat_gateway_id             = ""
                    + network_interface_id       = ""
                    + transit_gateway_id         = ""
                    + vpc_endpoint_id            = ""
                    + vpc_peering_connection_id  = ""
                    },
                ]
            + tags_all         = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            + vpc_id           = (known after apply)
            }

        # aws_route_table.public_route_table will be created
        + resource "aws_route_table" "public_route_table" {
            + arn              = (known after apply)
            + id               = (known after apply)
            + owner_id         = (known after apply)
            + propagating_vgws = (known after apply)
            + route            = [
                + {
                    + carrier_gateway_id         = ""
                    + cidr_block                 = "0.0.0.0/0"
                    + core_network_arn           = ""
                    + destination_prefix_list_id = ""
                    + egress_only_gateway_id     = ""
                    + gateway_id                 = (known after apply)
                    + ipv6_cidr_block            = ""
                    + local_gateway_id           = ""
                    + nat_gateway_id             = ""
                    + network_interface_id       = ""
                    + transit_gateway_id         = ""
                    + vpc_endpoint_id            = ""
                    + vpc_peering_connection_id  = ""
                    },
                ]
            + tags_all         = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            + vpc_id           = (known after apply)
            }

        # aws_route_table_association.private_route_association["private_subnet_1"] will be created
        + resource "aws_route_table_association" "private_route_association" {
            + id             = (known after apply)
            + route_table_id = (known after apply)
            + subnet_id      = (known after apply)
            }

        # aws_route_table_association.private_route_association["private_subnet_2"] will be created
        + resource "aws_route_table_association" "private_route_association" {
            + id             = (known after apply)
            + route_table_id = (known after apply)
            + subnet_id      = (known after apply)
            }

        # aws_route_table_association.private_route_association["private_subnet_3"] will be created
        + resource "aws_route_table_association" "private_route_association" {
            + id             = (known after apply)
            + route_table_id = (known after apply)
            + subnet_id      = (known after apply)
            }

        # aws_route_table_association.public_route_association["public_subnet_1"] will be created
        + resource "aws_route_table_association" "public_route_association" {
            + id             = (known after apply)
            + route_table_id = (known after apply)
            + subnet_id      = (known after apply)
            }

        # aws_route_table_association.public_route_association["public_subnet_2"] will be created
        + resource "aws_route_table_association" "public_route_association" {
            + id             = (known after apply)
            + route_table_id = (known after apply)
            + subnet_id      = (known after apply)
            }

        # aws_route_table_association.public_route_association["public_subnet_3"] will be created
        + resource "aws_route_table_association" "public_route_association" {
            + id             = (known after apply)
            + route_table_id = (known after apply)
            + subnet_id      = (known after apply)
            }

        # aws_security_group.ingress-ssh will be created
        + resource "aws_security_group" "ingress-ssh" {
            + arn                    = (known after apply)
            + description            = "Managed by Terraform"
            + egress                 = [
                + {
                    + cidr_blocks      = [
                        + "0.0.0.0/0",
                        ]
                    + description      = ""
                    + from_port        = 0
                    + ipv6_cidr_blocks = []
                    + prefix_list_ids  = []
                    + protocol         = "-1"
                    + security_groups  = []
                    + self             = false
                    + to_port          = 0
                    },
                ]
            + id                     = (known after apply)
            + ingress                = [
                + {
                    + cidr_blocks      = [
                        + "0.0.0.0/0",
                        ]
                    + description      = ""
                    + from_port        = 22
                    + ipv6_cidr_blocks = []
                    + prefix_list_ids  = []
                    + protocol         = "tcp"
                    + security_groups  = []
                    + self             = false
                    + to_port          = 22
                    },
                ]
            + name                   = "allow-all-ssh"
            + name_prefix            = (known after apply)
            + owner_id               = (known after apply)
            + revoke_rules_on_delete = false
            + tags_all               = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            + vpc_id                 = (known after apply)
            }

        # aws_security_group.vpc-ping will be created
        + resource "aws_security_group" "vpc-ping" {
            + arn                    = (known after apply)
            + description            = "ICMP for Ping Access"
            + egress                 = [
                + {
                    + cidr_blocks      = [
                        + "0.0.0.0/0",
                        ]
                    + description      = "Allow all ip and ports outboun"
                    + from_port        = 0
                    + ipv6_cidr_blocks = []
                    + prefix_list_ids  = []
                    + protocol         = "-1"
                    + security_groups  = []
                    + self             = false
                    + to_port          = 0
                    },
                ]
            + id                     = (known after apply)
            + ingress                = [
                + {
                    + cidr_blocks      = [
                        + "0.0.0.0/0",
                        ]
                    + description      = "Allow ICMP Traffic"
                    + from_port        = -1
                    + ipv6_cidr_blocks = []
                    + prefix_list_ids  = []
                    + protocol         = "icmp"
                    + security_groups  = []
                    + self             = false
                    + to_port          = -1
                    },
                ]
            + name                   = "vpc-ping"
            + name_prefix            = (known after apply)
            + owner_id               = (known after apply)
            + revoke_rules_on_delete = false
            + tags_all               = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            + vpc_id                 = (known after apply)
            }

        # aws_security_group.vpc-web will be created
        + resource "aws_security_group" "vpc-web" {
            + arn                    = (known after apply)
            + description            = "Web Traffic"
            + egress                 = [
                + {
                    + cidr_blocks      = [
                        + "0.0.0.0/0",
                        ]
                    + description      = "Allow all ip and ports outbound"
                    + from_port        = 0
                    + ipv6_cidr_blocks = []
                    + prefix_list_ids  = []
                    + protocol         = "-1"
                    + security_groups  = []
                    + self             = false
                    + to_port          = 0
                    },
                ]
            + id                     = (known after apply)
            + ingress                = [
                + {
                    + cidr_blocks      = [
                        + "0.0.0.0/0",
                        ]
                    + description      = "Allow Port 443"
                    + from_port        = 443
                    + ipv6_cidr_blocks = []
                    + prefix_list_ids  = []
                    + protocol         = "tcp"
                    + security_groups  = []
                    + self             = false
                    + to_port          = 443
                    },
                + {
                    + cidr_blocks      = [
                        + "0.0.0.0/0",
                        ]
                    + description      = "Allow Port 80"
                    + from_port        = 80
                    + ipv6_cidr_blocks = []
                    + prefix_list_ids  = []
                    + protocol         = "tcp"
                    + security_groups  = []
                    + self             = false
                    + to_port          = 80
                    },
                ]
            + name                   = "vpc-web-default"
            + name_prefix            = (known after apply)
            + owner_id               = (known after apply)
            + revoke_rules_on_delete = false
            + tags_all               = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            + vpc_id                 = (known after apply)
            }

        # aws_subnet.private_subnet["private_subnet_1"] will be created
        + resource "aws_subnet" "private_subnet" {
            + arn                                            = (known after apply)
            + assign_ipv6_address_on_creation                = false
            + availability_zone                              = "us-east-1b"
            + availability_zone_id                           = (known after apply)
            + cidr_block                                     = "10.0.1.0/24"
            + enable_dns64                                   = false
            + enable_resource_name_dns_a_record_on_launch    = false
            + enable_resource_name_dns_aaaa_record_on_launch = false
            + id                                             = (known after apply)
            + ipv6_cidr_block_association_id                 = (known after apply)
            + ipv6_native                                    = false
            + map_public_ip_on_launch                        = false
            + owner_id                                       = (known after apply)
            + private_dns_hostname_type_on_launch            = (known after apply)
            + tags                                           = {
                + "Terraform" = "true"
                }
            + tags_all                                       = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                + "Terraform"   = "true"
                }
            + vpc_id                                         = (known after apply)
            }

        # aws_subnet.private_subnet["private_subnet_2"] will be created
        + resource "aws_subnet" "private_subnet" {
            + arn                                            = (known after apply)
            + assign_ipv6_address_on_creation                = false
            + availability_zone                              = "us-east-1c"
            + availability_zone_id                           = (known after apply)
            + cidr_block                                     = "10.0.2.0/24"
            + enable_dns64                                   = false
            + enable_resource_name_dns_a_record_on_launch    = false
            + enable_resource_name_dns_aaaa_record_on_launch = false
            + id                                             = (known after apply)
            + ipv6_cidr_block_association_id                 = (known after apply)
            + ipv6_native                                    = false
            + map_public_ip_on_launch                        = false
            + owner_id                                       = (known after apply)
            + private_dns_hostname_type_on_launch            = (known after apply)
            + tags                                           = {
                + "Terraform" = "true"
                }
            + tags_all                                       = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                + "Terraform"   = "true"
                }
            + vpc_id                                         = (known after apply)
            }

        # aws_subnet.private_subnet["private_subnet_3"] will be created
        + resource "aws_subnet" "private_subnet" {
            + arn                                            = (known after apply)
            + assign_ipv6_address_on_creation                = false
            + availability_zone                              = "us-east-1d"
            + availability_zone_id                           = (known after apply)
            + cidr_block                                     = "10.0.3.0/24"
            + enable_dns64                                   = false
            + enable_resource_name_dns_a_record_on_launch    = false
            + enable_resource_name_dns_aaaa_record_on_launch = false
            + id                                             = (known after apply)
            + ipv6_cidr_block_association_id                 = (known after apply)
            + ipv6_native                                    = false
            + map_public_ip_on_launch                        = false
            + owner_id                                       = (known after apply)
            + private_dns_hostname_type_on_launch            = (known after apply)
            + tags                                           = {
                + "Terraform" = "true"
                }
            + tags_all                                       = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                + "Terraform"   = "true"
                }
            + vpc_id                                         = (known after apply)
            }

        # aws_subnet.public_subnet["public_subnet_1"] will be created
        + resource "aws_subnet" "public_subnet" {
            + arn                                            = (known after apply)
            + assign_ipv6_address_on_creation                = false
            + availability_zone                              = "us-east-1b"
            + availability_zone_id                           = (known after apply)
            + cidr_block                                     = "10.0.101.0/24"
            + enable_dns64                                   = false
            + enable_resource_name_dns_a_record_on_launch    = false
            + enable_resource_name_dns_aaaa_record_on_launch = false
            + id                                             = (known after apply)
            + ipv6_cidr_block_association_id                 = (known after apply)
            + ipv6_native                                    = false
            + map_public_ip_on_launch                        = true
            + owner_id                                       = (known after apply)
            + private_dns_hostname_type_on_launch            = (known after apply)
            + tags                                           = {
                + "Terraform" = "true"
                }
            + tags_all                                       = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                + "Terraform"   = "true"
                }
            + vpc_id                                         = (known after apply)
            }

        # aws_subnet.public_subnet["public_subnet_2"] will be created
        + resource "aws_subnet" "public_subnet" {
            + arn                                            = (known after apply)
            + assign_ipv6_address_on_creation                = false
            + availability_zone                              = "us-east-1c"
            + availability_zone_id                           = (known after apply)
            + cidr_block                                     = "10.0.102.0/24"
            + enable_dns64                                   = false
            + enable_resource_name_dns_a_record_on_launch    = false
            + enable_resource_name_dns_aaaa_record_on_launch = false
            + id                                             = (known after apply)
            + ipv6_cidr_block_association_id                 = (known after apply)
            + ipv6_native                                    = false
            + map_public_ip_on_launch                        = true
            + owner_id                                       = (known after apply)
            + private_dns_hostname_type_on_launch            = (known after apply)
            + tags                                           = {
                + "Terraform" = "true"
                }
            + tags_all                                       = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                + "Terraform"   = "true"
                }
            + vpc_id                                         = (known after apply)
            }

        # aws_subnet.public_subnet["public_subnet_3"] will be created
        + resource "aws_subnet" "public_subnet" {
            + arn                                            = (known after apply)
            + assign_ipv6_address_on_creation                = false
            + availability_zone                              = "us-east-1d"
            + availability_zone_id                           = (known after apply)
            + cidr_block                                     = "10.0.103.0/24"
            + enable_dns64                                   = false
            + enable_resource_name_dns_a_record_on_launch    = false
            + enable_resource_name_dns_aaaa_record_on_launch = false
            + id                                             = (known after apply)
            + ipv6_cidr_block_association_id                 = (known after apply)
            + ipv6_native                                    = false
            + map_public_ip_on_launch                        = true
            + owner_id                                       = (known after apply)
            + private_dns_hostname_type_on_launch            = (known after apply)
            + tags                                           = {
                + "Terraform" = "true"
                }
            + tags_all                                       = {
                + "Environment" = "default"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                + "Terraform"   = "true"
                }
            + vpc_id                                         = (known after apply)
            }

        # aws_vpc.vpc will be created
        + resource "aws_vpc" "vpc" {
            + arn                                  = (known after apply)
            + cidr_block                           = "10.0.0.0/16"
            + default_network_acl_id               = (known after apply)
            + default_route_table_id               = (known after apply)
            + default_security_group_id            = (known after apply)
            + dhcp_options_id                      = (known after apply)
            + enable_dns_hostnames                 = (known after apply)
            + enable_dns_support                   = true
            + enable_network_address_usage_metrics = (known after apply)
            + id                                   = (known after apply)
            + instance_tenancy                     = "default"
            + ipv6_association_id                  = (known after apply)
            + ipv6_cidr_block                      = (known after apply)
            + ipv6_cidr_block_network_border_group = (known after apply)
            + main_route_table_id                  = (known after apply)
            + owner_id                             = (known after apply)
            + tags                                 = {
                + "NAME" = "AWS VPC"
                }
            + tags_all                             = {
                + "Environment" = "default"
                + "NAME"        = "AWS VPC"
                + "OWNER"       = "Acme"
                + "PROVIDER"    = "Terraform"
                }
            }

        # local_file.private_key_pem will be created
        + resource "local_file" "private_key_pem" {
            + content              = (sensitive value)
            + content_base64sha256 = (known after apply)
            + content_base64sha512 = (known after apply)
            + content_md5          = (known after apply)
            + content_sha1         = (known after apply)
            + content_sha256       = (known after apply)
            + content_sha512       = (known after apply)
            + directory_permission = "0777"
            + file_permission      = "0777"
            + filename             = "MyAWSKey.pem"
            + id                   = (known after apply)
            }

        # tls_private_key.generated will be created
        + resource "tls_private_key" "generated" {
            + algorithm                     = "RSA"
            + ecdsa_curve                   = "P224"
            + id                            = (known after apply)
            + private_key_openssh           = (sensitive value)
            + private_key_pem               = (sensitive value)
            + private_key_pem_pkcs8         = (sensitive value)
            + public_key_fingerprint_md5    = (known after apply)
            + public_key_fingerprint_sha256 = (known after apply)
            + public_key_openssh            = (known after apply)
            + public_key_pem                = (known after apply)
            + rsa_bits                      = 4096
            }

        Plan: 25 to add, 0 to change, 0 to destroy.
        tls_private_key.generated: Creating...
        tls_private_key.generated: Creation complete after 1s [id=919fc8c84a02ed7136a01eb6446b93ac4050d458]
        local_file.private_key_pem: Creating...
        local_file.private_key_pem: Creation complete after 0s [id=cf894daabc7db1c649442e2cf9cbfe7e162a673f]
        aws_key_pair.generated: Creating...
        aws_vpc.vpc: Creating...
        aws_key_pair.generated: Creation complete after 3s [id=myAWSKey]
        aws_vpc.vpc: Creation complete after 7s [id=vpc-03ff0df506109a747]
        aws_subnet.public_subnet["public_subnet_1"]: Creating...
        aws_subnet.public_subnet["public_subnet_2"]: Creating...
        aws_internet_gateway.demote_igw: Creating...
        aws_subnet.private_subnet["private_subnet_1"]: Creating...
        aws_subnet.private_subnet["private_subnet_2"]: Creating...
        aws_subnet.private_subnet["private_subnet_3"]: Creating...
        aws_subnet.public_subnet["public_subnet_3"]: Creating...
        aws_security_group.vpc-ping: Creating...
        aws_security_group.ingress-ssh: Creating...
        aws_security_group.vpc-web: Creating...
        aws_subnet.private_subnet["private_subnet_1"]: Creation complete after 4s [id=subnet-024075b7a96358806]
        aws_subnet.private_subnet["private_subnet_2"]: Creation complete after 4s [id=subnet-0ad8d6f3ee20c1277]
        aws_internet_gateway.demote_igw: Creation complete after 5s [id=igw-0eef0362d55ffb0d7]
        aws_subnet.private_subnet["private_subnet_3"]: Creation complete after 5s [id=subnet-0bcb8acad59190691]
        aws_eip.nat_gateway_eip: Creating...
        aws_route_table.public_route_table: Creating...
        aws_eip.nat_gateway_eip: Creation complete after 2s [id=eipalloc-07c5e8ccb92c5e13b]
        aws_route_table.public_route_table: Creation complete after 3s [id=rtb-0a9001a93bb6b46a8]
        aws_security_group.vpc-web: Creation complete after 10s [id=sg-07e36ef008c2b7afc]
        aws_security_group.ingress-ssh: Creation complete after 10s [id=sg-038b02f8b59a556f1]
        aws_subnet.public_subnet["public_subnet_2"]: Still creating... [10s elapsed]
        aws_subnet.public_subnet["public_subnet_1"]: Still creating... [10s elapsed]
        aws_subnet.public_subnet["public_subnet_3"]: Still creating... [10s elapsed]
        aws_security_group.vpc-ping: Still creating... [10s elapsed]
        aws_security_group.vpc-ping: Creation complete after 11s [id=sg-02567751e8c0b439f]
        aws_subnet.public_subnet["public_subnet_1"]: Creation complete after 14s [id=subnet-0c25e60f21eb4bb5e]
        aws_subnet.public_subnet["public_subnet_3"]: Creation complete after 14s [id=subnet-0ad1c2264a8ccfb4b]
        aws_instance.web_server: Creating...
        aws_subnet.public_subnet["public_subnet_2"]: Creation complete after 15s [id=subnet-06c313f4ce3baa4a7]
        aws_route_table_association.public_route_association["public_subnet_3"]: Creating...
        aws_route_table_association.public_route_association["public_subnet_2"]: Creating...
        aws_route_table_association.public_route_association["public_subnet_1"]: Creating...
        aws_nat_gateway.nat_gateway: Creating...
        aws_route_table_association.public_route_association["public_subnet_2"]: Creation complete after 1s [id=rtbassoc-010eb982ef4bf3f0d]
        aws_route_table_association.public_route_association["public_subnet_3"]: Creation complete after 1s [id=rtbassoc-0fd80a09b1b9b69ef]
        aws_route_table_association.public_route_association["public_subnet_1"]: Creation complete after 1s [id=rtbassoc-0e5429c01d87cd891]
        aws_instance.web_server: Still creating... [10s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [10s elapsed]
        aws_instance.web_server: Still creating... [20s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [20s elapsed]
        aws_instance.web_server: Provisioning with 'local-exec'...
        aws_instance.web_server (local-exec): Executing: ["/bin/sh" "-c" "chmod 600 MyAWSKey.pem"]
        aws_instance.web_server: Provisioning with 'remote-exec'...
        aws_instance.web_server (remote-exec): Connecting to remote host via SSH...
        aws_instance.web_server (remote-exec):   Host: 44.201.40.213
        aws_instance.web_server (remote-exec):   User: ubuntu
        aws_instance.web_server (remote-exec):   Password: false
        aws_instance.web_server (remote-exec):   Private key: true
        aws_instance.web_server (remote-exec):   Certificate: false
        aws_instance.web_server (remote-exec):   SSH Agent: true
        aws_instance.web_server (remote-exec):   Checking Host Key: false
        aws_instance.web_server (remote-exec):   Target Platform: unix
        aws_instance.web_server: Still creating... [30s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [30s elapsed]
        aws_instance.web_server (remote-exec): Connecting to remote host via SSH...
        aws_instance.web_server (remote-exec):   Host: 44.201.40.213
        aws_instance.web_server (remote-exec):   User: ubuntu
        aws_instance.web_server (remote-exec):   Password: false
        aws_instance.web_server (remote-exec):   Private key: true
        aws_instance.web_server (remote-exec):   Certificate: false
        aws_instance.web_server (remote-exec):   SSH Agent: true
        aws_instance.web_server (remote-exec):   Checking Host Key: false
        aws_instance.web_server (remote-exec):   Target Platform: unix
        aws_instance.web_server: Still creating... [40s elapsed]
        aws_instance.web_server (remote-exec): Connecting to remote host via SSH...
        aws_instance.web_server (remote-exec):   Host: 44.201.40.213
        aws_instance.web_server (remote-exec):   User: ubuntu
        aws_instance.web_server (remote-exec):   Password: false
        aws_instance.web_server (remote-exec):   Private key: true
        aws_instance.web_server (remote-exec):   Certificate: false
        aws_instance.web_server (remote-exec):   SSH Agent: true
        aws_instance.web_server (remote-exec):   Checking Host Key: false
        aws_instance.web_server (remote-exec):   Target Platform: unix
        aws_nat_gateway.nat_gateway: Still creating... [40s elapsed]
        aws_instance.web_server (remote-exec): Connected!
        aws_instance.web_server: Still creating... [50s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [50s elapsed]
        aws_instance.web_server (remote-exec): Cloning into 'demo-terraform-101'...
        aws_instance.web_server (remote-exec): remote: Enumerating objects: 449, done.
        aws_instance.web_server (remote-exec): remote: Counting objects:   3% (1/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:   6% (2/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:   9% (3/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  12% (4/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  15% (5/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  18% (6/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  21% (7/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  25% (8/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  28% (9/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  31% (10/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  34% (11/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  37% (12/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  40% (13/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  43% (14/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  46% (15/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  50% (16/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  53% (17/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  56% (18/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  59% (19/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  62% (20/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  65% (21/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  68% (22/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  71% (23/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  75% (24/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  78% (25/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  81% (26/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  84% (27/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  87% (28/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  90% (29/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  93% (30/32)
        aws_instance.web_server (remote-exec): remote: Counting objects:  96% (31/32)
        aws_instance.web_server (remote-exec): remote: Counting objects: 100% (32/32)
        aws_instance.web_server (remote-exec): remote: Counting objects: 100% (32/32), done.
        aws_instance.web_server (remote-exec): remote: Compressing objects:   3% (1/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:   6% (2/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:   9% (3/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  12% (4/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  16% (5/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  19% (6/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  22% (7/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  25% (8/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  29% (9/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  32% (10/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  35% (11/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  38% (12/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  41% (13/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  45% (14/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  48% (15/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  51% (16/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  54% (17/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  58% (18/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  61% (19/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  64% (20/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  67% (21/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  70% (22/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  74% (23/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  77% (24/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  80% (25/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  83% (26/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  87% (27/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  90% (28/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  93% (29/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects:  96% (30/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects: 100% (31/31)
        aws_instance.web_server (remote-exec): remote: Compressing objects: 100% (31/31), done.
        aws_instance.web_server (remote-exec): Receiving objects:   0% (1/449)
        aws_instance.web_server (remote-exec): Receiving objects:   1% (5/449)
        aws_instance.web_server (remote-exec): Receiving objects:   2% (9/449)
        aws_instance.web_server (remote-exec): Receiving objects:   3% (14/449)
        aws_instance.web_server (remote-exec): Receiving objects:   4% (18/449)
        aws_instance.web_server (remote-exec): Receiving objects:   5% (23/449)
        aws_instance.web_server (remote-exec): Receiving objects:   6% (27/449)
        aws_instance.web_server (remote-exec): Receiving objects:   7% (32/449)
        aws_instance.web_server (remote-exec): Receiving objects:   8% (36/449)
        aws_instance.web_server (remote-exec): Receiving objects:   9% (41/449)
        aws_instance.web_server (remote-exec): Receiving objects:  10% (45/449)
        aws_instance.web_server (remote-exec): Receiving objects:  11% (50/449)
        aws_instance.web_server (remote-exec): Receiving objects:  12% (54/449)
        aws_instance.web_server (remote-exec): Receiving objects:  13% (59/449)
        aws_instance.web_server (remote-exec): Receiving objects:  14% (63/449)
        aws_instance.web_server (remote-exec): Receiving objects:  15% (68/449)
        aws_instance.web_server (remote-exec): Receiving objects:  16% (72/449)
        aws_instance.web_server (remote-exec): Receiving objects:  17% (77/449)
        aws_instance.web_server (remote-exec): Receiving objects:  18% (81/449)
        aws_instance.web_server (remote-exec): Receiving objects:  19% (86/449)
        aws_instance.web_server (remote-exec): Receiving objects:  20% (90/449)
        aws_instance.web_server (remote-exec): Receiving objects:  21% (95/449)
        aws_instance.web_server (remote-exec): Receiving objects:  22% (99/449)
        aws_instance.web_server (remote-exec): Receiving objects:  23% (104/449)
        aws_instance.web_server (remote-exec): Receiving objects:  24% (108/449)
        aws_instance.web_server (remote-exec): Receiving objects:  25% (113/449)
        aws_instance.web_server (remote-exec): Receiving objects:  26% (117/449)
        aws_instance.web_server (remote-exec): Receiving objects:  27% (122/449)
        aws_instance.web_server (remote-exec): Receiving objects:  28% (126/449)
        aws_instance.web_server (remote-exec): Receiving objects:  29% (131/449)
        aws_instance.web_server (remote-exec): Receiving objects:  30% (135/449)
        aws_instance.web_server (remote-exec): Receiving objects:  31% (140/449)
        aws_instance.web_server (remote-exec): Receiving objects:  32% (144/449)
        aws_instance.web_server (remote-exec): Receiving objects:  33% (149/449)
        aws_instance.web_server (remote-exec): Receiving objects:  34% (153/449)
        aws_instance.web_server (remote-exec): Receiving objects:  35% (158/449)
        aws_instance.web_server (remote-exec): Receiving objects:  36% (162/449)
        aws_instance.web_server (remote-exec): Receiving objects:  37% (167/449)
        aws_instance.web_server (remote-exec): Receiving objects:  38% (171/449)
        aws_instance.web_server (remote-exec): Receiving objects:  39% (176/449)
        aws_instance.web_server (remote-exec): Receiving objects:  40% (180/449)
        aws_instance.web_server (remote-exec): Receiving objects:  41% (185/449)
        aws_instance.web_server (remote-exec): Receiving objects:  42% (189/449)
        aws_instance.web_server (remote-exec): Receiving objects:  43% (194/449)
        aws_instance.web_server (remote-exec): Receiving objects:  44% (198/449)
        aws_instance.web_server (remote-exec): Receiving objects:  45% (203/449)
        aws_instance.web_server (remote-exec): Receiving objects:  46% (207/449)
        aws_instance.web_server (remote-exec): Receiving objects:  47% (212/449)
        aws_instance.web_server (remote-exec): Receiving objects:  48% (216/449)
        aws_instance.web_server (remote-exec): Receiving objects:  49% (221/449)
        aws_instance.web_server (remote-exec): Receiving objects:  50% (225/449)
        aws_instance.web_server (remote-exec): Receiving objects:  51% (229/449)
        aws_instance.web_server (remote-exec): Receiving objects:  52% (234/449)
        aws_instance.web_server (remote-exec): Receiving objects:  53% (238/449)
        aws_instance.web_server (remote-exec): Receiving objects:  54% (243/449)
        aws_instance.web_server (remote-exec): Receiving objects:  55% (247/449)
        aws_instance.web_server (remote-exec): Receiving objects:  56% (252/449)
        aws_instance.web_server (remote-exec): Receiving objects:  57% (256/449)
        aws_instance.web_server (remote-exec): Receiving objects:  58% (261/449)
        aws_instance.web_server (remote-exec): Receiving objects:  59% (265/449)
        aws_instance.web_server (remote-exec): Receiving objects:  60% (270/449)
        aws_instance.web_server (remote-exec): Receiving objects:  61% (274/449)
        aws_instance.web_server (remote-exec): Receiving objects:  62% (279/449)
        aws_instance.web_server (remote-exec): Receiving objects:  63% (283/449)
        aws_instance.web_server (remote-exec): Receiving objects:  64% (288/449)
        aws_instance.web_server (remote-exec): Receiving objects:  65% (292/449)
        aws_instance.web_server (remote-exec): Receiving objects:  66% (297/449)
        aws_instance.web_server (remote-exec): Receiving objects:  67% (301/449)
        aws_instance.web_server (remote-exec): Receiving objects:  68% (306/449)
        aws_instance.web_server (remote-exec): Receiving objects:  69% (310/449)
        aws_instance.web_server (remote-exec): Receiving objects:  70% (315/449)
        aws_instance.web_server (remote-exec): Receiving objects:  71% (319/449)
        aws_instance.web_server (remote-exec): Receiving objects:  72% (324/449)
        aws_instance.web_server (remote-exec): Receiving objects:  73% (328/449)
        aws_instance.web_server (remote-exec): Receiving objects:  74% (333/449)
        aws_instance.web_server (remote-exec): Receiving objects:  75% (337/449)
        aws_instance.web_server (remote-exec): Receiving objects:  76% (342/449)
        aws_instance.web_server (remote-exec): Receiving objects:  77% (346/449)
        aws_instance.web_server (remote-exec): Receiving objects:  78% (351/449)
        aws_instance.web_server (remote-exec): Receiving objects:  79% (355/449)
        aws_instance.web_server (remote-exec): Receiving objects:  80% (360/449)
        aws_instance.web_server (remote-exec): Receiving objects:  81% (364/449)
        aws_instance.web_server (remote-exec): Receiving objects:  82% (369/449)
        aws_instance.web_server (remote-exec): Receiving objects:  83% (373/449)
        aws_instance.web_server (remote-exec): Receiving objects:  84% (378/449)
        aws_instance.web_server (remote-exec): Receiving objects:  85% (382/449)
        aws_instance.web_server (remote-exec): Receiving objects:  86% (387/449)
        aws_instance.web_server (remote-exec): Receiving objects:  87% (391/449)
        aws_instance.web_server (remote-exec): Receiving objects:  88% (396/449)
        aws_instance.web_server (remote-exec): Receiving objects:  89% (400/449)
        aws_instance.web_server (remote-exec): Receiving objects:  90% (405/449)
        aws_instance.web_server (remote-exec): Receiving objects:  91% (409/449)
        aws_instance.web_server (remote-exec): Receiving objects:  92% (414/449)
        aws_instance.web_server (remote-exec): Receiving objects:  93% (418/449)
        aws_instance.web_server (remote-exec): Receiving objects:  94% (423/449)
        aws_instance.web_server (remote-exec): Receiving objects:  95% (427/449)
        aws_instance.web_server (remote-exec): Receiving objects:  96% (432/449)
        aws_instance.web_server (remote-exec): Receiving objects:  97% (436/449)
        aws_instance.web_server (remote-exec): Receiving objects:  98% (441/449)
        aws_instance.web_server (remote-exec): remote: Total 449 (delta 0), reused 16 (delta 0), pack-reused 417
        aws_instance.web_server (remote-exec): Receiving objects:  99% (445/449)
        aws_instance.web_server (remote-exec): Receiving objects: 100% (449/449)
        aws_instance.web_server (remote-exec): Receiving objects: 100% (449/449), 4.33 MiB | 20.81 MiB/s, done.
        aws_instance.web_server (remote-exec): Resolving deltas:   0% (0/142)
        aws_instance.web_server (remote-exec): Resolving deltas:   2% (4/142)
        aws_instance.web_server (remote-exec): Resolving deltas:   3% (5/142)
        aws_instance.web_server (remote-exec): Resolving deltas:   4% (6/142)
        aws_instance.web_server (remote-exec): Resolving deltas:   5% (8/142)
        aws_instance.web_server (remote-exec): Resolving deltas:   6% (9/142)
        aws_instance.web_server (remote-exec): Resolving deltas:   7% (11/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  12% (18/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  13% (19/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  14% (20/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  15% (22/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  16% (23/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  17% (25/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  21% (31/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  25% (36/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  26% (37/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  30% (43/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  31% (45/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  34% (49/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  35% (50/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  39% (56/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  41% (59/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  42% (60/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  44% (63/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  48% (69/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  49% (70/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  63% (90/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  64% (91/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  66% (95/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  68% (97/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  69% (98/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  76% (108/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  80% (115/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  81% (116/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  82% (117/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  84% (120/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  88% (125/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  94% (134/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  95% (135/142)
        aws_instance.web_server (remote-exec): Resolving deltas:  97% (139/142)
        aws_instance.web_server (remote-exec): Resolving deltas: 100% (142/142)
        aws_instance.web_server (remote-exec): Resolving deltas: 100% (142/142), done.
        aws_instance.web_server (remote-exec): cp: preserving times for '/tmp/.': Operation not permitted
        aws_instance.web_server (remote-exec): Created symlink /etc/systemd/system/multi-user.target.wants/webapp.service → /lib/systemd/system/webapp.service.
        aws_instance.web_server: Creation complete after 1m0s [id=i-081a3ca06903970e4]
        aws_nat_gateway.nat_gateway: Still creating... [1m0s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [1m10s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [1m20s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [1m30s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [1m40s elapsed]
        aws_nat_gateway.nat_gateway: Still creating... [1m50s elapsed]
        aws_nat_gateway.nat_gateway: Creation complete after 1m51s [id=nat-0f1e2a99156e359a3]
        aws_route_table.private_route_table: Creating...
        aws_route_table.private_route_table: Creation complete after 7s [id=rtb-01f18c3ab906602db]
        aws_route_table_association.private_route_association["private_subnet_3"]: Creating...
        aws_route_table_association.private_route_association["private_subnet_1"]: Creating...
        aws_route_table_association.private_route_association["private_subnet_2"]: Creating...
        aws_route_table_association.private_route_association["private_subnet_2"]: Creation complete after 1s [id=rtbassoc-0f84b5addc4e64550]
        aws_route_table_association.private_route_association["private_subnet_1"]: Creation complete after 1s [id=rtbassoc-0fb12a5215f6cdb55]
        aws_route_table_association.private_route_association["private_subnet_3"]: Creation complete after 2s [id=rtbassoc-0f003d9e7f36266c5]

        Apply complete! Resources: 25 added, 0 changed, 0 destroyed.




    ```

- here is one of the `Terraform CLI command` to work with the `terraform state file`

- the `terraform show` command render the `terraform statefile` in the `easier to read` format  

  - it will display the `aws_key_pair` we are using in this case 
  -  it will tell me also `what region we are working on` 
  -  it will also show the `AZ`that we are working with 

- it can show the below info as 

    ```bash
        terraform show 
        # render the terrafvorm statefile in easy to read format in this case 
        # below will be the output for the same
        # data.aws_ami.ubuntu:
        data "aws_ami" "ubuntu" {
            architecture          = "x86_64"
            arn                   = "arn:aws:ec2:us-east-1::image/ami-00d321eaa8a8a4640"
            block_device_mappings = [
                {
                    device_name  = "/dev/sda1"
                    ebs          = {
                        "delete_on_termination" = "true"
                        "encrypted"             = "false"
                        "iops"                  = "0"
                        "snapshot_id"           = "snap-0d1e67cdaac539762"
                        "throughput"            = "0"
                        "volume_size"           = "8"
                        "volume_type"           = "gp2"
                    }
                    no_device    = ""
                    virtual_name = ""
                },
                {
                    device_name  = "/dev/sdb"
                    ebs          = {}
                    no_device    = ""
                    virtual_name = "ephemeral0"
                },
                {
                    device_name  = "/dev/sdc"
                    ebs          = {}
                    no_device    = ""
                    virtual_name = "ephemeral1"
                },
            ]
            boot_mode             = "legacy-bios"
            creation_date         = "2023-11-17T23:41:30.000Z"
            deprecation_time      = "2025-11-17T23:41:30.000Z"
            description           = "Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2023-11-17"
            ena_support           = true
            hypervisor            = "xen"
            id                    = "ami-00d321eaa8a8a4640"
            image_id              = "ami-00d321eaa8a8a4640"
            image_location        = "amazon/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20231117"
            image_owner_alias     = "amazon"
            image_type            = "machine"
            include_deprecated    = false
            most_recent           = true
            name                  = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20231117"
            owner_id              = "099720109477"
            owners                = [
                "099720109477",
            ]
            platform_details      = "Linux/UNIX"
            product_codes         = []
            public                = true
            root_device_name      = "/dev/sda1"
            root_device_type      = "ebs"
            root_snapshot_id      = "snap-0d1e67cdaac539762"
            sriov_net_support     = "simple"
            state                 = "available"
            state_reason          = {
                "code"    = "UNSET"
                "message" = "UNSET"
            }
            tags                  = {}
            usage_operation       = "RunInstances"
            virtualization_type   = "hvm"

            filter {
                name   = "name"
                values = [
                    "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*",
                ]
            }
            filter {
                name   = "virtualization-type"
                values = [
                    "hvm",
                ]
            }
        }

        # data.aws_availability_zones.available:
        data "aws_availability_zones" "available" {
            group_names = [
                "us-east-1",
            ]
            id          = "us-east-1"
            names       = [
                "us-east-1a",
                "us-east-1b",
                "us-east-1c",
                "us-east-1d",
                "us-east-1e",
                "us-east-1f",
            ]
            zone_ids    = [
                "use1-az6",
                "use1-az1",
                "use1-az2",
                "use1-az4",
                "use1-az3",
                "use1-az5",
            ]
        }

        # aws_eip.nat_gateway_eip:
        resource "aws_eip" "nat_gateway_eip" {
            allocation_id        = "eipalloc-07c5e8ccb92c5e13b"
            domain               = "vpc"
            id                   = "eipalloc-07c5e8ccb92c5e13b"
            network_border_group = "us-east-1"
            public_dns           = "ec2-3-233-123-14.compute-1.amazonaws.com"
            public_ip            = "3.233.123.14"
            public_ipv4_pool     = "amazon"
            tags                 = {
                "Name" = "demo_igw_eip"
            }
            tags_all             = {
                "Environment" = "default"
                "Name"        = "demo_igw_eip"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            vpc                  = true
        }

        # aws_instance.web_server:
        resource "aws_instance" "web_server" {
            ami                                  = "ami-00d321eaa8a8a4640"
            arn                                  = "arn:aws:ec2:us-east-1:115170445162:instance/i-081a3ca06903970e4"
            associate_public_ip_address          = true
            availability_zone                    = "us-east-1b"
            cpu_core_count                       = 1
            cpu_threads_per_core                 = 1
            disable_api_stop                     = false
            disable_api_termination              = false
            ebs_optimized                        = false
            get_password_data                    = false
            hibernation                          = false
            id                                   = "i-081a3ca06903970e4"
            instance_initiated_shutdown_behavior = "stop"
            instance_state                       = "running"
            instance_type                        = "t2.micro"
            ipv6_address_count                   = 0
            ipv6_addresses                       = []
            key_name                             = "myAWSKey"
            monitoring                           = false
            placement_partition_number           = 0
            primary_network_interface_id         = "eni-0acd065f3ca000eb1"
            private_dns                          = "ip-10-0-101-167.ec2.internal"
            private_ip                           = "10.0.101.167"
            public_ip                            = "44.201.40.213"
            secondary_private_ips                = []
            security_groups                      = [
                "sg-02567751e8c0b439f",
                "sg-038b02f8b59a556f1",
                "sg-07e36ef008c2b7afc",
            ]
            source_dest_check                    = true
            subnet_id                            = "subnet-0c25e60f21eb4bb5e"
            tags                                 = {
                "Name" = "Web EC2 Server"
            }
            tags_all                             = {
                "Environment" = "default"
                "Name"        = "Web EC2 Server"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            tenancy                              = "default"
            user_data_replace_on_change          = false
            vpc_security_group_ids               = [
                "sg-02567751e8c0b439f",
                "sg-038b02f8b59a556f1",
                "sg-07e36ef008c2b7afc",
            ]

            capacity_reservation_specification {
                capacity_reservation_preference = "open"
            }

            cpu_options {
                core_count       = 1
                threads_per_core = 1
            }

            credit_specification {
                cpu_credits = "standard"
            }

            enclave_options {
                enabled = false
            }

            maintenance_options {
                auto_recovery = "default"
            }

            metadata_options {
                http_endpoint               = "enabled"
                http_protocol_ipv6          = "disabled"
                http_put_response_hop_limit = 1
                http_tokens                 = "optional"
                instance_metadata_tags      = "disabled"
            }

            private_dns_name_options {
                enable_resource_name_dns_a_record    = false
                enable_resource_name_dns_aaaa_record = false
                hostname_type                        = "ip-name"
            }

            root_block_device {
                delete_on_termination = true
                device_name           = "/dev/sda1"
                encrypted             = false
                iops                  = 100
                tags                  = {}
                throughput            = 0
                volume_id             = "vol-0555a68858eb9c431"
                volume_size           = 8
                volume_type           = "gp2"
            }
        }

        # aws_internet_gateway.demote_igw:
        resource "aws_internet_gateway" "demote_igw" {
            arn      = "arn:aws:ec2:us-east-1:115170445162:internet-gateway/igw-0eef0362d55ffb0d7"
            id       = "igw-0eef0362d55ffb0d7"
            owner_id = "115170445162"
            tags     = {
                "Name" = "demo_igw"
            }
            tags_all = {
                "Environment" = "default"
                "Name"        = "demo_igw"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            vpc_id   = "vpc-03ff0df506109a747"
        }

        # aws_key_pair.generated:
        resource "aws_key_pair" "generated" {
            arn         = "arn:aws:ec2:us-east-1:115170445162:key-pair/myAWSKey"
            fingerprint = "c6:9a:cb:3f:63:0e:27:2b:ab:a3:c2:f1:ea:89:38:e9"
            id          = "myAWSKey"
            key_name    = "myAWSKey"
            key_pair_id = "key-0a7325041beacab04"
            key_type    = "rsa"
            public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6uFV+Z1RONqvkF4lD0IpOR0X6UwRoZbsC7/88FbbIo5Fe73v2DApa27elw+4VOaF1vxSGLP5cBQRsV8ZC39hPNyxior5oBFk5FsflhwMivqUILK4ITpjvAn66TM0/wuMf5gjBmJ60ooRaCgb8K1GNcyW0BY9snuhRwbEA6ZqWPWQwF39naS5+1FsemwEh4ZEsQD5+ahKI0OuOsUUhB5IU4CQ5v7zfc9JDcGC96jYcI3VeSnD3M9FkxBMCc6keqXdcnBAH1P9xzr2FsKfzLk70MnXB76sZkCmWlQOKA2KTvnmjUcdTIVeFOpw5yR0t7kzybUfikIYiJoS+TeS1a2yDfxZVSzEDLMqgmXXZKISHB5wIIEzY36gDJzsHI/jDCO0mhybrCpA2kbAl9ZHtbTK3K366VRFFmcPvSJTmuLewk7/P5yiXj3YnoCc3ffC70z/KivuSt1kvbZBfSLeW5vrda9VCblw192GhQSZILZKWSBEyO4ZhLWdFk9F6/cBtdoMICk9OSlFpXR5ChRZUAxJsswce7AnyainrK+97gEiLQE26NW1apVDE5yfMBlhXVUXaSmwkjJrcfA3jzv+LyF34A7oXLQcmEkyPk6pgj5v0Tt7HeIcgO5sPlzHfM2xKsGepoI2eRuV1bNVNy9JwJb5Gr4lXmHytF/DJC0vPMy5R3w=="
            tags_all    = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
        }

        # aws_nat_gateway.nat_gateway:
        resource "aws_nat_gateway" "nat_gateway" {
            allocation_id                      = "eipalloc-07c5e8ccb92c5e13b"
            association_id                     = "eipassoc-027e5e6974a3490f8"
            connectivity_type                  = "public"
            id                                 = "nat-0f1e2a99156e359a3"
            network_interface_id               = "eni-02788357c8f7bcc30"
            private_ip                         = "10.0.101.98"
            public_ip                          = "3.233.123.14"
            secondary_private_ip_address_count = 0
            secondary_private_ip_addresses     = []
            subnet_id                          = "subnet-0c25e60f21eb4bb5e"
            tags                               = {
                "Name" = "demo_nat_gateway"
            }
            tags_all                           = {
                "Environment" = "default"
                "Name"        = "demo_nat_gateway"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
        }

        # aws_route_table.private_route_table:
        resource "aws_route_table" "private_route_table" {
            arn              = "arn:aws:ec2:us-east-1:115170445162:route-table/rtb-01f18c3ab906602db"
            id               = "rtb-01f18c3ab906602db"
            owner_id         = "115170445162"
            propagating_vgws = []
            route            = [
                {
                    carrier_gateway_id         = ""
                    cidr_block                 = "0.0.0.0/0"
                    core_network_arn           = ""
                    destination_prefix_list_id = ""
                    egress_only_gateway_id     = ""
                    gateway_id                 = "nat-0f1e2a99156e359a3"
                    ipv6_cidr_block            = ""
                    local_gateway_id           = ""
                    nat_gateway_id             = ""
                    network_interface_id       = ""
                    transit_gateway_id         = ""
                    vpc_endpoint_id            = ""
                    vpc_peering_connection_id  = ""
                },
            ]
            tags_all         = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            vpc_id           = "vpc-03ff0df506109a747"
        }

        # aws_route_table.public_route_table:
        resource "aws_route_table" "public_route_table" {
            arn              = "arn:aws:ec2:us-east-1:115170445162:route-table/rtb-0a9001a93bb6b46a8"
            id               = "rtb-0a9001a93bb6b46a8"
            owner_id         = "115170445162"
            propagating_vgws = []
            route            = [
                {
                    carrier_gateway_id         = ""
                    cidr_block                 = "0.0.0.0/0"
                    core_network_arn           = ""
                    destination_prefix_list_id = ""
                    egress_only_gateway_id     = ""
                    gateway_id                 = "igw-0eef0362d55ffb0d7"
                    ipv6_cidr_block            = ""
                    local_gateway_id           = ""
                    nat_gateway_id             = ""
                    network_interface_id       = ""
                    transit_gateway_id         = ""
                    vpc_endpoint_id            = ""
                    vpc_peering_connection_id  = ""
                },
            ]
            tags_all         = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            vpc_id           = "vpc-03ff0df506109a747"
        }

        # aws_route_table_association.private_route_association["private_subnet_1"]:
        resource "aws_route_table_association" "private_route_association" {
            id             = "rtbassoc-0fb12a5215f6cdb55"
            route_table_id = "rtb-01f18c3ab906602db"
            subnet_id      = "subnet-024075b7a96358806"
        }

        # aws_route_table_association.private_route_association["private_subnet_2"]:
        resource "aws_route_table_association" "private_route_association" {
            id             = "rtbassoc-0f84b5addc4e64550"
            route_table_id = "rtb-01f18c3ab906602db"
            subnet_id      = "subnet-0ad8d6f3ee20c1277"
        }

        # aws_route_table_association.private_route_association["private_subnet_3"]:
        resource "aws_route_table_association" "private_route_association" {
            id             = "rtbassoc-0f003d9e7f36266c5"
            route_table_id = "rtb-01f18c3ab906602db"
            subnet_id      = "subnet-0bcb8acad59190691"
        }

        # aws_route_table_association.public_route_association["public_subnet_1"]:
        resource "aws_route_table_association" "public_route_association" {
            id             = "rtbassoc-0e5429c01d87cd891"
            route_table_id = "rtb-0a9001a93bb6b46a8"
            subnet_id      = "subnet-0c25e60f21eb4bb5e"
        }

        # aws_route_table_association.public_route_association["public_subnet_2"]:
        resource "aws_route_table_association" "public_route_association" {
            id             = "rtbassoc-010eb982ef4bf3f0d"
            route_table_id = "rtb-0a9001a93bb6b46a8"
            subnet_id      = "subnet-06c313f4ce3baa4a7"
        }

        # aws_route_table_association.public_route_association["public_subnet_3"]:
        resource "aws_route_table_association" "public_route_association" {
            id             = "rtbassoc-0fd80a09b1b9b69ef"
            route_table_id = "rtb-0a9001a93bb6b46a8"
            subnet_id      = "subnet-0ad1c2264a8ccfb4b"
        }

        # aws_security_group.ingress-ssh:
        resource "aws_security_group" "ingress-ssh" {
            arn                    = "arn:aws:ec2:us-east-1:115170445162:security-group/sg-038b02f8b59a556f1"
            description            = "Managed by Terraform"
            egress                 = [
                {
                    cidr_blocks      = [
                        "0.0.0.0/0",
                    ]
                    description      = ""
                    from_port        = 0
                    ipv6_cidr_blocks = []
                    prefix_list_ids  = []
                    protocol         = "-1"
                    security_groups  = []
                    self             = false
                    to_port          = 0
                },
            ]
            id                     = "sg-038b02f8b59a556f1"
            ingress                = [
                {
                    cidr_blocks      = [
                        "0.0.0.0/0",
                    ]
                    description      = ""
                    from_port        = 22
                    ipv6_cidr_blocks = []
                    prefix_list_ids  = []
                    protocol         = "tcp"
                    security_groups  = []
                    self             = false
                    to_port          = 22
                },
            ]
            name                   = "allow-all-ssh"
            owner_id               = "115170445162"
            revoke_rules_on_delete = false
            tags_all               = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            vpc_id                 = "vpc-03ff0df506109a747"
        }

        # aws_security_group.vpc-ping:
        resource "aws_security_group" "vpc-ping" {
            arn                    = "arn:aws:ec2:us-east-1:115170445162:security-group/sg-02567751e8c0b439f"
            description            = "ICMP for Ping Access"
            egress                 = [
                {
                    cidr_blocks      = [
                        "0.0.0.0/0",
                    ]
                    description      = "Allow all ip and ports outboun"
                    from_port        = 0
                    ipv6_cidr_blocks = []
                    prefix_list_ids  = []
                    protocol         = "-1"
                    security_groups  = []
                    self             = false
                    to_port          = 0
                },
            ]
            id                     = "sg-02567751e8c0b439f"
            ingress                = [
                {
                    cidr_blocks      = [
                        "0.0.0.0/0",
                    ]
                    description      = "Allow ICMP Traffic"
                    from_port        = -1
                    ipv6_cidr_blocks = []
                    prefix_list_ids  = []
                    protocol         = "icmp"
                    security_groups  = []
                    self             = false
                    to_port          = -1
                },
            ]
            name                   = "vpc-ping"
            owner_id               = "115170445162"
            revoke_rules_on_delete = false
            tags_all               = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            vpc_id                 = "vpc-03ff0df506109a747"
        }

        # aws_security_group.vpc-web:
        resource "aws_security_group" "vpc-web" {
            arn                    = "arn:aws:ec2:us-east-1:115170445162:security-group/sg-07e36ef008c2b7afc"
            description            = "Web Traffic"
            egress                 = [
                {
                    cidr_blocks      = [
                        "0.0.0.0/0",
                    ]
                    description      = "Allow all ip and ports outbound"
                    from_port        = 0
                    ipv6_cidr_blocks = []
                    prefix_list_ids  = []
                    protocol         = "-1"
                    security_groups  = []
                    self             = false
                    to_port          = 0
                },
            ]
            id                     = "sg-07e36ef008c2b7afc"
            ingress                = [
                {
                    cidr_blocks      = [
                        "0.0.0.0/0",
                    ]
                    description      = "Allow Port 443"
                    from_port        = 443
                    ipv6_cidr_blocks = []
                    prefix_list_ids  = []
                    protocol         = "tcp"
                    security_groups  = []
                    self             = false
                    to_port          = 443
                },
                {
                    cidr_blocks      = [
                        "0.0.0.0/0",
                    ]
                    description      = "Allow Port 80"
                    from_port        = 80
                    ipv6_cidr_blocks = []
                    prefix_list_ids  = []
                    protocol         = "tcp"
                    security_groups  = []
                    self             = false
                    to_port          = 80
                },
            ]
            name                   = "vpc-web-default"
            owner_id               = "115170445162"
            revoke_rules_on_delete = false
            tags_all               = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            vpc_id                 = "vpc-03ff0df506109a747"
        }

        # aws_subnet.private_subnet["private_subnet_1"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-024075b7a96358806"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1b"
            availability_zone_id                           = "use1-az1"
            cidr_block                                     = "10.0.1.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-024075b7a96358806"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
                "Terraform"   = "true"
            }
            vpc_id                                         = "vpc-03ff0df506109a747"
        }

        # aws_subnet.private_subnet["private_subnet_2"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0ad8d6f3ee20c1277"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1c"
            availability_zone_id                           = "use1-az2"
            cidr_block                                     = "10.0.2.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0ad8d6f3ee20c1277"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
                "Terraform"   = "true"
            }
            vpc_id                                         = "vpc-03ff0df506109a747"
        }

        # aws_subnet.private_subnet["private_subnet_3"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0bcb8acad59190691"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1d"
            availability_zone_id                           = "use1-az4"
            cidr_block                                     = "10.0.3.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0bcb8acad59190691"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
                "Terraform"   = "true"
            }
            vpc_id                                         = "vpc-03ff0df506109a747"
        }

        # aws_subnet.public_subnet["public_subnet_1"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0c25e60f21eb4bb5e"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1b"
            availability_zone_id                           = "use1-az1"
            cidr_block                                     = "10.0.101.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0c25e60f21eb4bb5e"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
                "Terraform"   = "true"
            }
            vpc_id                                         = "vpc-03ff0df506109a747"
        }

        # aws_subnet.public_subnet["public_subnet_2"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-06c313f4ce3baa4a7"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1c"
            availability_zone_id                           = "use1-az2"
            cidr_block                                     = "10.0.102.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-06c313f4ce3baa4a7"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
                "Terraform"   = "true"
            }
            vpc_id                                         = "vpc-03ff0df506109a747"
        }

        # aws_subnet.public_subnet["public_subnet_3"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0ad1c2264a8ccfb4b"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1d"
            availability_zone_id                           = "use1-az4"
            cidr_block                                     = "10.0.103.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0ad1c2264a8ccfb4b"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "Environment" = "default"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
                "Terraform"   = "true"
            }
            vpc_id                                         = "vpc-03ff0df506109a747"
        }

        # aws_vpc.vpc:
        resource "aws_vpc" "vpc" {
            arn                                  = "arn:aws:ec2:us-east-1:115170445162:vpc/vpc-03ff0df506109a747"
            assign_generated_ipv6_cidr_block     = false
            cidr_block                           = "10.0.0.0/16"
            default_network_acl_id               = "acl-060d17f63d2e19b21"
            default_route_table_id               = "rtb-06bdb33f92496a87c"
            default_security_group_id            = "sg-048a67ad4113e34a6"
            dhcp_options_id                      = "dopt-0644d2a9e11a2ac8b"
            enable_dns_hostnames                 = false
            enable_dns_support                   = true
            enable_network_address_usage_metrics = false
            id                                   = "vpc-03ff0df506109a747"
            instance_tenancy                     = "default"
            ipv6_netmask_length                  = 0
            main_route_table_id                  = "rtb-06bdb33f92496a87c"
            owner_id                             = "115170445162"
            tags                                 = {
                "NAME" = "AWS VPC"
            }
            tags_all                             = {
                "Environment" = "default"
                "NAME"        = "AWS VPC"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
        }

        # local_file.private_key_pem:
        resource "local_file" "private_key_pem" {
            content              = (sensitive value)
            content_base64sha256 = "xCL8N+ULHqLsYH9ZE7eMEzitsf0Cuc3Rv7osxm9dZSM="
            content_base64sha512 = "eeTBlXdxW8WxNoJZ25+MONyCfVNqYpSXGSXGQal6UD1m48m3L/suLTHrU9b2UUViK5apQZfS8sVOattIrNJXTQ=="
            content_md5          = "4933d4c42735ad429e93bc1e037a4df7"
            content_sha1         = "cf894daabc7db1c649442e2cf9cbfe7e162a673f"
            content_sha256       = "c422fc37e50b1ea2ec607f5913b78c1338adb1fd02b9cdd1bfba2cc66f5d6523"
            content_sha512       = "79e4c19577715bc5b1368259db9f8c38dc827d536a6294971925c641a97a503d66e3c9b72ffb2e2d31eb53d6f65145622b96a94197d2f2c54e6adb48acd2574d"
            directory_permission = "0777"
            file_permission      = "0777"
            filename             = "MyAWSKey.pem"
            id                   = "cf894daabc7db1c649442e2cf9cbfe7e162a673f"
        }

        # tls_private_key.generated:
        resource "tls_private_key" "generated" {
            algorithm                     = "RSA"
            ecdsa_curve                   = "P224"
            id                            = "919fc8c84a02ed7136a01eb6446b93ac4050d458"
            private_key_openssh           = (sensitive value)
            private_key_pem               = (sensitive value)
            private_key_pem_pkcs8         = (sensitive value)
            public_key_fingerprint_md5    = "3f:e7:c9:a5:79:6f:13:d4:55:e2:ea:dc:37:8f:0d:a6"
            public_key_fingerprint_sha256 = "SHA256:arj6zPHUqEESVNHBagAJ28E6j4oh3i68LUxFiA7T6e0"
            public_key_openssh            = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6uFV+Z1RONqvkF4lD0IpOR0X6UwRoZbsC7/88FbbIo5Fe73v2DApa27elw+4VOaF1vxSGLP5cBQRsV8ZC39hPNyxior5oBFk5FsflhwMivqUILK4ITpjvAn66TM0/wuMf5gjBmJ60ooRaCgb8K1GNcyW0BY9snuhRwbEA6ZqWPWQwF39naS5+1FsemwEh4ZEsQD5+ahKI0OuOsUUhB5IU4CQ5v7zfc9JDcGC96jYcI3VeSnD3M9FkxBMCc6keqXdcnBAH1P9xzr2FsKfzLk70MnXB76sZkCmWlQOKA2KTvnmjUcdTIVeFOpw5yR0t7kzybUfikIYiJoS+TeS1a2yDfxZVSzEDLMqgmXXZKISHB5wIIEzY36gDJzsHI/jDCO0mhybrCpA2kbAl9ZHtbTK3K366VRFFmcPvSJTmuLewk7/P5yiXj3YnoCc3ffC70z/KivuSt1kvbZBfSLeW5vrda9VCblw192GhQSZILZKWSBEyO4ZhLWdFk9F6/cBtdoMICk9OSlFpXR5ChRZUAxJsswce7AnyainrK+97gEiLQE26NW1apVDE5yfMBlhXVUXaSmwkjJrcfA3jzv+LyF34A7oXLQcmEkyPk6pgj5v0Tt7HeIcgO5sPlzHfM2xKsGepoI2eRuV1bNVNy9JwJb5Gr4lXmHytF/DJC0vPMy5R3w==
            EOT
            public_key_pem                = <<-EOT
                -----BEGIN PUBLIC KEY-----
                MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAurhVfmdUTjar5BeJQ9CK
                TkdF+lMEaGW7Au//PBW2yKORXu979gwKWtu3pcPuFTmhdb8Uhiz+XAUEbFfGQt/Y
                TzcsYqK+aARZORbH5YcDIr6lCCyuCE6Y7wJ+ukzNP8LjH+YIwZietKKEWgoG/CtR
                jXMltAWPbJ7oUcGxAOmalj1kMBd/Z2kuftRbHpsBIeGRLEA+fmoSiNDrjrFFIQeS
                FOAkOb+833PSQ3Bgveo2HCN1Xkpw9zPRZMQTAnOpHql3XJwQB9T/cc69hbCn8y5O
                9DJ1we+rGZAplpUDigNik755o1HHUyFXhTqcOckdLe5M8m1H4pCGIiaEvk3ktWts
                g38WVUsxAyzKoJl12SiEhwecCCBM2N+oAyc7ByP4wwjtJocm6wqQNpGwJfWR7W0y
                tyt+ulURRZnD70iU5ri3sJO/z+col492J6AnN33wu9M/yor7krdZL22QX0i3lub6
                3WvVQm5cNfdhoUEmSC2SlkgRMjuGYS1nRZPRev3AbXaDCApPTkpRaV0eQoUWVAMS
                bLMHHuwJ8mop6yvve4BIi0BNujVtWqVQxOcnzAZYV1VF2kpsJIya3HwN487/i8hd
                +AO6Fy0HJhJMj5OqYI+b9E7ex3iHIDubD5cx3zNsSrBnqaCNnkbldWzVTcvScCW+
                Rq+JV5h8rRfwyQtLzzMuUd8CAwEAAQ==
                -----END PUBLIC KEY-----
            EOT
            rsa_bits                      = 4096
        }
    
    ```

- we can also interact with the `terraform statefile` using the command as `terraform state show` command 

- if we are running the `-help` with the `terraform state` command which will provide all the `subcommand` for the `terraform state`

- we can use the command as below 

    ```bash
        terraform state -help 
        # here we are using the -help command which will show all the subcommand with the terraform state
        Usage: terraform [global options] state <subcommand> [options] [args]

        This command has subcommands for advanced state management.

        These subcommands can be used to slice and dice the Terraform state.
        This is sometimes necessary in advanced cases. For your safety, all
        state management commands that modify the state create a timestamped
        backup of the state prior to making modifications.

        The structure and output of the commands is specifically tailored to work
        well with the common Unix utilities such as grep, awk, etc. We recommend
        using those tools to perform more advanced state tasks.

        Subcommands:
            list                List resources in the state
            mv                  Move an item in the state
            pull                Pull current state and output to stdout
            push                Update remote state from a local state file
            replace-provider    Replace provider in the state
            rm                  Remove instances from the state
            show                Show a resource in the state
    
    ```

- we can perform the `terraform state show` and `terraform state list` command

- we can also use the `modification command` such as `terraform state mv` for `moving the items in terraform statefile` and `terraform state rm` , removing items fron the `terraform state` 

- we can also `pull item `from the `terraform statefile` and we can also `push the item into the terraform statefile` which is also `modification command`

- we can run the `terraform state list` which will display all the `resources that being created as a part of the Terraform configuation` in a `compact view`

- if we run the `terraform state list` below will be the output  

    
    ```bash
        terraform state -list 
        # this will show all the resource created using the terraform configuration using the compact view in this case
        # below will be the putput for the same
        # using this we can also refer resources inside the terraform configuration
        # the list command will provide the resource idof the resource created using the terraform configuration
        data.aws_ami.ubuntu
        data.aws_availability_zones.available
        aws_eip.nat_gateway_eip
        aws_instance.web_server
        aws_internet_gateway.demote_igw
        aws_key_pair.generated
        aws_nat_gateway.nat_gateway
        aws_route_table.private_route_table
        aws_route_table.public_route_table
        aws_route_table_association.private_route_association["private_subnet_1"]
        aws_route_table_association.private_route_association["private_subnet_2"]
        aws_route_table_association.private_route_association["private_subnet_3"]
        aws_route_table_association.public_route_association["public_subnet_1"]
        aws_route_table_association.public_route_association["public_subnet_2"]
        aws_route_table_association.public_route_association["public_subnet_3"]
        aws_security_group.ingress-ssh
        aws_security_group.vpc-ping
        aws_security_group.vpc-web
        aws_subnet.private_subnet["private_subnet_1"]
        aws_subnet.private_subnet["private_subnet_2"]
        aws_subnet.private_subnet["private_subnet_3"]
        aws_subnet.public_subnet["public_subnet_1"]
        aws_subnet.public_subnet["public_subnet_2"]
        aws_subnet.public_subnet["public_subnet_3"]
        aws_vpc.vpc
        local_file.private_key_pem
        tls_private_key.generated
            
    ```

- if we want to look at the `details` of the `single resource` using the `resource_id` then we can use the command as `terraform state show <resource_id>`

- if we are using the `terraform state show <resource id>` for the `EC2 instance` then it will provide the below result 

    ```bash
        terraform state show <resource_id>
        # showing the terraform state command in this case out in here as for the EC2 instance
        terraform state show aws_instance.web_server
        # here providing the resource_id for the EC2 instance which is of aws_instance.web_server
        # below will be the output 
        # aws_instance.web_server:
        resource "aws_instance" "web_server" {
            ami                                  = "ami-00d321eaa8a8a4640"
            arn                                  = "arn:aws:ec2:us-east-1:115170445162:instance/i-081a3ca06903970e4"
            associate_public_ip_address          = true
            availability_zone                    = "us-east-1b" # here we can see the AZ for the EC2 instance
            cpu_core_count                       = 1
            cpu_threads_per_core                 = 1
            disable_api_stop                     = false
            disable_api_termination              = false
            ebs_optimized                        = false
            get_password_data                    = false
            hibernation                          = false
            id                                   = "i-081a3ca06903970e4"
            instance_initiated_shutdown_behavior = "stop"
            instance_state                       = "running" # state of the aws EC2 instance
            instance_type                        = "t2.micro"
            ipv6_address_count                   = 0
            ipv6_addresses                       = []
            key_name                             = "myAWSKey"  # which aws_key_pair associated with it
            monitoring                           = false
            placement_partition_number           = 0
            primary_network_interface_id         = "eni-0acd065f3ca000eb1"
            private_dns                          = "ip-10-0-101-167.ec2.internal"
            private_ip                           = "10.0.101.167"
            public_ip                            = "44.201.40.213"
            secondary_private_ips                = []
            security_groups                      = [
                "sg-02567751e8c0b439f",
                "sg-038b02f8b59a556f1",
                "sg-07e36ef008c2b7afc",
            ]
            source_dest_check                    = true
            subnet_id                            = "subnet-0c25e60f21eb4bb5e"
            tags                                 = {
                "Name" = "Web EC2 Server"
            }
            tags_all                             = {
                "Environment" = "default"
                "Name"        = "Web EC2 Server"
                "OWNER"       = "Acme"
                "PROVIDER"    = "Terraform"
            }
            tenancy                              = "default"
            user_data_replace_on_change          = false
            vpc_security_group_ids               = [
                "sg-02567751e8c0b439f",
                "sg-038b02f8b59a556f1",
                "sg-07e36ef008c2b7afc",
            ]

            capacity_reservation_specification {
                capacity_reservation_preference = "open"
            }

            cpu_options {
                core_count       = 1
                threads_per_core = 1
            }

            credit_specification {
                cpu_credits = "standard"
            }

            enclave_options {
                enabled = false
            }

            maintenance_options {
                auto_recovery = "default"
            }

            metadata_options {
                http_endpoint               = "enabled"
                http_protocol_ipv6          = "disabled"
                http_put_response_hop_limit = 1
                http_tokens                 = "optional"
                instance_metadata_tags      = "disabled"
            }

            private_dns_name_options {
                enable_resource_name_dns_a_record    = false
                enable_resource_name_dns_aaaa_record = false
                hostname_type                        = "ip-name"
            }

            root_block_device {
                delete_on_termination = true
                device_name           = "/dev/sda1"
                encrypted             = false
                iops                  = 100
                tags                  = {}
                throughput            = 0
                volume_id             = "vol-0555a68858eb9c431"
                volume_size           = 8
                volume_type           = "gp2"
            }
        }


    ```

- we must not `moduify the terraform statefile` directly , just because we can use the `modify that using the command line` but be very  `caution about the same` , should be used for the `advance cases`

- the `terraform workflow manage` how the `statefile` should be declared for the `terraform configuration`  

- while using the `terraform state command` with `modification option` such as `mv/rm/pull/push` it will backup the `terraform state file i.e *.tfstatefile` but not recomended to use the same 