# Terraform Data Block or Data Resource 

- `data block` or `data Resource` used in `terraform` for `query and retrieve data` from the `APIs` or `other terraform workspaces`

- we can have the `terraform query the data` from the `API or Terraform workspace` and then we can `grab that fetched data` and `use it in the terraform configuration` to make it `more flexible`

- using the `data block` or `data resource` we can `connect different workspaces`

- we have different `terraform workspaces` , we can `export and output` `data` from `one terraform workspace` and use `same data` as `input` for `another terraform workspace configuration file`

- we can also use `terraform` go out to `query` the `AWS` and `pull the data` from `AWS` such as 
  
  - `availabilty zone`
  
  - `region`
  
  - `other resources that we have already deployed` 

- we can pull that `data` in and `Terraform` can `store` that `data` including all of `its attribute` that we have `extracted by querying` and we can then `refer to that data` when we are doing something else 

- we can `refer the data that we have extracted` in order to 
  
  - `create a Another New resource`
  
  - `change the resource` 

- we can use the `data block` or `data-resource` to `query the data from AWS` and we can use that `data` for performing `something else`

- if we want to use the `data source` then we need to define that using the `data block` in the `terraform configuration`

- once declared the `data block` then `terraform` will `query the data` and `fetch the data` and `use it for something else` in `terraform configuration file` 

- A `data block` inside the `terraform configuration` defined with `following component`
  
  - `Data Block Resource Type` :- which is the `top level keyword` i.e `Data Resource`
  
  - `Data Type` :- the `type of resource` that we are going to `query against`
  
  - `Data Local Name` :- The next value is the name of the resource , The resource type and name
    together form the `resource identifier, or ID`, . In this lab, one of the resource IDs is `aws_instance
    .web` .The resource ID must be unique for a given configuration, even if multiple files are used

  - `Data Arguments` :- `this will be different` based the `data lookup` we will be doing , Most of the arguments within the body of a resource block are specific to the selected resource type, The resource type’s documentation lists which arguments are available and how their values should be formatted

- we can see that `data block component` in the `terraform cloud registry`


- the `data block` template can be written as below 

    ```tf
        main.tf
        =======
        data “<DATA TYPE>” “<DATA LOCAL NAME>” { # defining the data block or data resource
        # Block body
            <IDENTIFIER> = <EXPRESSION> # Argument
        }

    ```


- we can have `multiple data block` inside the `terraform configuration` , which is `pretty common`

- **Lab12**
  
  - **Task1** 
  
  - we will be adding a `new data source` to `query the current AWS region that being used`
  
  - updating the `terraform configuration file` in order to use `data source` using which we query the `current AWS region`
  
  - we will using the `data source data` in order to `add a Tag onto the aws_vpc resource`

  - we will be adding a  new `Tag` named as `region` in order to `use the data that we get from the data source`

  - **we will be adding a `new data source` to `query the current AWS region that being used` and updating the `terraform configuration file` in order to use `data source` using which we query the `current AWS region`**
    
    -  we can create the `data block` as below inside the `terraform configuration` i.e `main.tf` as below 

    ```tf
        main.tf
        =======

        data "aws_region" "current" {} 
        # defining the data block with data_type as resource type as aws_region(which can be found in the registry) here
        # defining the data local name as `current` in here which will create the resource id as `aws_region.current` in this case 

        resource "aws_vpc" "vpc" {

            cidr_id = var.vpc_cidr  # referencing the cidr_block in order to define the cidr_id for the VPC  in here 

            tags = { # defining the Tags in here as below 

                Region = data.aws_region.current.name # fetching the name from the exported data name attribute in here 

            }
        }
    
    ```

    - we can find the `exported data` attribut info in the `terraform registry` as below 
    
    - we need to go to `registry.terraform.io` &rarr; `select terraform AWS Provider` &rarr; `documentation` &rarr; `Data_Source`
    
    - the `aws_region` which is the `data source type` we are using inside the `Meta Data Source/Data Sources` which is not a part of `any resource block` rather an `independent block` which `exists outside`
    
    - but there will be also `Data Source` present inside the `individual Resource` of the `Terraform AWS provider`
    
    - then we can see `aws_region` inside the `Data Source` we can fetch 
      
        - `Argument Reference` :- argument that we can provide to the `data block` in order to `query the API`
        
        - `Attribute Reference`  :- `data attribute` which will be `exported from the data Source`

    - we can get data about the `aws_region data source` from the `Terraform AWS Provider` without going to the `specific resource` directly under `Meta Data Source/Data Sources` as below 

        - `aws_arn`
        
        - `aws_billing_service_account`
        
        - `aws_default_tags` 
        
        - `aws_ip_ranges` 

        - `aws_partition`
        
        - `aws_region` :- which `provide details` about `specific AWS region`
          
          - `Argument Reference` 
          
            - this will take the `name` which will be `fiull name` of the `region` to `select` as `argument reference`
          
            - this will also take `endpoint` which will be the `EC2 End point` of the `region to select` in this case  
          
          - `Attribute Reference` 
            
            - this will provide the `name of the selected region` as the `name` which we are using `terraform configuration`
            
            - The `endpoint` as `EC2 endpoint` for the `selected region`
            
            - the  `description` as `region description` in the fomat as `Location(Region Name)`      
        
        - `aws_regions`  
        
        - `aws_service` 

    - we can also find the `Data Sources` specific to the `Resources of AWS` as well  
      
      - in this case case if we select `EC2` then we can see the `Resource` and `Data_Source` . 
      
      - one of the example can be of `aws_instance` as the `data source` which will provide the details about the `instances`
      
      - these `Data Source` in the `Terraform registry` can be used as the `data block` inside the `terraform registry` 
      
      - similarly if we are selecting the `EKS` then we can see the `Resource` and `Data_Source`.
      
      -  one  fo the `Data Source` is of `aws_eks_cluster` using which
      
      - we can gather info such as below as `data export`
        
        - `what is the kubernetes version`
        
        - `what is the id of the EKS cluster`
        
        - `what is the arn of the EKS cluster`     
      
      - if we are searching for the `Terraform vault Provider` which is for `hasicorp vault` then we can also see there the `Resource` and `Data Source`

    - now we can see the `terraform plan` and `Terraform apply -auto-approve` which will show the `execution plan` and `deployed infrastructure` in that case 

    - we can see the below output

    ```bash
        terraform plan
        # executing the terraform plan to show the execution plan
        # the output will be as below 
        # here as we are just deploying the resources hence we will not be getting any resourced destroyed and recreated rather it will just change the resource Tag
        data.aws_availability_zones.available: Reading...
        data.aws_region.current: Reading...
        aws_eip.nat_gateway_eip: Refreshing state... [id=eipalloc-03a6775df08c052a8]
        data.aws_ami.ubuntu: Reading...
        data.aws_region.current: Read complete after 0s [id=us-west-2]
        aws_vpc.vpc: Refreshing state... [id=vpc-09fd108638cfe2b16]
        data.aws_availability_zones.available: Read complete after 1s [id=us-west-2]
        data.aws_ami.ubuntu: Read complete after 1s [id=ami-079167f081a690d5a]
        aws_internet_gateway.public_internet_gateway: Refreshing state... [id=igw-07c97a5cc48872686]
        aws_subnet.private_subnets["private_subnet_1"]: Refreshing state... [id=subnet-05f7b671941fa6464]
        aws_subnet.public_subnet["public_subnet_1"]: Refreshing state... [id=subnet-0db9544773b5dbd47]
        aws_subnet.public_subnet["public_subnet_2"]: Refreshing state... [id=subnet-0c5076c56c94fa030]
        aws_subnet.public_subnet["public_subnet_3"]: Refreshing state... [id=subnet-02d806f35d570b4b8]
        aws_subnet.private_subnets["private_subnet_2"]: Refreshing state... [id=subnet-0077e56d4ed0a8e6b]
        aws_subnet.private_subnets["private_subnet_3"]: Refreshing state... [id=subnet-0e22fb5e5e8ec554f]
        aws_nat_gateway.private_nat_gateway: Refreshing state... [id=nat-02a4bdb521fee8e23]
        aws_route_table.public_route_table: Refreshing state... [id=rtb-0858c73609700f1fa]
        aws_instance.web_server: Refreshing state... [id=i-096b4f799abc57a35]
        aws_route_table.private_route_table: Refreshing state... [id=rtb-037baaef40bbc4981]
        aws_route_table_association.public_route_association["public_subnet_3"]: Refreshing state... [id=rtbassoc-0437cc2a9b1981a62]
        aws_route_table_association.public_route_association["public_subnet_1"]: Refreshing state... [id=rtbassoc-014882bc460db14ac]
        aws_route_table_association.public_route_association["public_subnet_2"]: Refreshing state... [id=rtbassoc-0068e08de80e4f41f]
        aws_route_table_association.private_route_association["private_subnet_3"]: Refreshing state... [id=rtbassoc-0bee23df5ba5e61d3]
        aws_route_table_association.private_route_association["private_subnet_1"]: Refreshing state... [id=rtbassoc-0f643bcf78a28f709]
        aws_route_table_association.private_route_association["private_subnet_2"]: Refreshing state... [id=rtbassoc-086d8c7eb7fd06128]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        ~ update in-place

        Terraform will perform the following actions:

        # aws_vpc.vpc will be updated in-place
        ~ resource "aws_vpc" "vpc" {
                id                                   = "vpc-09fd108638cfe2b16"
            ~ tags                                 = {
                    "Terraform" = "true"
                + "region"    = "us-west-2"
                }
            ~ tags_all                             = {
                + "region"    = "us-west-2"
                    # (1 unchanged element hidden)
                }
                # (14 unchanged attributes hidden)
            }

        Plan: 0 to add, 1 to change, 0 to destroy.

        ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

        Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

        # we can use the terraform apply -auto-approve to deploy the infrastructure
        terraform apply -auto-approve
        # below will be the output in that case 
        data.aws_availability_zones.available: Reading...
        data.aws_region.current: Reading...
        data.aws_ami.ubuntu: Reading...
        aws_eip.nat_gateway_eip: Refreshing state... [id=eipalloc-03a6775df08c052a8]
        data.aws_region.current: Read complete after 0s [id=us-west-2]
        aws_vpc.vpc: Refreshing state... [id=vpc-09fd108638cfe2b16]
        data.aws_availability_zones.available: Read complete after 1s [id=us-west-2]
        data.aws_ami.ubuntu: Read complete after 1s [id=ami-079167f081a690d5a]
        aws_internet_gateway.public_internet_gateway: Refreshing state... [id=igw-07c97a5cc48872686]
        aws_subnet.public_subnet["public_subnet_1"]: Refreshing state... [id=subnet-0db9544773b5dbd47]
        aws_subnet.private_subnets["private_subnet_2"]: Refreshing state... [id=subnet-0077e56d4ed0a8e6b]
        aws_subnet.private_subnets["private_subnet_3"]: Refreshing state... [id=subnet-0e22fb5e5e8ec554f]
        aws_subnet.public_subnet["public_subnet_3"]: Refreshing state... [id=subnet-02d806f35d570b4b8]
        aws_subnet.public_subnet["public_subnet_2"]: Refreshing state... [id=subnet-0c5076c56c94fa030]
        aws_subnet.private_subnets["private_subnet_1"]: Refreshing state... [id=subnet-05f7b671941fa6464]
        aws_route_table.public_route_table: Refreshing state... [id=rtb-0858c73609700f1fa]
        aws_nat_gateway.private_nat_gateway: Refreshing state... [id=nat-02a4bdb521fee8e23]
        aws_instance.web_server: Refreshing state... [id=i-096b4f799abc57a35]
        aws_route_table.private_route_table: Refreshing state... [id=rtb-037baaef40bbc4981]
        aws_route_table_association.public_route_association["public_subnet_1"]: Refreshing state... [id=rtbassoc-014882bc460db14ac]
        aws_route_table_association.public_route_association["public_subnet_3"]: Refreshing state... [id=rtbassoc-0437cc2a9b1981a62]
        aws_route_table_association.public_route_association["public_subnet_2"]: Refreshing state... [id=rtbassoc-0068e08de80e4f41f]
        aws_route_table_association.private_route_association["private_subnet_1"]: Refreshing state... [id=rtbassoc-0f643bcf78a28f709]
        aws_route_table_association.private_route_association["private_subnet_3"]: Refreshing state... [id=rtbassoc-0bee23df5ba5e61d3]
        aws_route_table_association.private_route_association["private_subnet_2"]: Refreshing state... [id=rtbassoc-086d8c7eb7fd06128]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        ~ update in-place

        Terraform will perform the following actions:

        # aws_vpc.vpc will be updated in-place
        ~ resource "aws_vpc" "vpc" {
                id                                   = "vpc-09fd108638cfe2b16"
            ~ tags                                 = {
                    "Terraform" = "true"
                + "region"    = "us-west-2"
                }
            ~ tags_all                             = {
                + "region"    = "us-west-2"
                    # (1 unchanged element hidden)
                }
                # (14 unchanged attributes hidden)
            }

        Plan: 0 to add, 1 to change, 0 to destroy.
        aws_vpc.vpc: Modifying... [id=vpc-09fd108638cfe2b16]
        aws_vpc.vpc: Modifications complete after 9s [id=vpc-09fd108638cfe2b16]

        Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
            
    ```

  - **Task02**
  
  -  view the `data source` used to `retrieve` the `availability zone` with in the `region`

  - we will be using that info in order to `create public or private subnet` in that case 
  
  - we can define the `terraform configuration` file as below 

    ```tf
        main.tf
        =======

        data "aws_availabaility_zones" "available" {}
        
        # here the data source as  aws_availabaility_zones will fetch all availabilty zones inside the particular region
        # in AWS we have bunch of region and each region has different number of availabilty zone
        # we can use the `data-lookup` to deploy the `Same exact configuration` for `different different region` 
        # here we will be using the data lookup which can be used with private_subnet and public_subnet 
        # using the data block inside the public_subnet in this case
        resource "aws_subnet" "public_subnet" {
            for_each = var.public_subnet # fetching the public subnet that we have define in the variable file
            vpc_id = aws_vpc.vpc.id # fetching the vpc from the VPC that we have created earlier
            cidr_block = cidrsubnet(var.vpc_cidr,8,each.value) # fetching the cidr value from the cidrfunction using it for vpc
            availabilty_zone = tolist(data.aws_availabaility_zones.available.names)[each.value]
            # fetching the aws_availability_zone using tolist() function out in here 
            tags = { # defining the tags in this case

                Key = each.key # here using the each.key as the reference
                Terraform ="true" # using the Terraform Tags as true in this case 

            }  

        }

        # using the data block inside the private_subnet in this case
        resource "aws_subnet" "private_subnet" {
            for_each = var.[private_subnet] # fetching the privatre subnet that we have define in the variable file
            vpc_id = aws_vpc.vpc.id # fetching the vpc from the VPC that we have created earlier
            cidr_block = cidrsubnet(var.vpc_cidr,8,each.value) # fetching the cidr value from the cidrfunction using it for vpc
            availabilty_zone = tolist(data.aws_availabaility_zones.available.names)[each.value]
            # fetching the aws_availability_zone using tolist() function out in here 
            tags = { # defining the tags in this case

                Key = each.key # here using the each.key as the reference
                Terraform ="true" # using the Terraform Tags as true in this case 

            }  

        }
    
    ```

    - as we are fetching the `aws_aviailabilty_zone` using the `data source` after `querying AWS` hence this `tyerraform configuration` can be reused in any `terraform configuration` having any `AWS region` and it will work fine
    
    - which will make the `terraform configuration` more `reuseable` and `we don't have to make the terraform configuration based on a particular region` 
  
  - **Task03**
  
  - create a `new data source` using the `data block` to create `different ubuntu image`  
  
  - we can define the `terraform configuration` as below 

    ```tf
        main.tf
        =======

        data "aws_ami" "ubuntu" { # here we are using the aws_ami data resource we need to fetch the particular ami

          most_recent      = true # defining the most recent value as true , If more than one result is returned, use the most recent AMI.
          owners           = ["amazon"] # (Optional) List of AMI owners to limit search. Valid values: an AWS account ID, self (the current account), or an AWS owner alias (e.g., amazon, aws-marketplace, microsoft).
          
          filter {  # One or more name/value pairs to filter off of
            name   = "virtualization-type" # checking the virtualization type as hvm in this case 
            values = ["hvm"]
          }

          filter { # One or more name/value pairs to filter off of
            name   = "name" # here using the name of the image that we want to filter out
            values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # value of the image reference which can be ferched from the launch instance
          }
                  
        }

        resource "aws_instance" "web-server" { # defining the resource as the awes_instance in this case out in here 

          vpc_security_group_ids = [aws_vpc.vpc.default_security_group_id]       # fetching the vpc_security_group_ids as the default security group of the VPC reference that we have created 
          ami                    = data.aws_ami.ubuntu.id                        # fetching the ami from the data resource or block in here 
          instance_type          = "t2.micro"                                    # using the free tier account in this case
          subnet_id              = aws_subnet.public_subnet["public_subnet_1"].id # fetching the public subnet in this case 


        }
          
    ```
  - while deploying the `aws EC2 instance` using `aws_instance` resource then it need the `ami` to be `provided` by which it can determine whether they are `ubuntu/windows` image
  
  - here using the `data block` with the `filter` we can get the `ami of the image` , if we want to change the `instance type` then we can change only the `image name` as `ubuntu/images/hvm-ssd/ubuntu-focal-16.04-amd64-server-*` if we want to use the `ubuntu-22.04` image out in here 
  
  - then we can define the reference as below 

    ```tf
        main.tf
        =======
        data "aws_ami" "ubuntu" { # here we are using the aws_ami data resource we need to fetch the particular ami

          most_recent      = true # defining the most recent value as true , If more than one result is returned, use the most recent AMI.
          owners           = ["amazon"] # (Optional) List of AMI owners to limit search. Valid values: an AWS account ID, self (the current account), or an AWS owner alias (e.g., amazon, aws-marketplace, microsoft).
          
          filter {  # One or more name/value pairs to filter off of
            name   = "virtualization-type" # checking the virtualization type as hvm in this case 
            values = ["hvm"]
          }

          filter { # One or more name/value pairs to filter off of
            name   = "name" # here using the name of the image that we want to filter out
            values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] # value of the image reference which can be ferched from the launch instance
          }
                  
        }

        resource "aws_instance" "web-server" { # defining the resource as the awes_instance in this case out in here 

          vpc_security_group_ids = [aws_vpc.vpc.default_security_group_id]       # fetching the vpc_security_group_ids as the default security group of the VPC reference that we have created 
          ami                    = data.aws_ami.ubuntu.id                        # fetching the ami from the data resource or block in here 
          instance_type          = "t2.micro"                                    # using the free tier account in this case
          subnet_id              = aws_subnet.public_subnet["public_subnet_1"].id # fetching the public subnet in this case 


        }

    ``` 

  - now when we want to use the `terraform plan` for `executiion plan` and `terraform apply -auto-approve` for `deploying the infrastructure` then we can use as below 
  
  - we will be getting the output in that case as below 

    ```bash
        terraform plan 
        # in order see the execution plan output in that case as below 
        # here as we are changing the image hence AWS will desatroy the prreveious EC2 instance and recreate the New Instance in that case 
        # we will be seeing the below output for response
        data.aws_region.current: Reading...
        data.aws_availability_zones.available: Reading...
        data.aws_ami.ubuntu: Reading...
        data.aws_region.current: Read complete after 0s [id=us-west-2]
        aws_vpc.vpc: Refreshing state... [id=vpc-0ae492b8f28a6ac4f]
        data.aws_availability_zones.available: Read complete after 1s [id=us-west-2]
        data.aws_ami.ubuntu: Read complete after 1s [id=ami-03d390062ea11f660]
        aws_subnet.private_subnet["private_subnet_3"]: Refreshing state... [id=subnet-04b1afd0888313894]
        aws_subnet.public_subnet["public_subnet_1"]: Refreshing state... [id=subnet-07a3f87c4d756113b]
        aws_subnet.public_subnet["public_subnet_3"]: Refreshing state... [id=subnet-03843c62e12c00066]
        aws_subnet.private_subnet["private_subnet_2"]: Refreshing state... [id=subnet-0c9c7bde9abd84a86]
        aws_subnet.private_subnet["private_subnet_1"]: Refreshing state... [id=subnet-08b8e2f8f849612be]
        aws_subnet.public_subnet["public_subnet_2"]: Refreshing state... [id=subnet-0d85fe9b7587df080]
        aws_instance.web-server: Refreshing state... [id=i-085395491d171bb7a]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        -/+ destroy and then create replacement

        Terraform will perform the following actions:

          # aws_instance.web-server must be replaced
        -/+ resource "aws_instance" "web-server" {
              ~ ami                                  = "ami-079167f081a690d5a" -> "ami-03d390062ea11f660" # forces replacement
              ~ arn                                  = "arn:aws:ec2:us-west-2:115170445162:instance/i-085395491d171bb7a" -> (known after apply)
              ~ associate_public_ip_address          = false -> (known after apply)
              ~ availability_zone                    = "us-west-2b" -> (known after apply)
              ~ cpu_core_count                       = 1 -> (known after apply)
              ~ cpu_threads_per_core                 = 1 -> (known after apply)
              ~ disable_api_stop                     = false -> (known after apply)
              ~ disable_api_termination              = false -> (known after apply)
              ~ ebs_optimized                        = false -> (known after apply)
              - hibernation                          = false -> null
              + host_id                              = (known after apply)
              + host_resource_group_arn              = (known after apply)
              + iam_instance_profile                 = (known after apply)
              ~ id                                   = "i-085395491d171bb7a" -> (known after apply)
              ~ instance_initiated_shutdown_behavior = "stop" -> (known after apply)
              + instance_lifecycle                   = (known after apply)
              ~ instance_state                       = "running" -> (known after apply)
              ~ ipv6_address_count                   = 0 -> (known after apply)
              ~ ipv6_addresses                       = [] -> (known after apply)
              + key_name                             = (known after apply)
              ~ monitoring                           = false -> (known after apply)
              + outpost_arn                          = (known after apply)
              + password_data                        = (known after apply)
              + placement_group                      = (known after apply)
              ~ placement_partition_number           = 0 -> (known after apply)
              ~ primary_network_interface_id         = "eni-0961da919ba21a411" -> (known after apply)
              ~ private_dns                          = "ip-10-0-1-235.us-west-2.compute.internal" -> (known after apply)
              ~ private_ip                           = "10.0.1.235" -> (known after apply)
              + public_dns                           = (known after apply)
              + public_ip                            = (known after apply)
              ~ secondary_private_ips                = [] -> (known after apply)
              ~ security_groups                      = [] -> (known after apply)
              + spot_instance_request_id             = (known after apply)
              - tags                                 = {} -> null
              ~ tags_all                             = {} -> (known after apply)
              ~ tenancy                              = "default" -> (known after apply)
              + user_data                            = (known after apply)
              + user_data_base64                     = (known after apply)
                # (6 unchanged attributes hidden)

              - capacity_reservation_specification {
                  - capacity_reservation_preference = "open" -> null
                }

              - cpu_options {
                  - core_count       = 1 -> null
                  - threads_per_core = 1 -> null
                }

              - credit_specification {
                  - cpu_credits = "standard" -> null
                }

              - enclave_options {
                  - enabled = false -> null
                }

              - maintenance_options {
                  - auto_recovery = "default" -> null
                }

              - metadata_options {
                  - http_endpoint               = "enabled" -> null
                  - http_protocol_ipv6          = "disabled" -> null
                  - http_put_response_hop_limit = 1 -> null
                  - http_tokens                 = "optional" -> null
                  - instance_metadata_tags      = "disabled" -> null
                }

              - private_dns_name_options {
                  - enable_resource_name_dns_a_record    = false -> null
                  - enable_resource_name_dns_aaaa_record = false -> null
                  - hostname_type                        = "ip-name" -> null
                }

              - root_block_device {
                  - delete_on_termination = true -> null
                  - device_name           = "/dev/sda1" -> null
                  - encrypted             = false -> null
                  - iops                  = 100 -> null
                  - tags                  = {} -> null
                  - throughput            = 0 -> null
                  - volume_id             = "vol-0b4ee068cb0899532" -> null
                  - volume_size           = 8 -> null
                  - volume_type           = "gp2" -> null
                }
            }

        Plan: 1 to add, 0 to change, 1 to destroy.

        ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

        Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform
        apply" now.

        # we can also run the terraform apply 0-auto-approve in order to deploy the infrastructure as below 
        terraform apply -auto-approve
        # below will be the output for the same 
        data.aws_availability_zones.available: Reading...
        data.aws_ami.ubuntu: Reading...
        data.aws_region.current: Reading...
        data.aws_region.current: Read complete after 0s [id=us-west-2]
        aws_vpc.vpc: Refreshing state... [id=vpc-0ae492b8f28a6ac4f]
        data.aws_availability_zones.available: Read complete after 1s [id=us-west-2]
        data.aws_ami.ubuntu: Read complete after 1s [id=ami-03d390062ea11f660]
        aws_subnet.public_subnet["public_subnet_1"]: Refreshing state... [id=subnet-07a3f87c4d756113b]
        aws_subnet.private_subnet["private_subnet_2"]: Refreshing state... [id=subnet-0c9c7bde9abd84a86]
        aws_subnet.public_subnet["public_subnet_2"]: Refreshing state... [id=subnet-0d85fe9b7587df080]
        aws_subnet.private_subnet["private_subnet_1"]: Refreshing state... [id=subnet-08b8e2f8f849612be]
        aws_subnet.private_subnet["private_subnet_3"]: Refreshing state... [id=subnet-04b1afd0888313894]
        aws_subnet.public_subnet["public_subnet_3"]: Refreshing state... [id=subnet-03843c62e12c00066]
        aws_instance.web-server: Refreshing state... [id=i-085395491d171bb7a]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        -/+ destroy and then create replacement

        Terraform will perform the following actions:

          # aws_instance.web-server must be replaced
        -/+ resource "aws_instance" "web-server" {
              ~ ami                                  = "ami-079167f081a690d5a" -> "ami-03d390062ea11f660" # forces replacement
              ~ arn                                  = "arn:aws:ec2:us-west-2:115170445162:instance/i-085395491d171bb7a" -> (known after apply)
              ~ associate_public_ip_address          = false -> (known after apply)
              ~ availability_zone                    = "us-west-2b" -> (known after apply)
              ~ cpu_core_count                       = 1 -> (known after apply)
              ~ cpu_threads_per_core                 = 1 -> (known after apply)
              ~ disable_api_stop                     = false -> (known after apply)
              ~ disable_api_termination              = false -> (known after apply)
              ~ ebs_optimized                        = false -> (known after apply)
              - hibernation                          = false -> null
              + host_id                              = (known after apply)
              + host_resource_group_arn              = (known after apply)
              + iam_instance_profile                 = (known after apply)
              ~ id                                   = "i-085395491d171bb7a" -> (known after apply)
              ~ instance_initiated_shutdown_behavior = "stop" -> (known after apply)
              + instance_lifecycle                   = (known after apply)
              ~ instance_state                       = "running" -> (known after apply)
              ~ ipv6_address_count                   = 0 -> (known after apply)
              ~ ipv6_addresses                       = [] -> (known after apply)
              + key_name                             = (known after apply)
              ~ monitoring                           = false -> (known after apply)
              + outpost_arn                          = (known after apply)
              + password_data                        = (known after apply)
              + placement_group                      = (known after apply)
              ~ placement_partition_number           = 0 -> (known after apply)
              ~ primary_network_interface_id         = "eni-0961da919ba21a411" -> (known after apply)
              ~ private_dns                          = "ip-10-0-1-235.us-west-2.compute.internal" -> (known after apply)
              ~ private_ip                           = "10.0.1.235" -> (known after apply)
              + public_dns                           = (known after apply)
              + public_ip                            = (known after apply)
              ~ secondary_private_ips                = [] -> (known after apply)
              ~ security_groups                      = [] -> (known after apply)
              + spot_instance_request_id             = (known after apply)
              - tags                                 = {} -> null
              ~ tags_all                             = {} -> (known after apply)
              ~ tenancy                              = "default" -> (known after apply)
              + user_data                            = (known after apply)
              + user_data_base64                     = (known after apply)
                # (6 unchanged attributes hidden)

              - capacity_reservation_specification {
                  - capacity_reservation_preference = "open" -> null
                }

              - cpu_options {
                  - core_count       = 1 -> null
                  - threads_per_core = 1 -> null
                }

              - credit_specification {
                  - cpu_credits = "standard" -> null
                }

              - enclave_options {
                  - enabled = false -> null
                }

              - maintenance_options {
                  - auto_recovery = "default" -> null
                }

              - metadata_options {
                  - http_endpoint               = "enabled" -> null
                  - http_protocol_ipv6          = "disabled" -> null
                  - http_put_response_hop_limit = 1 -> null
                  - http_tokens                 = "optional" -> null
                  - instance_metadata_tags      = "disabled" -> null
                }

              - private_dns_name_options {
                  - enable_resource_name_dns_a_record    = false -> null
                  - enable_resource_name_dns_aaaa_record = false -> null
                  - hostname_type                        = "ip-name" -> null
                }

              - root_block_device {
                  - delete_on_termination = true -> null
                  - device_name           = "/dev/sda1" -> null
                  - encrypted             = false -> null
                  - iops                  = 100 -> null
                  - tags                  = {} -> null
                  - throughput            = 0 -> null
                  - volume_id             = "vol-0b4ee068cb0899532" -> null
                  - volume_size           = 8 -> null
                  - volume_type           = "gp2" -> null
                }
            }

        Plan: 1 to add, 0 to change, 1 to destroy.
        aws_instance.web-server: Destroying... [id=i-085395491d171bb7a]
        aws_instance.web-server: Still destroying... [id=i-085395491d171bb7a, 10s elapsed]
        aws_instance.web-server: Still destroying... [id=i-085395491d171bb7a, 20s elapsed]
        aws_instance.web-server: Still destroying... [id=i-085395491d171bb7a, 30s elapsed]
        aws_instance.web-server: Still destroying... [id=i-085395491d171bb7a, 40s elapsed]
        aws_instance.web-server: Destruction complete after 43s
        aws_instance.web-server: Creating...
        aws_instance.web-server: Still creating... [10s elapsed]
        aws_instance.web-server: Still creating... [20s elapsed]
        aws_instance.web-server: Still creating... [30s elapsed]
        aws_instance.web-server: Creation complete after 35s [id=i-0c1764c68b4d10a3d]

        Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
                    
    ```

    - here using the `data block` the `terraform` will `query for the AWS image` which will be reused inside the `aws_instances` hence the `preveious resource` will going to be get `destroyed` and new one will be going to be `get created` because of the changes

  




