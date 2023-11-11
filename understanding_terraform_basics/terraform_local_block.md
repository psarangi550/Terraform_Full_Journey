# Terraform Local Block

- terraform `local block` often referred as `locals` , which is defined in `terraform configuratiuon` which will reduce the `repetative references` to `general expression` or `values`


- `locals` are very similar to the `input values` and can be referenced as the `traditional input values` through out the `terraform configuration`


- basically we are provding `locals` in order to refer to the `name to the result of an expression` , so we can refer to that `local variable` rather than `putting the expression` inside the `terraform configuration`

  - which will make the `easier to update it one place` in thge `terraform configuration`
  
  - which will also make the `terraform configuration` `easier to read` because we are `just referencing to the local variable` rather than `putting` the `expression in the resources we want to use` all over the `terraform configuration`


- the `local variable` need to `defined` inside the `locals block` , `underneath that` which we need to declare `local variable` listed underneath

- we can have `multiple locals block` inside the `terraform configuration` which define the `one or more local variable undearneath`

- one `variables in one locals block` can refer to the `variables in another locals block` if there were multiple `locals block` defined inside the `terraform configuration`

- each `locals block` can have `one or multiple local variable` which can be refered as `local.<local variable inside the locals block>`

- **Lab11**

  - here we will be adding some `locals block` into the `terraform configuration` and refer them in `terraform configuration`

  - here we will add the `locals block` inside the `terraform configuration` which will update the `EC2 instance` based on the `locals block` that we have `defined` which is of `web-server`
  
  - here we need to define the  `locals block` mostly defined at the beginning of the `terraform configuration`
  
  - we can define the `locals block` as below 

    ```tf
        main.tf
        =======
        locals { # defining the locals block in here 
          
          team = "api_mgmt_dev" # defining the local variable as the team

          application = "corp_api" # defining the local variables as the application

          server_name = "ec2-${var.environment}-api-${var.variable_sub_az}" # defining the server_name based on the input variable in reference

        }

        resource "aws_instance" "web-server" {

          ami = data.aws_ami.ubuntu.id # fetching the ami reference from the data block 
          instance_type = "t2.micro" # defining the instance_type as t2 micro in here 
          vpc_secuity_group_ids=[aws_vpc.vpc.default_security_group_id] # referencing the vpc_security_group_ids as the aws_vpc security group
          subnet_id = aws_subnet.public_subnet["public_subnet_1"].id # referencing the aws_subnet in this case out here 

          tags = {
              
              Name = local.server_name # refencing the servername and using it Tags in here 
              Owner = local.team # defining the application as local.team in here 
              App = local.application  # defining the App as the local.application in here  

          }

        }
    
    ```

    - we also have to define the `environment` and `variable_sub_az` as the `input variable` inside the `variable.tf` file in here 
    
    - we can define the `variable.tf` file  as below 

    ```tf
        variable.tf
        ===========

        variable "environment" {

          type = string # defining the type in here as string
          description = "SDLC environment" # defining the description in here 
          default = "dev" # defining the default variable as dev in here 

        }
    
      variable "variable_sub_az" {

        type = string # defining the type as string in here 
        description= "Defining the Availability Zone in here"
        # defining the description in this case 
        default="us-west-2a" # defining the default availanbilty zone 

      }
    
    

    ```
  
  - as here we are `changing the tags but not the resource property` in that case `AWS` will not `destroy and recreate the resource` but rather it will just change the `Name` Tag that we have `preveiously declared to the new one in this case` 
  
  - also we need to define the see the outcome as below 
  
  - if we run the `terraform plan` and `terraform apply -auto-approve` in order to `show the execution plan` and `deploy the infrastructure` then we can see the output as below  

  ```bash
      terraform plan
      # here displaying the terraform execution plan in this case 
      # the output in this case as below 
      data.aws_availability_zones.available: Reading...
      aws_eip.nat_gateway_eip: Refreshing state... [id=eipalloc-0433906e535a5f6a9]
      data.aws_ami.ubuntu: Reading...
      aws_vpc.vpc: Refreshing state... [id=vpc-0b6be4ad9e44ffd06]
      data.aws_availability_zones.available: Read complete after 1s [id=us-west-2]
      data.aws_ami.ubuntu: Read complete after 2s [id=ami-079167f081a690d5a]
      aws_subnet.public_subnet["public_subnet_1"]: Refreshing state... [id=subnet-0154904dc42709956]
      aws_subnet.private_subnets["private_subnet_3"]: Refreshing state... [id=subnet-0878ed4aed8d38a7c]
      aws_internet_gateway.public_internet_gateway: Refreshing state... [id=igw-0d0fd536cf6f9fb61]
      aws_subnet.private_subnets["private_subnet_2"]: Refreshing state... [id=subnet-0d2f7a92901e1b7ce]
      aws_subnet.public_subnet["public_subnet_2"]: Refreshing state... [id=subnet-0d14bb19411f30ba0]
      aws_subnet.private_subnets["private_subnet_1"]: Refreshing state... [id=subnet-02137d856e67a6b3a]
      aws_subnet.public_subnet["public_subnet_3"]: Refreshing state... [id=subnet-05a96b9e9af891eb5]
      aws_nat_gateway.private_nat_gateway: Refreshing state... [id=nat-0e7652856beebe065]
      aws_route_table.public_route_table: Refreshing state... [id=rtb-01c4c98895e272adf]
      aws_instance.web_server: Refreshing state... [id=i-00cd814c77bc90e39]
      aws_route_table_association.public_route_association["public_subnet_1"]: Refreshing state... [id=rtbassoc-05b9996ed07c32c0b]
      aws_route_table_association.public_route_association["public_subnet_2"]: Refreshing state... [id=rtbassoc-0d2b8cfe4bbeca120]
      aws_route_table_association.public_route_association["public_subnet_3"]: Refreshing state... [id=rtbassoc-0559acceae8399889]
      aws_route_table.private_route_table: Refreshing state... [id=rtb-048269028f20e1f66]
      aws_route_table_association.private_route_association["private_subnet_1"]: Refreshing state... [id=rtbassoc-0cc5c3ed04a45a6d9]
      aws_route_table_association.private_route_association["private_subnet_2"]: Refreshing state... [id=rtbassoc-01395243679e7bec7]
      aws_route_table_association.private_route_association["private_subnet_3"]: Refreshing state... [id=rtbassoc-03c17fe71fa821363]

      Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        ~ update in-place

      Terraform will perform the following actions:

        # aws_instance.web_server will be updated in-place
        ~ resource "aws_instance" "web_server" {
              id                                   = "i-00cd814c77bc90e39"
            ~ tags                                 = {
                  "App"   = "corp_api"
                  "Name"  = "ec2-dev-api-us-west-2a"
                ~ "Owner" = "api_Mgmt_dev" -> "api_mgmt_dev"
              }
            ~ tags_all                             = {
                ~ "Owner" = "api_Mgmt_dev" -> "api_mgmt_dev"
                  # (2 unchanged elements hidden)
              }
              # (29 unchanged attributes hidden)

              # (8 unchanged blocks hidden)
          }

      Plan: 0 to add, 1 to change, 0 to destroy.

      ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

      Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
  
      # now we can run the command as terraform apply -auto-approve to deploy the infrastructure changes 
      # here also we can see the below output
      data.aws_availability_zones.available: Reading...
      aws_vpc.vpc: Refreshing state... [id=vpc-0b6be4ad9e44ffd06]
      aws_eip.nat_gateway_eip: Refreshing state... [id=eipalloc-0433906e535a5f6a9]
      data.aws_ami.ubuntu: Reading...
      data.aws_availability_zones.available: Read complete after 1s [id=us-west-2]
      data.aws_ami.ubuntu: Read complete after 2s [id=ami-079167f081a690d5a]
      aws_internet_gateway.public_internet_gateway: Refreshing state... [id=igw-0d0fd536cf6f9fb61]
      aws_subnet.private_subnets["private_subnet_1"]: Refreshing state... [id=subnet-02137d856e67a6b3a]
      aws_subnet.private_subnets["private_subnet_2"]: Refreshing state... [id=subnet-0d2f7a92901e1b7ce]
      aws_subnet.public_subnet["public_subnet_3"]: Refreshing state... [id=subnet-05a96b9e9af891eb5]
      aws_subnet.public_subnet["public_subnet_1"]: Refreshing state... [id=subnet-0154904dc42709956]
      aws_subnet.private_subnets["private_subnet_3"]: Refreshing state... [id=subnet-0878ed4aed8d38a7c]
      aws_subnet.public_subnet["public_subnet_2"]: Refreshing state... [id=subnet-0d14bb19411f30ba0]
      aws_nat_gateway.private_nat_gateway: Refreshing state... [id=nat-0e7652856beebe065]
      aws_route_table.public_route_table: Refreshing state... [id=rtb-01c4c98895e272adf]
      aws_instance.web_server: Refreshing state... [id=i-00cd814c77bc90e39]
      aws_route_table.private_route_table: Refreshing state... [id=rtb-048269028f20e1f66]
      aws_route_table_association.public_route_association["public_subnet_2"]: Refreshing state... [id=rtbassoc-0d2b8cfe4bbeca120]
      aws_route_table_association.public_route_association["public_subnet_3"]: Refreshing state... [id=rtbassoc-0559acceae8399889]
      aws_route_table_association.public_route_association["public_subnet_1"]: Refreshing state... [id=rtbassoc-05b9996ed07c32c0b]
      aws_route_table_association.private_route_association["private_subnet_2"]: Refreshing state... [id=rtbassoc-01395243679e7bec7]
      aws_route_table_association.private_route_association["private_subnet_3"]: Refreshing state... [id=rtbassoc-03c17fe71fa821363]
      aws_route_table_association.private_route_association["private_subnet_1"]: Refreshing state... [id=rtbassoc-0cc5c3ed04a45a6d9]

      Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        ~ update in-place

      Terraform will perform the following actions:

        # aws_instance.web_server will be updated in-place
        ~ resource "aws_instance" "web_server" {
              id                                   = "i-00cd814c77bc90e39"
            ~ tags                                 = {
                  "App"   = "corp_api"
                  "Name"  = "ec2-dev-api-us-west-2a"
                ~ "Owner" = "api_Mgmt_dev" -> "api_mgmt_dev"
              }
            ~ tags_all                             = {
                ~ "Owner" = "api_Mgmt_dev" -> "api_mgmt_dev"
                  # (2 unchanged elements hidden)
              }
              # (29 unchanged attributes hidden)

              # (8 unchanged blocks hidden)
          }

      Plan: 0 to add, 1 to change, 0 to destroy.
      aws_instance.web_server: Modifying... [id=i-00cd814c77bc90e39]
      aws_instance.web_server: Modifications complete after 4s [id=i-00cd814c77bc90e39]

      Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
        
  ```
