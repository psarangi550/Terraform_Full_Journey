# Lab: Terraform Workspaces - OSS

- Objective `4D` of the `Hashicorp Terraform associate command` ask `Given us a condition` when we have to use the `Terraform workspace` command to `create workspace`

- here we will go through the `Terraform workspace command` namely the `open source version of the Terraform Workspace command`

- `Terraform Workspace command` `used within both`
  
  - `Terraform Open Source`
  
  - `Terraform Cloud and Enterprise`

  - The `Terraform workspace` is `same in term of their name `, `they are different` , in terms of the `mechanics` , `How they are used`

- Those `who adopt Terraform typically` `want` to `leverage the principles of DRY (Don’t Repeat Yourself) development practices`

- `One way to adopt this principle with respect to IaC is to utilize the same code base for different environments (development, quality, production, etc.)`

- `Workspaces` is a `Terraform` `feature` that `allows us to organize infrastructure` `by environments ` and `variables` `in a single directory`. 

- As we know `Terraform is a stateful architecture` , hence it need a place to `store the state inside state file` which is the `.tfstate file`

- these `.tfstate state file` used by `Terraform` to `map` the `real world resources` into the `Terraform configuration` , it need a place to store the `state`

- `Terraform state` belong to a `Terraform Workspace`  

- infact `All the preveious Lab` we are `deploying` the `Terraform configuration` and `associated Terraform States` in a `default workspace`

- but we can `change` in `which workspace` we want to `store` the `state file for Terraform state` , we can choose on which `Terraform workspace` we want to store the `Terraform state`

**Lab**

- here we will learn `Terraform workspace` command 

- How it related to the `DRY(Don't Repeat Yourself) principles` 

- then How to `toggle` between for `different different environment`

- if we use the `terraform workspace` command gives us the below response 

    ```bash
        terraform workspace # here we are using the terraform workspace command in here 
        #OR we can also use the command as below 
        terraform workspace -help # displaying the help command for the Terraform workspace
        # we can see the output in this case as below 
        Usage: terraform [global options] workspace

        new, list, show, select and delete Terraform workspaces.

        Subcommands:
            delete    Delete a workspace
            list      List Workspaces
            new       Create a new workspace
            select    Select a workspace
            show      Show the name of the current workspace
    
    ```

- tere are couple of option which can be used along with the `terraform workspace` command as below 

    - `new`
    - `show`
    - `list`
    - `select`
    - `delete`

- we can use this command as `terraform workspace <option> <appropriate option>`

- if we are using the `show` which will show the `current Terraform workspace` which being selected 

- we can use the command as below 

    ```bash
        terraform workspace show
        # this will showcase the terraform workspace in this case out in here 
        default # here deefault means currently we are inside the default terraform workspace
    
    ```

- infact `Preveious Terraform configuration` and `associated Terraform State` are being inside `default Terraform workspace` in this case 

- we want to use the `Same Terraform configuration` , but we want to `deploy it to` the `different region within the AWS`

- currently the `Terraform configuration` been deployed to `us-west-2 i.e origon region` , but if we want to deploy the `same infrastructure and same Terraform configuration` onto the `us-east-1 i.e North Virginia region`

- before creating the `Terraform configuration` to `deploy the infrastructure` we need to create the `new Terraform Open Source version Workspace`

- for that we can use the command as `terraform workspace new <env name>` , which will provide the below output 

    ```bash
        terraform workspace new Development 
        # creating a new workspace named as development using the terraform workspace command in this case 
        # the output will be as below 
        Created and switched to workspace "Development"!
        # now the workspace with name as Development been created and also been checked out as well
        You're now on a "new, empty workspace". Workspaces isolate their state,
        so if you run "terraform plan" Terraform will not see any existing state
        for this configuration.
            
    
    ```

- here we have created `new empty Terraform workspace` where we can store the `Terraform state files` , all the `Development work state file` will be saved into the `Development Terraform workspace`

- now when we use the command as `terraform workspace show` then which will show the `current Terraform workspace  whewre we are in`

- if we are using the `terraform workspace show` mcommand we will be getting the below output in this case over here 

    ```bash
        terraform workspace show
        # here this will show the current workspace we are in 
        Development

    ```
- we can also list the `T^erraform Workspace` using the command as `terraform workspace list` which will provide below result 

    ```bash
        terraform workspace list 
        # this will list out all the terraform workspace which being available 
        # here we will be seeing the current terraform workspace mentioned with * mark in this case 
        default
        * Development   # this is the current Terraform workspace thats we are in 
    
    ```

- all the `preveious deployment` where we have the `Terraform configuration and associated Terraform state file` are all being saved within `default Terraform workspace`

- we can run the `terraform show` which will `display all existing resources` deployed by the `Terraform configuration`

- but in here we don't have the `Terraform statefile` as the `terraform workspace currently we are in development` and `no Terraform statefile being present there`

- if we run the command as `terraform show` below will be the output as we are inside the `Development Terraform workspace`

    
    ```bash
        terraform show
        # as we are currently inside the Development Terraform workspace hence the output in this case will be as below 
        No state
        # this will be the output that  we will be seeing as the output 
    

    ```

- then we can change the `Terraform configuration` in order to point to the `us-east-1` region

- we can write the `Terraform configuration as below`

    ```tf
        main.tf
        =======
        provider "aws" { # defining the provider section as AWS in here

            region = "us-east-1" # defining the region as us-east-1

            default_tags { # providing the default tags which will be applied to all the resource
            
            tags = { # providing the tags in the form of key-value pair

                OWNER = "Acme"
                PROVIDER = "Terraform"

            }

            }
        
        }


        data "aws_availability_zones" "available" {} # defining the data section to get all the aws_availability_zones

        resource "aws_vpc" "vpc" { # defining the AWS vpc in this particular cases out in here 

            cidr_block = var.vpc_cidr # defining the cidr_block as reference to the variable block

            tags = { # defining thetags in here

                NAME = "AWS VPC"
            }
        }

        resource "aws_subnet" "public_subnet" { # defining the public_subnet using the aws_subnet resource

            for_each = var.public_subnet # iterating over each of the public_subnet
            vpc_id = aws_vpc.vpc.id # referencing the vpc_id in this case out in here 
            cidr_block = cidrsubnet(var.vpc_cidr,8,each.value +100) # defining thecidr_block using the cidrsubnet() with the variable vpc_cidr
            availability_zone = tolist(data.aws_availability_zones.available.names)[each.value] # associating the availabity_zone inside the public_subnet
            map_public_ip_on_launch = true # maaping the public_ip once the subnet been associated to the EC2 instance

            tags = { # providing the tags in here 

                Terraform = "true"
            }


        }

        resource "aws_subnet" "private_subnet" { # defining the private_subnet using the aws_subnet resource

            for_each = var.private_subnet #iterating over each of the private_subnet defined in variables.tf
            vpc_id = aws_vpc.vpc.id # referencing the vpc_id in this case out in here 
            cidr_block = cidrsubnet(var.vpc_cidr,8,each.value) # defining thecidr_block using the cidrsubnet() with the variable vpc_cidr
            availability_zone = tolist(data.aws_availability_zones.available.names)[each.value] #associating the availabity_zone inside the public_subnet

            tags = { # defining the tags out in here 

                Terraform = "true"
            }


        }

    
    ```

- when we run the `terraform plan` to see the `execution plan` , it will `create all the resource(which is created as a part of default Terraform workspace)` to create again 

- as we are inside the `Terraform Development workspace` which `does not have any statefile` unlike the `default Terraform workspace(where the Terraform statefile being present)`

- if we are `running the same command over the default Terraform workspace` as the `current workspace` it `will not create all those resource` as the `Terraform statefile` already present 

- as we have `moved to the us-east-1` and inside the `Development Terraform workspace` then it will try to `create these resource` and `save the Terraform state` into the `Development Workspace` as non of `Resources yet created`

- now when we ran the `terraform plan` and `Terraform apply -auto-approve` to `see the execution plan and deploy the infrastructure` hence we will be getting the below output 

    ```bash
        terraform plan # seeing the execution plan using the Terraform Plan command in this case out in here 
        data.aws_availability_zones.available: Reading...
        data.aws_availability_zones.available: Read complete after 2s [id=us-east-1]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "NAME"     = "AWS VPC"
                + "OWNER"    = "Acme"
                + "PROVIDER" = "Terraform"
                }
            }

        Plan: 7 to add, 0 to change, 0 to destroy.

        ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

        Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
    
        # when we aran the terraform apply a-uto-approve to deplo0y the infrastructure then we can use the command as below 
        terraform apply -auto-approve
        # below will be output for the same 
        data.aws_availability_zones.available: Reading...
        data.aws_availability_zones.available: Read complete after 1s [id=us-east-1]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "OWNER"     = "Acme"
                + "PROVIDER"  = "Terraform"
                + "Terraform" = "true"
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
                + "NAME"     = "AWS VPC"
                + "OWNER"    = "Acme"
                + "PROVIDER" = "Terraform"
                }
            }

        Plan: 7 to add, 0 to change, 0 to destroy.
        aws_vpc.vpc: Creating...
        aws_vpc.vpc: Creation complete after 5s [id=vpc-0a0ccba9834ebc9cd]
        aws_subnet.public_subnet["public_subnet_3"]: Creating...
        aws_subnet.public_subnet["public_subnet_2"]: Creating...
        aws_subnet.private_subnet["private_subnet_2"]: Creating...
        aws_subnet.private_subnet["private_subnet_1"]: Creating...
        aws_subnet.private_subnet["private_subnet_3"]: Creating...
        aws_subnet.public_subnet["public_subnet_1"]: Creating...
        aws_subnet.private_subnet["private_subnet_1"]: Creation complete after 3s [id=subnet-0db95fae8fec28d25]
        aws_subnet.private_subnet["private_subnet_2"]: Creation complete after 3s [id=subnet-0b19b0f96f58ab2f9]
        aws_subnet.private_subnet["private_subnet_3"]: Creation complete after 3s [id=subnet-0be3db935fa022306]
        aws_subnet.public_subnet["public_subnet_1"]: Still creating... [10s elapsed]
        aws_subnet.public_subnet["public_subnet_2"]: Still creating... [10s elapsed]
        aws_subnet.public_subnet["public_subnet_3"]: Still creating... [10s elapsed]
        aws_subnet.public_subnet["public_subnet_3"]: Creation complete after 13s [id=subnet-0dd5b08839a22563e]
        aws_subnet.public_subnet["public_subnet_2"]: Creation complete after 13s [id=subnet-0fc8c905534cf95e8]
        aws_subnet.public_subnet["public_subnet_1"]: Creation complete after 13s [id=subnet-0748ec3360fd808d7]

        Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
    
    ```

- here we have `2 identical infrastructure` over `two different region` inside the `2 different Terraform workspace env`

- here we can manage the `respective Terraform Statefile` based on the `environment` using the `Terraform workspace command`

- **How to `toggle` between for `different different Workspaces`**

    - we can use the `terraform workspace select <workspace name>` in order to `switch between the Environment or Workspaces`
    
    - we can use the command as below in this case as 

    ```bash
        terraform workspace select Development
        # selecting the Development workspace in this case out in here 
        # the output will be as below 
        Switched to workspace "Development".

        terraform workspace select default 
        # selecting the default workspace in this case out in here 
        Switched to workspace "default".
        # switching to default workspace    
    
    ```


- when we run the `terraform show` command `Depending on the Terraform workspace` we are in `we can see the region as us-west-2 or us-east-1`

- we will get the below result outpout in this case 


    ```bash
        terraform workspace select Development
        # selecting the Development workspace in this case out in here 
        # the output will be as below 
        Switched to workspace "Development".

        # running the terraform show command in here 
        terraform show 
        # below will be the output as 
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

        # aws_subnet.private_subnet["private_subnet_1"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0db95fae8fec28d25"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1b"
            availability_zone_id                           = "use1-az1"
            cidr_block                                     = "10.0.1.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0db95fae8fec28d25"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-0a0ccba9834ebc9cd"
        }

        # aws_subnet.private_subnet["private_subnet_2"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0b19b0f96f58ab2f9"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1c"
            availability_zone_id                           = "use1-az2"
            cidr_block                                     = "10.0.2.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0b19b0f96f58ab2f9"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-0a0ccba9834ebc9cd"
        }

        # aws_subnet.private_subnet["private_subnet_3"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0be3db935fa022306"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1d"
            availability_zone_id                           = "use1-az4"
            cidr_block                                     = "10.0.3.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0be3db935fa022306"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-0a0ccba9834ebc9cd"
        }

        # aws_subnet.public_subnet["public_subnet_1"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0748ec3360fd808d7"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1b"
            availability_zone_id                           = "use1-az1"
            cidr_block                                     = "10.0.101.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0748ec3360fd808d7"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-0a0ccba9834ebc9cd"
        }

        # aws_subnet.public_subnet["public_subnet_2"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0fc8c905534cf95e8"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1c"
            availability_zone_id                           = "use1-az2"
            cidr_block                                     = "10.0.102.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0fc8c905534cf95e8"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-0a0ccba9834ebc9cd"
        }

        # aws_subnet.public_subnet["public_subnet_3"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-east-1:115170445162:subnet/subnet-0dd5b08839a22563e"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-east-1d"
            availability_zone_id                           = "use1-az4"
            cidr_block                                     = "10.0.103.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0dd5b08839a22563e"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-0a0ccba9834ebc9cd"
        }

        # aws_vpc.vpc:
        resource "aws_vpc" "vpc" {
            arn                                  = "arn:aws:ec2:us-east-1:115170445162:vpc/vpc-0a0ccba9834ebc9cd"
            assign_generated_ipv6_cidr_block     = false
            cidr_block                           = "10.0.0.0/16"
            default_network_acl_id               = "acl-0f9238cd5a9e64668"
            default_route_table_id               = "rtb-0473c33f00944654e"
            default_security_group_id            = "sg-058bc2b28106a14a2"
            dhcp_options_id                      = "dopt-0644d2a9e11a2ac8b"
            enable_dns_hostnames                 = false
            enable_dns_support                   = true
            enable_network_address_usage_metrics = false
            id                                   = "vpc-0a0ccba9834ebc9cd"
            instance_tenancy                     = "default"
            ipv6_netmask_length                  = 0
            main_route_table_id                  = "rtb-0473c33f00944654e"
            owner_id                             = "115170445162"
            tags                                 = {
                "NAME" = "AWS VPC"
            }
            tags_all                             = {
                "NAME"     = "AWS VPC"
                "OWNER"    = "Acme"
                "PROVIDER" = "Terraform"
            }
        }

    
        terraform workspace select default 
        # selecting the default workspace in this case out in here 
        Switched to workspace "default".
        # switching to default workspace   

        # running the terraform show command in here 
        terraform show 
        # below will be the output as 
        # data.aws_availability_zones.available:
        data "aws_availability_zones" "available" {
            group_names = [
                "us-west-2",
            ]
            id          = "us-west-2"
            names       = [
                "us-west-2a",
                "us-west-2b",
                "us-west-2c",
                "us-west-2d",
            ]
            zone_ids    = [
                "usw2-az1",
                "usw2-az2",
                "usw2-az3",
                "usw2-az4",
            ]
        }

        # aws_subnet.private_subnet["private_subnet_1"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-west-2:115170445162:subnet/subnet-0c900aa60f2d2ee94"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-west-2b"
            availability_zone_id                           = "usw2-az2"
            cidr_block                                     = "10.0.1.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0c900aa60f2d2ee94"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-09d472d0a9ae2f000"
        }

        # aws_subnet.private_subnet["private_subnet_2"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-west-2:115170445162:subnet/subnet-08766d9f6e2be2343"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-west-2c"
            availability_zone_id                           = "usw2-az3"
            cidr_block                                     = "10.0.2.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-08766d9f6e2be2343"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-09d472d0a9ae2f000"
        }

        # aws_subnet.private_subnet["private_subnet_3"]:
        resource "aws_subnet" "private_subnet" {
            arn                                            = "arn:aws:ec2:us-west-2:115170445162:subnet/subnet-0740db4e9c90cb35e"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-west-2d"
            availability_zone_id                           = "usw2-az4"
            cidr_block                                     = "10.0.3.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-0740db4e9c90cb35e"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = false
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-09d472d0a9ae2f000"
        }

        # aws_subnet.public_subnet["public_subnet_1"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-west-2:115170445162:subnet/subnet-00e158a3b6e5308d7"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-west-2b"
            availability_zone_id                           = "usw2-az2"
            cidr_block                                     = "10.0.101.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-00e158a3b6e5308d7"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-09d472d0a9ae2f000"
        }

        # aws_subnet.public_subnet["public_subnet_2"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-west-2:115170445162:subnet/subnet-01c5b6601609a1bee"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-west-2c"
            availability_zone_id                           = "usw2-az3"
            cidr_block                                     = "10.0.102.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-01c5b6601609a1bee"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-09d472d0a9ae2f000"
        }

        # aws_subnet.public_subnet["public_subnet_3"]:
        resource "aws_subnet" "public_subnet" {
            arn                                            = "arn:aws:ec2:us-west-2:115170445162:subnet/subnet-02252b72e689cce23"
            assign_ipv6_address_on_creation                = false
            availability_zone                              = "us-west-2d"
            availability_zone_id                           = "usw2-az4"
            cidr_block                                     = "10.0.103.0/24"
            enable_dns64                                   = false
            enable_lni_at_device_index                     = 0
            enable_resource_name_dns_a_record_on_launch    = false
            enable_resource_name_dns_aaaa_record_on_launch = false
            id                                             = "subnet-02252b72e689cce23"
            ipv6_native                                    = false
            map_customer_owned_ip_on_launch                = false
            map_public_ip_on_launch                        = true
            owner_id                                       = "115170445162"
            private_dns_hostname_type_on_launch            = "ip-name"
            tags                                           = {
                "Terraform" = "true"
            }
            tags_all                                       = {
                "OWNER"     = "Acme"
                "PROVIDER"  = "Terraform"
                "Terraform" = "true"
            }
            vpc_id                                         = "vpc-09d472d0a9ae2f000"
        }

        # aws_vpc.vpc:
        resource "aws_vpc" "vpc" {
            arn                                  = "arn:aws:ec2:us-west-2:115170445162:vpc/vpc-09d472d0a9ae2f000"
            assign_generated_ipv6_cidr_block     = false
            cidr_block                           = "10.0.0.0/16"
            default_network_acl_id               = "acl-00fbf68e04cc5d766"
            default_route_table_id               = "rtb-0c4e1ad0557ff4879"
            default_security_group_id            = "sg-06db2f0466f6903c2"
            dhcp_options_id                      = "dopt-0215febf03dfc72b8"
            enable_dns_hostnames                 = false
            enable_dns_support                   = true
            enable_network_address_usage_metrics = false
            id                                   = "vpc-09d472d0a9ae2f000"
            instance_tenancy                     = "default"
            ipv6_netmask_length                  = 0
            main_route_table_id                  = "rtb-0c4e1ad0557ff4879"
            owner_id                             = "115170445162"
            tags                                 = {
                "NAME" = "AWS VPC"
            }
            tags_all                             = {
                "NAME"     = "AWS VPC"
                "OWNER"    = "Acme"
                "PROVIDER" = "Terraform"
            }
        }
            

    ```

- we can use the `interpolation`in order to fetch which `Terraform workspace` we are in inside the `Terraform configuration`

- we can : utilize the `${terraform.workspace}` `interpolation` `sequence` `within your configuration`

- we can write the `main.tf` i.e `Terraform configuration` inside the `Development Terraform Workspace` as below 

    ```tf
        main.tf
        =======
        provider "aws" { # defining the provider section as AWS in here

            region = "us-east-1" # defining the region as us-east-1

            default_tags { # providing the default tags which will be applied to all the resource
            
            tags = { # providing the tags in the form of key-value pair

                Environment = terraform.workspace # here using the terraform.workspace to refer the Environment in the tags
                OWNER = "Acme"
                PROVIDER = "Terraform"

            }

            }
        
        }


        data "aws_availability_zones" "available" {} # defining the data section to get all the aws_availability_zones

        resource "aws_vpc" "vpc" { # defining the AWS vpc in this particular cases out in here 

            cidr_block = var.vpc_cidr # defining the cidr_block as reference to the variable block

            tags = { # defining thetags in here

                NAME = "AWS VPC"
            }
        }

        resource "aws_subnet" "public_subnet" { # defining the public_subnet using the aws_subnet resource

            for_each = var.public_subnet # iterating over each of the public_subnet
            vpc_id = aws_vpc.vpc.id # referencing the vpc_id in this case out in here 
            cidr_block = cidrsubnet(var.vpc_cidr,8,each.value +100) # defining thecidr_block using the cidrsubnet() with the variable vpc_cidr
            availability_zone = tolist(data.aws_availability_zones.available.names)[each.value] # associating the availabity_zone inside the public_subnet
            map_public_ip_on_launch = true # maaping the public_ip once the subnet been associated to the EC2 instance

            tags = { # providing the tags in here 

                Terraform = "true"
            }


        }

        resource "aws_subnet" "private_subnet" { # defining the private_subnet using the aws_subnet resource

            for_each = var.private_subnet #iterating over each of the private_subnet defined in variables.tf
            vpc_id = aws_vpc.vpc.id # referencing the vpc_id in this case out in here 
            cidr_block = cidrsubnet(var.vpc_cidr,8,each.value) # defining thecidr_block using the cidrsubnet() with the variable vpc_cidr
            availability_zone = tolist(data.aws_availability_zones.available.names)[each.value] #associating the availabity_zone inside the public_subnet

            tags = { # defining the tags out in here 

                Terraform = "true"
            }


        }

    ```

- Now as we are using the `us-east-1` region then we can go to the `Development Terraform workspace` , and run the `terraform plan` and `terraform apply -auto-approve` just to show the result as below 

- we can use that as below 

    ```bash
        terraform workspace select Development
        # selecting the Development workspace in this case out in here 
        # the output will be as below 
        Switched to workspace "Development".

        # now we can rn the terraform plan to show the execution plan in this case as 
        terraform plan
        # below will be the output in this case 
        # we can see the default tag of Environment been applied in here 
        data.aws_availability_zones.available: Reading...
        aws_vpc.vpc: Refreshing state... [id=vpc-0a0ccba9834ebc9cd]
        data.aws_availability_zones.available: Read complete after 2s [id=us-east-1]
        aws_subnet.private_subnet["private_subnet_1"]: Refreshing state... [id=subnet-0db95fae8fec28d25]
        aws_subnet.private_subnet["private_subnet_3"]: Refreshing state... [id=subnet-0be3db935fa022306]
        aws_subnet.private_subnet["private_subnet_2"]: Refreshing state... [id=subnet-0b19b0f96f58ab2f9]
        aws_subnet.public_subnet["public_subnet_2"]: Refreshing state... [id=subnet-0fc8c905534cf95e8]
        aws_subnet.public_subnet["public_subnet_3"]: Refreshing state... [id=subnet-0dd5b08839a22563e]
        aws_subnet.public_subnet["public_subnet_1"]: Refreshing state... [id=subnet-0748ec3360fd808d7]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        ~ update in-place

        Terraform will perform the following actions:

        # aws_subnet.private_subnet["private_subnet_1"] will be updated in-place
        ~ resource "aws_subnet" "private_subnet" {
                id                                             = "subnet-0db95fae8fec28d25"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.private_subnet["private_subnet_2"] will be updated in-place
        ~ resource "aws_subnet" "private_subnet" {
                id                                             = "subnet-0b19b0f96f58ab2f9"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.private_subnet["private_subnet_3"] will be updated in-place
        ~ resource "aws_subnet" "private_subnet" {
                id                                             = "subnet-0be3db935fa022306"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.public_subnet["public_subnet_1"] will be updated in-place
        ~ resource "aws_subnet" "public_subnet" {
                id                                             = "subnet-0748ec3360fd808d7"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.public_subnet["public_subnet_2"] will be updated in-place
        ~ resource "aws_subnet" "public_subnet" {
                id                                             = "subnet-0fc8c905534cf95e8"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.public_subnet["public_subnet_3"] will be updated in-place
        ~ resource "aws_subnet" "public_subnet" {
                id                                             = "subnet-0dd5b08839a22563e"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_vpc.vpc will be updated in-place
        ~ resource "aws_vpc" "vpc" {
                id                                   = "vpc-0a0ccba9834ebc9cd"
                tags                                 = {
                    "NAME" = "AWS VPC"
                }
            ~ tags_all                             = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (14 unchanged attributes hidden)
            }

        Plan: 0 to add, 7 to change, 0 to destroy.

        ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

        Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

        #now we can run the terraform apply command as below 
        terraform apply -auto-approve # this will deploy the infrastructure
        # bwlow will be the output in this case as 
        data.aws_availability_zones.available: Reading...
        aws_vpc.vpc: Refreshing state... [id=vpc-0a0ccba9834ebc9cd]
        data.aws_availability_zones.available: Read complete after 1s [id=us-east-1]
        aws_subnet.private_subnet["private_subnet_2"]: Refreshing state... [id=subnet-0b19b0f96f58ab2f9]
        aws_subnet.public_subnet["public_subnet_2"]: Refreshing state... [id=subnet-0fc8c905534cf95e8]
        aws_subnet.public_subnet["public_subnet_3"]: Refreshing state... [id=subnet-0dd5b08839a22563e]
        aws_subnet.private_subnet["private_subnet_1"]: Refreshing state... [id=subnet-0db95fae8fec28d25]
        aws_subnet.public_subnet["public_subnet_1"]: Refreshing state... [id=subnet-0748ec3360fd808d7]
        aws_subnet.private_subnet["private_subnet_3"]: Refreshing state... [id=subnet-0be3db935fa022306]

        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        ~ update in-place

        Terraform will perform the following actions:

        # aws_subnet.private_subnet["private_subnet_1"] will be updated in-place
        ~ resource "aws_subnet" "private_subnet" {
                id                                             = "subnet-0db95fae8fec28d25"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.private_subnet["private_subnet_2"] will be updated in-place
        ~ resource "aws_subnet" "private_subnet" {
                id                                             = "subnet-0b19b0f96f58ab2f9"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.private_subnet["private_subnet_3"] will be updated in-place
        ~ resource "aws_subnet" "private_subnet" {
                id                                             = "subnet-0be3db935fa022306"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.public_subnet["public_subnet_1"] will be updated in-place
        ~ resource "aws_subnet" "public_subnet" {
                id                                             = "subnet-0748ec3360fd808d7"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.public_subnet["public_subnet_2"] will be updated in-place
        ~ resource "aws_subnet" "public_subnet" {
                id                                             = "subnet-0fc8c905534cf95e8"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_subnet.public_subnet["public_subnet_3"] will be updated in-place
        ~ resource "aws_subnet" "public_subnet" {
                id                                             = "subnet-0dd5b08839a22563e"
                tags                                           = {
                    "Terraform" = "true"
                }
            ~ tags_all                                       = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (15 unchanged attributes hidden)
            }

        # aws_vpc.vpc will be updated in-place
        ~ resource "aws_vpc" "vpc" {
                id                                   = "vpc-0a0ccba9834ebc9cd"
                tags                                 = {
                    "NAME" = "AWS VPC"
                }
            ~ tags_all                             = {
                + "Environment" = "Development"
                    # (3 unchanged elements hidden)
                }
                # (14 unchanged attributes hidden)
            }

        Plan: 0 to add, 7 to change, 0 to destroy.
        aws_vpc.vpc: Modifying... [id=vpc-0a0ccba9834ebc9cd]
        aws_vpc.vpc: Modifications complete after 5s [id=vpc-0a0ccba9834ebc9cd]
        aws_subnet.private_subnet["private_subnet_3"]: Modifying... [id=subnet-0be3db935fa022306]
        aws_subnet.private_subnet["private_subnet_2"]: Modifying... [id=subnet-0b19b0f96f58ab2f9]
        aws_subnet.public_subnet["public_subnet_2"]: Modifying... [id=subnet-0fc8c905534cf95e8]
        aws_subnet.public_subnet["public_subnet_3"]: Modifying... [id=subnet-0dd5b08839a22563e]
        aws_subnet.public_subnet["public_subnet_1"]: Modifying... [id=subnet-0748ec3360fd808d7]
        aws_subnet.private_subnet["private_subnet_1"]: Modifying... [id=subnet-0db95fae8fec28d25]
        aws_subnet.private_subnet["private_subnet_3"]: Modifications complete after 1s [id=subnet-0be3db935fa022306]
        aws_subnet.public_subnet["public_subnet_2"]: Modifications complete after 1s [id=subnet-0fc8c905534cf95e8]
        aws_subnet.private_subnet["private_subnet_2"]: Modifications complete after 2s [id=subnet-0b19b0f96f58ab2f9]
        aws_subnet.public_subnet["public_subnet_3"]: Modifications complete after 2s [id=subnet-0dd5b08839a22563e]
        aws_subnet.private_subnet["private_subnet_1"]: Modifications complete after 2s [id=subnet-0db95fae8fec28d25]
        aws_subnet.public_subnet["public_subnet_1"]: Modifications complete after 2s [id=subnet-0748ec3360fd808d7]

        Apply complete! Resources: 0 added, 7 changed, 0 destroyed.
    

    ```

- by using the `terraform.workspace` as the `default tags` inside the `provider level` we can state that `every resources` that been created have the `Workspace name as the Tags`

- based on the `Terraform workspace` we are currently in `THose Resources` will be `tagged accordingly` 

- by using the `Terraform workspace` we can maintain the `same configuration` but `different region` and `different Terraform state maintained by respective Terraform workspace`

- we are using the `same configuration` but `toggle between the terraform workspaces` , if we `forget to make the toggle between the corresponding workspace` then that might be `riskey`

- In `Terraform cloud and Enterprise` will `disrisk if we forget to toggle between workspace or environment` 

- but if we are using it inside the `Terraform workspace Open Source` if we are not making those changes then `that can be riskey` , just be careful about it


