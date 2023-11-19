# Lab : Debugging Terraform

- we are using the `code` to provision the `terraform infrastructure` using `Terraform` , as with `any code` there might be `bugs or problem` that we might run into

- terraform help us in `debugging the code` as well as the `some of the workflow that been created using the code to provision infrastructure` 

- we can use the `different logging techniques` that can be used within the `terraform`

- some of the `logging techinques` might vary based on the `env` we are trying to logging in  the `service`

- we can `set log on` the `terraform` using the `environment variable` as `TF_LOG` below 
  
  - for linux we can set the env variable of TF_LOG as `export TF_LOG=TRACE`
  
  - for powershell foe windows command can set the env variable using the command as `$env:TF_LOG="TRACE"`

-  we can set the `TF_LOG` `env variable top different log level as below` 

    - `TRACE`
    
    - `DEBUG`
    
    - `INFO`
    
    - `WARN`
    
    - `ERROR`

- you can set TF_LOG to one of the log levels TRACE, DEBUG, INFO, WARN or ERROR to change the verbosity of the logs, with TRACE being the most verbose.

- we can use the `terraform apply` after enabling the `Terraform Debug` as below 

    ```bash
        export TF_LOG=TRACE # enabling the Terraform log to TRACE which is the most verbose oprion
        terraform apply -auto-approve
        # whichh will depploy the infrastructure to the Required platform
        # here we will get the output in this case as below 
        aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table.private_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_route_table_association.private_route_association["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_route_table_association.private_route_association["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_route_table_association.private_route_association["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table.public_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_route_table_association.public_route_association["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_route_table_association.public_route_association["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_route_table_association.public_route_association["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_security_group.ingress-ssh - *terraform.NodeApplyableResourceInstance
            aws_security_group.ingress-ssh (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_security_group.ingress-ssh (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_security_group.vpc-ping - *terraform.NodeApplyableResourceInstance
            aws_security_group.vpc-ping (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_security_group.vpc-ping (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_security_group.vpc-web - *terraform.NodeApplyableResourceInstance
            aws_security_group.vpc-web (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_security_group.vpc-web (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.private_subnets - *terraform.NodeRootVariable
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_subnet.private_subnet["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.private_subnets - *terraform.NodeRootVariable
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_subnet.private_subnet["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.private_subnets - *terraform.NodeRootVariable
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_subnet.private_subnet["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.private_subnets - *terraform.NodeRootVariable
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.public_subnets - *terraform.NodeRootVariable
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.public_subnets - *terraform.NodeRootVariable
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.public_subnets - *terraform.NodeRootVariable
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.public_subnets - *terraform.NodeRootVariable
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.vpc_cidr - *terraform.NodeRootVariable
        aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.vpc_cidr - *terraform.NodeRootVariable
        data.aws_ami.ubuntu (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        local_file.private_key_pem - *terraform.NodeApplyableResourceInstance
            local_file.private_key_pem (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/local"] - *terraform.NodeApplyableProvider
            tls_private_key.generated - *terraform.NodeApplyableResourceInstance
            tls_private_key.generated (expand) - *terraform.nodeExpandApplyableResource
        local_file.private_key_pem (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/local"] - *terraform.NodeApplyableProvider
            tls_private_key.generated - *terraform.NodeApplyableResourceInstance
            tls_private_key.generated (expand) - *terraform.nodeExpandApplyableResource
        provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
            aws_eip.nat_gateway_eip - *terraform.NodeApplyableResourceInstance
            aws_eip.nat_gateway_eip (expand) - *terraform.nodeExpandApplyableResource
            aws_instance.web_server - *terraform.NodeApplyableResourceInstance
            aws_instance.web_server (expand) - *terraform.nodeExpandApplyableResource
            aws_internet_gateway.demote_igw - *terraform.NodeApplyableResourceInstance
            aws_internet_gateway.demote_igw (expand) - *terraform.nodeExpandApplyableResource
            aws_key_pair.generated - *terraform.NodeApplyableResourceInstance
            aws_key_pair.generated (expand) - *terraform.nodeExpandApplyableResource
            aws_nat_gateway.nat_gateway - *terraform.NodeApplyableResourceInstance
            aws_nat_gateway.nat_gateway (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table.private_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table.public_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.private_route_association["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.private_route_association["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.private_route_association["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table_association.public_route_association["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_security_group.ingress-ssh - *terraform.NodeApplyableResourceInstance
            aws_security_group.ingress-ssh (expand) - *terraform.nodeExpandApplyableResource
            aws_security_group.vpc-ping - *terraform.NodeApplyableResourceInstance
            aws_security_group.vpc-ping (expand) - *terraform.nodeExpandApplyableResource
            aws_security_group.vpc-web - *terraform.NodeApplyableResourceInstance
            aws_security_group.vpc-web (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.private_subnet["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            data.aws_ami.ubuntu (expand) - *terraform.nodeExpandApplyableResource
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        provider["registry.terraform.io/hashicorp/local"] - *terraform.NodeApplyableProvider
        provider["registry.terraform.io/hashicorp/local"] (close) - *terraform.graphNodeCloseProvider
            local_file.private_key_pem - *terraform.NodeApplyableResourceInstance
            local_file.private_key_pem (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/local"] - *terraform.NodeApplyableProvider
        provider["registry.terraform.io/hashicorp/tls"] - *terraform.NodeApplyableProvider
        provider["registry.terraform.io/hashicorp/tls"] (close) - *terraform.graphNodeCloseProvider
            provider["registry.terraform.io/hashicorp/tls"] - *terraform.NodeApplyableProvider
            tls_private_key.generated - *terraform.NodeApplyableResourceInstance
            tls_private_key.generated (expand) - *terraform.nodeExpandApplyableResource
        root - *terraform.nodeCloseModule
            provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
            provider["registry.terraform.io/hashicorp/local"] (close) - *terraform.graphNodeCloseProvider
            provider["registry.terraform.io/hashicorp/tls"] (close) - *terraform.graphNodeCloseProvider
            var.aws_region - *terraform.NodeRootVariable
            var.vpc_name - *terraform.NodeRootVariable
        tls_private_key.generated - *terraform.NodeApplyableResourceInstance
            provider["registry.terraform.io/hashicorp/tls"] - *terraform.NodeApplyableProvider
            tls_private_key.generated (expand) - *terraform.nodeExpandApplyableResource
        tls_private_key.generated (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/tls"] - *terraform.NodeApplyableProvider
        var.aws_region - *terraform.NodeRootVariable
        var.private_subnets - *terraform.NodeRootVariable
        var.public_subnets - *terraform.NodeRootVariable
        var.vpc_cidr - *terraform.NodeRootVariable
        var.vpc_name - *terraform.NodeRootVariable
        ------
        2023-11-19T21:20:37.083+0530 [TRACE] Executing graph transform *terraform.TransitiveReductionTransformer
        2023-11-19T21:20:37.084+0530 [TRACE] Completed graph transform *terraform.TransitiveReductionTransformer with new graph:
        aws_eip.nat_gateway_eip - *terraform.NodeApplyableResourceInstance
            aws_eip.nat_gateway_eip (expand) - *terraform.nodeExpandApplyableResource
        aws_eip.nat_gateway_eip (expand) - *terraform.nodeExpandApplyableResource
            aws_internet_gateway.demote_igw - *terraform.NodeApplyableResourceInstance
        aws_instance.web_server - *terraform.NodeApplyableResourceInstance
            aws_instance.web_server (expand) - *terraform.nodeExpandApplyableResource
        aws_instance.web_server (expand) - *terraform.nodeExpandApplyableResource
            aws_key_pair.generated - *terraform.NodeApplyableResourceInstance
            aws_security_group.ingress-ssh - *terraform.NodeApplyableResourceInstance
            aws_security_group.vpc-ping - *terraform.NodeApplyableResourceInstance
            aws_security_group.vpc-web - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            data.aws_ami.ubuntu (expand) - *terraform.nodeExpandApplyableResource
            local_file.private_key_pem - *terraform.NodeApplyableResourceInstance
        aws_internet_gateway.demote_igw - *terraform.NodeApplyableResourceInstance
            aws_internet_gateway.demote_igw (expand) - *terraform.nodeExpandApplyableResource
        aws_internet_gateway.demote_igw (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
        aws_key_pair.generated - *terraform.NodeApplyableResourceInstance
            aws_key_pair.generated (expand) - *terraform.nodeExpandApplyableResource
        aws_key_pair.generated (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            tls_private_key.generated - *terraform.NodeApplyableResourceInstance
        aws_nat_gateway.nat_gateway - *terraform.NodeApplyableResourceInstance
            aws_nat_gateway.nat_gateway (expand) - *terraform.nodeExpandApplyableResource
        aws_nat_gateway.nat_gateway (expand) - *terraform.nodeExpandApplyableResource
            aws_eip.nat_gateway_eip - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
        aws_route_table.private_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.private_route_table (expand) - *terraform.nodeExpandApplyableResource
        aws_route_table.private_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_nat_gateway.nat_gateway - *terraform.NodeApplyableResourceInstance
        aws_route_table.public_route_table - *terraform.NodeApplyableResourceInstance
            aws_route_table.public_route_table (expand) - *terraform.nodeExpandApplyableResource
        aws_route_table.public_route_table (expand) - *terraform.nodeExpandApplyableResource
            aws_internet_gateway.demote_igw - *terraform.NodeApplyableResourceInstance
        aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table.private_route_table - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
        aws_route_table_association.private_route_association["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
        aws_route_table_association.private_route_association["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
        aws_route_table_association.private_route_association["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.private_route_association (expand) - *terraform.nodeExpandApplyableResource
        aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
            aws_route_table.public_route_table - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
        aws_route_table_association.public_route_association["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
        aws_route_table_association.public_route_association["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
        aws_route_table_association.public_route_association["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association (expand) - *terraform.nodeExpandApplyableResource
        aws_security_group.ingress-ssh - *terraform.NodeApplyableResourceInstance
            aws_security_group.ingress-ssh (expand) - *terraform.nodeExpandApplyableResource
        aws_security_group.ingress-ssh (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
        aws_security_group.vpc-ping - *terraform.NodeApplyableResourceInstance
            aws_security_group.vpc-ping (expand) - *terraform.nodeExpandApplyableResource
        aws_security_group.vpc-ping (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
        aws_security_group.vpc-web - *terraform.NodeApplyableResourceInstance
            aws_security_group.vpc-web (expand) - *terraform.nodeExpandApplyableResource
        aws_security_group.vpc-web (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
        aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            var.private_subnets - *terraform.NodeRootVariable
        aws_subnet.private_subnet["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
        aws_subnet.private_subnet["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
        aws_subnet.private_subnet["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.private_subnet (expand) - *terraform.nodeExpandApplyableResource
        aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
            aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            var.public_subnets - *terraform.NodeRootVariable
        aws_subnet.public_subnet["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
        aws_subnet.public_subnet["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
        aws_subnet.public_subnet["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_subnet.public_subnet (expand) - *terraform.nodeExpandApplyableResource
        aws_vpc.vpc - *terraform.NodeApplyableResourceInstance
            aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
        aws_vpc.vpc (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
            var.vpc_cidr - *terraform.NodeRootVariable
        data.aws_ami.ubuntu (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        data.aws_availability_zones.available (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        local_file.private_key_pem - *terraform.NodeApplyableResourceInstance
            local_file.private_key_pem (expand) - *terraform.nodeExpandApplyableResource
        local_file.private_key_pem (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/local"] - *terraform.NodeApplyableProvider
            tls_private_key.generated - *terraform.NodeApplyableResourceInstance
        provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
        provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
            aws_instance.web_server - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.private_route_association["private_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.private_route_association["private_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.private_route_association["private_subnet_3"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association["public_subnet_1"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association["public_subnet_2"] - *terraform.NodeApplyableResourceInstance
            aws_route_table_association.public_route_association["public_subnet_3"] - *terraform.NodeApplyableResourceInstance
        provider["registry.terraform.io/hashicorp/local"] - *terraform.NodeApplyableProvider
        provider["registry.terraform.io/hashicorp/local"] (close) - *terraform.graphNodeCloseProvider
            local_file.private_key_pem - *terraform.NodeApplyableResourceInstance
        provider["registry.terraform.io/hashicorp/tls"] - *terraform.NodeApplyableProvider
        provider["registry.terraform.io/hashicorp/tls"] (close) - *terraform.graphNodeCloseProvider
            tls_private_key.generated - *terraform.NodeApplyableResourceInstance
        root - *terraform.nodeCloseModule
            provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
            provider["registry.terraform.io/hashicorp/local"] (close) - *terraform.graphNodeCloseProvider
            provider["registry.terraform.io/hashicorp/tls"] (close) - *terraform.graphNodeCloseProvider
            var.aws_region - *terraform.NodeRootVariable
            var.vpc_name - *terraform.NodeRootVariable
        tls_private_key.generated - *terraform.NodeApplyableResourceInstance
            tls_private_key.generated (expand) - *terraform.nodeExpandApplyableResource
        tls_private_key.generated (expand) - *terraform.nodeExpandApplyableResource
            provider["registry.terraform.io/hashicorp/tls"] - *terraform.NodeApplyableProvider
        var.aws_region - *terraform.NodeRootVariable
        var.private_subnets - *terraform.NodeRootVariable
        var.public_subnets - *terraform.NodeRootVariable
        var.vpc_cidr - *terraform.NodeRootVariable
        var.vpc_name - *terraform.NodeRootVariable
        ------

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
        2023-11-19T21:20:37.173+0530 [DEBUG] command: asking for input: "\nDo you want to perform these actions?"

        Do you want to perform these actions?
        Terraform will perform the actions described above.
        Only 'yes' will be accepted to approve.

        Enter a value: 
    

    ```

- when we apply the `Terraform configuration` using the command as `terraform apply` then it will
  
  - read the `current terraform configuration` 
  -  compare it with the `preveious terraform state`
  -  compare it the `Environment` we are applying the `terraform apply command`

- when the `resource` need to be provisioned then `Terraform perform the HTTP API call` to the `remote backend API`

- it will also then see the `terraform privder info along with version` along with the `version that been created with it`

- we can see for example `EC2 info` and we can see that it provide the `Attribute Info`in that case 

- we can also see the `playload info` that we got from the `REST API` that we have created 

- we can also see the `debug info` as well when we perform the `terraform init` command in that case 

    ```bash
        export TF_LOG=TRACE # SETTING THE LOG LEVEL TO TRACE IN THIS CASE
        terraform init # using the terraform init to download and use the terraform provider in this case 
        # we can see the below output in that case
        2023-11-19T21:29:39.129+0530 [INFO]  Terraform version: 1.6.4 dev
        2023-11-19T21:29:39.129+0530 [DEBUG] using github.com/hashicorp/go-tfe v1.36.0
        2023-11-19T21:29:39.129+0530 [DEBUG] using github.com/hashicorp/hcl/v2 v2.19.1
        2023-11-19T21:29:39.129+0530 [DEBUG] using github.com/hashicorp/terraform-svchost v0.1.1
        2023-11-19T21:29:39.129+0530 [DEBUG] using github.com/zclconf/go-cty v1.14.1
        2023-11-19T21:29:39.129+0530 [INFO]  Go runtime version: go1.21.4
        2023-11-19T21:29:39.129+0530 [INFO]  CLI args: []string{"/snap/terraform/574/terraform", "init"}
        2023-11-19T21:29:39.129+0530 [TRACE] Stdout is a terminal of width 212
        2023-11-19T21:29:39.129+0530 [TRACE] Stderr is a terminal of width 212
        2023-11-19T21:29:39.129+0530 [TRACE] Stdin is a terminal
        2023-11-19T21:29:39.129+0530 [DEBUG] Attempting to open CLI config file: /home/pratik/.terraformrc
        2023-11-19T21:29:39.130+0530 [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /home/pratik/.terraform.d/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /home/pratik/.local/share/terraform/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /home/pratik/snap/code/146/.local/share/terraform/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /home/pratik/snap/code/146/terraform/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /snap/code/146/usr/share/terraform/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /usr/share/ubuntu/terraform/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /usr/local/share/terraform/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /usr/share/terraform/plugins
        2023-11-19T21:29:39.130+0530 [DEBUG] ignoring non-existing provider search directory /var/lib/snapd/desktop/terraform/plugins
        2023-11-19T21:29:39.130+0530 [INFO]  CLI command args: []string{"init"}

        Initializing the backend...
        2023-11-19T21:29:39.132+0530 [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
        2023-11-19T21:29:39.132+0530 [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
        2023-11-19T21:29:39.132+0530 [DEBUG] New state was assigned lineage "46221fe5-6a11-7058-9433-ace0679e12f8"
        2023-11-19T21:29:39.132+0530 [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
        2023-11-19T21:29:39.132+0530 [TRACE] Meta.Backend: instantiated backend of type <nil>
        2023-11-19T21:29:39.133+0530 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
        2023-11-19T21:29:39.133+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v5.23.1 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/aws/5.23.1/linux_amd64
        2023-11-19T21:29:39.134+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/http v3.4.0 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/http/3.4.0/linux_amd64
        2023-11-19T21:29:39.134+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/local v2.4.0 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64
        2023-11-19T21:29:39.134+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/random v3.5.1 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/random/3.5.1/linux_amd64
        2023-11-19T21:29:39.134+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/tls v4.0.4 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64
        2023-11-19T21:29:39.134+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/local 2.4.0
        2023-11-19T21:29:39.134+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/random/3.5.1/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/random 3.5.1
        2023-11-19T21:29:39.134+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/tls 4.0.4
        2023-11-19T21:29:39.134+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/5.23.1/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 5.23.1
        2023-11-19T21:29:39.134+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/http/3.4.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/http 3.4.0
        2023-11-19T21:29:39.146+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:29:39.159+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:29:39.171+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:29:39.517+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:29:39.529+0530 [DEBUG] checking for provisioner in "."
        2023-11-19T21:29:39.529+0530 [DEBUG] checking for provisioner in "/snap/terraform/574"
        2023-11-19T21:29:39.529+0530 [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
        2023-11-19T21:29:39.529+0530 [TRACE] backend/local: state manager for workspace "default" will:
        - read initial snapshot from terraform.tfstate
        - write new snapshots to terraform.tfstate
        - create any backup at terraform.tfstate.backup
        2023-11-19T21:29:39.529+0530 [TRACE] statemgr.Filesystem: reading initial snapshot from terraform.tfstate
        2023-11-19T21:29:39.529+0530 [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but thats okay
        2023-11-19T21:29:39.529+0530 [TRACE] statemgr.Filesystem: read nil snapshot

        Initializing provider plugins...
        - Reusing previous version of hashicorp/random from the dependency lock file
        2023-11-19T21:29:39.533+0530 [DEBUG] Service discovery for registry.terraform.io at https://registry.terraform.io/.well-known/terraform.json
        2023-11-19T21:29:39.533+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/.well-known/terraform.json
        2023-11-19T21:29:39.698+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/random/versions
        2023-11-19T21:29:39.698+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/random/versions
        - Reusing previous version of hashicorp/local from the dependency lock file
        2023-11-19T21:29:39.857+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/local/versions
        2023-11-19T21:29:39.857+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/local/versions
        - Reusing previous version of hashicorp/tls from the dependency lock file
        2023-11-19T21:29:40.007+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/tls/versions
        2023-11-19T21:29:40.007+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/tls/versions
        - Reusing previous version of hashicorp/aws from the dependency lock file
        2023-11-19T21:29:40.164+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/versions
        2023-11-19T21:29:40.164+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/aws/versions
        - Reusing previous version of hashicorp/http from the dependency lock file
        2023-11-19T21:29:40.303+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/http/versions
        2023-11-19T21:29:40.303+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/http/versions
        2023-11-19T21:29:40.434+0530 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
        2023-11-19T21:29:40.434+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v5.23.1 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/aws/5.23.1/linux_amd64
        2023-11-19T21:29:40.435+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/http v3.4.0 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/http/3.4.0/linux_amd64
        2023-11-19T21:29:40.435+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/local v2.4.0 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64
        2023-11-19T21:29:40.435+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/random v3.5.1 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/random/3.5.1/linux_amd64
        2023-11-19T21:29:40.435+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/tls v4.0.4 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64
        2023-11-19T21:29:40.435+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/random/3.5.1/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/random 3.5.1
        2023-11-19T21:29:40.435+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/tls 4.0.4
        2023-11-19T21:29:40.435+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/5.23.1/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 5.23.1
        2023-11-19T21:29:40.435+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/http/3.4.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/http 3.4.0
        2023-11-19T21:29:40.435+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/local 2.4.0
        - Using previously-installed hashicorp/random v3.5.1
        2023-11-19T21:29:40.449+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        - Using previously-installed hashicorp/local v2.4.0
        2023-11-19T21:29:40.463+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        - Using previously-installed hashicorp/tls v4.0.4
        2023-11-19T21:29:40.478+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        - Using previously-installed hashicorp/aws v5.23.1
        2023-11-19T21:29:40.819+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        - Using previously-installed hashicorp/http v3.4.0

        Terraform has been successfully initialized!

        You may now begin working with Terraform. Try running "terraform plan" to see
        any changes that are required for your infrastructure. All Terraform commands
        should now work.

        If you ever set or change modules or backend configuration for Terraform,
        rerun this command to reinitialize your working directory. If you forget, other
        commands will detect it and remind you to do so if necessary.
    
    
    ```

- it is showing the `current version of terraform that being used`

- as `Terraform` written using the `go language run time` , hence showing the `go version runtime` for the same

- we cam also see the `.terraformrc` which will be inside the `usr/<username>/.terraformrc` which will help in `authenticate attempt` that need to made with `terraform` also check whether `local or remote plugin` in this case 

- we can also see the `plugins` which will provide the `detail about the plugin` 

- if a `new provider` being mentioned hence it will going to `download and install the provider` , if not `it will check the provider that being used`

- we can see the `registry info` from where the `registry.terrafgorm.io` which is the `public terraform cloud registry`

- when we set the `log level` as `TRACE` we can see info about the `INFO/DEBUG/WARN/ERROR` etc as well , as it is the `most verbose option i.e TRACE`


- if we want to `log info` to `file` then we can set it as env variable as well using the info as below 
  
  - for `linux` we can set it as `export TF_LOG_PATH="terraform_log.txt"`
  
  - for `powershell` or `windows` we can use it as below `$env:TF_LOG_PATH="terraform_log.txt"`  

    ```bash
        export TF_LOG_PATH="terraform_log.txt"
        # setting the LOG file for the terraform log
        # now when we perform the terraform command these logfile will be created in the terraform workplace
        terraform init -upgrade # performing the terraform command to download and use the terraform provider
        # below will be output to the console AND terraform_log.txt will be created
        Initializing the backend...

        Initializing provider plugins...
        - Finding hashicorp/random versions matching "3.5.1"...
        - Finding hashicorp/local versions matching "2.4.0"...
        - Finding hashicorp/tls versions matching "4.0.4"...
        - Finding hashicorp/aws versions matching "5.23.1"...
        - Finding hashicorp/http versions matching "3.4.0"...
        - Using previously-installed hashicorp/aws v5.23.1
        - Using previously-installed hashicorp/http v3.4.0
        - Using previously-installed hashicorp/random v3.5.1
        - Using previously-installed hashicorp/local v2.4.0
        - Using previously-installed hashicorp/tls v4.0.4

        Terraform has been successfully initialized!

        You may now begin working with Terraform. Try running "terraform plan" to see
        any changes that are required for your infrastructure. All Terraform commands
        should now work.

        If you ever set or change modules or backend configuration for Terraform,
        rerun this command to reinitialize your working directory. If you forget, other
        commands will detect it and remind you to do so if necessary.
    

    ```

- we can also see the `terraform log file` as below 

    ```text
        terraform_log.txt
        =================
        2023-11-19T21:39:34.372+0530 [INFO]  Terraform version: 1.6.4 dev
        2023-11-19T21:39:34.372+0530 [DEBUG] using github.com/hashicorp/go-tfe v1.36.0
        2023-11-19T21:39:34.372+0530 [DEBUG] using github.com/hashicorp/hcl/v2 v2.19.1
        2023-11-19T21:39:34.372+0530 [DEBUG] using github.com/hashicorp/terraform-svchost v0.1.1
        2023-11-19T21:39:34.372+0530 [DEBUG] using github.com/zclconf/go-cty v1.14.1
        2023-11-19T21:39:34.372+0530 [INFO]  Go runtime version: go1.21.4
        2023-11-19T21:39:34.372+0530 [INFO]  CLI args: []string{"/snap/terraform/574/terraform", "init", "-upgrade"}
        2023-11-19T21:39:34.372+0530 [TRACE] Stdout is a terminal of width 212
        2023-11-19T21:39:34.372+0530 [TRACE] Stderr is a terminal of width 212
        2023-11-19T21:39:34.372+0530 [TRACE] Stdin is a terminal
        2023-11-19T21:39:34.372+0530 [DEBUG] Attempting to open CLI config file: /home/pratik/.terraformrc
        2023-11-19T21:39:34.372+0530 [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /home/pratik/.terraform.d/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /home/pratik/.local/share/terraform/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /home/pratik/snap/code/146/.local/share/terraform/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /home/pratik/snap/code/146/terraform/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /snap/code/146/usr/share/terraform/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /usr/share/ubuntu/terraform/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /usr/local/share/terraform/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /usr/share/terraform/plugins
        2023-11-19T21:39:34.372+0530 [DEBUG] ignoring non-existing provider search directory /var/lib/snapd/desktop/terraform/plugins
        2023-11-19T21:39:34.372+0530 [INFO]  CLI command args: []string{"init", "-upgrade"}
        2023-11-19T21:39:34.377+0530 [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
        2023-11-19T21:39:34.377+0530 [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
        2023-11-19T21:39:34.377+0530 [DEBUG] New state was assigned lineage "208f5031-6ba3-af14-fe44-40ec23b02974"
        2023-11-19T21:39:34.377+0530 [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
        2023-11-19T21:39:34.377+0530 [TRACE] Meta.Backend: instantiated backend of type <nil>
        2023-11-19T21:39:34.378+0530 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
        2023-11-19T21:39:34.378+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v5.23.1 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/aws/5.23.1/linux_amd64
        2023-11-19T21:39:34.378+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/http v3.4.0 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/http/3.4.0/linux_amd64
        2023-11-19T21:39:34.378+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/local v2.4.0 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64
        2023-11-19T21:39:34.378+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/random v3.5.1 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/random/3.5.1/linux_amd64
        2023-11-19T21:39:34.378+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/tls v4.0.4 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64
        2023-11-19T21:39:34.378+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/5.23.1/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 5.23.1
        2023-11-19T21:39:34.378+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/http/3.4.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/http 3.4.0
        2023-11-19T21:39:34.378+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/local 2.4.0
        2023-11-19T21:39:34.378+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/random/3.5.1/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/random 3.5.1
        2023-11-19T21:39:34.378+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/tls 4.0.4
        2023-11-19T21:39:34.390+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:39:34.404+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:39:34.419+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:39:34.768+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:39:34.783+0530 [DEBUG] checking for provisioner in "."
        2023-11-19T21:39:34.783+0530 [DEBUG] checking for provisioner in "/snap/terraform/574"
        2023-11-19T21:39:34.783+0530 [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
        2023-11-19T21:39:34.783+0530 [TRACE] backend/local: state manager for workspace "default" will:
        - read initial snapshot from terraform.tfstate
        - write new snapshots to terraform.tfstate
        - create any backup at terraform.tfstate.backup
        2023-11-19T21:39:34.783+0530 [TRACE] statemgr.Filesystem: reading initial snapshot from terraform.tfstate
        2023-11-19T21:39:34.783+0530 [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but that's okay
        2023-11-19T21:39:34.783+0530 [TRACE] statemgr.Filesystem: read nil snapshot
        2023-11-19T21:39:34.785+0530 [DEBUG] Service discovery for registry.terraform.io at https://registry.terraform.io/.well-known/terraform.json
        2023-11-19T21:39:34.785+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/.well-known/terraform.json
        2023-11-19T21:39:34.930+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/random/versions
        2023-11-19T21:39:34.930+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/random/versions
        2023-11-19T21:39:35.061+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/local/versions
        2023-11-19T21:39:35.061+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/local/versions
        2023-11-19T21:39:35.187+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/tls/versions
        2023-11-19T21:39:35.187+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/tls/versions
        2023-11-19T21:39:35.318+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/versions
        2023-11-19T21:39:35.318+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/aws/versions
        2023-11-19T21:39:35.466+0530 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/http/versions
        2023-11-19T21:39:35.466+0530 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/http/versions
        2023-11-19T21:39:35.598+0530 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
        2023-11-19T21:39:35.598+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v5.23.1 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/aws/5.23.1/linux_amd64
        2023-11-19T21:39:35.598+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/http v3.4.0 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/http/3.4.0/linux_amd64
        2023-11-19T21:39:35.599+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/local v2.4.0 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64
        2023-11-19T21:39:35.599+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/random v3.5.1 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/random/3.5.1/linux_amd64
        2023-11-19T21:39:35.599+0530 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/tls v4.0.4 for linux_amd64 at .terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64
        2023-11-19T21:39:35.599+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/tls 4.0.4
        2023-11-19T21:39:35.599+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/5.23.1/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 5.23.1
        2023-11-19T21:39:35.599+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/http/3.4.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/http 3.4.0
        2023-11-19T21:39:35.599+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/local 2.4.0
        2023-11-19T21:39:35.599+0530 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/random/3.5.1/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/random 3.5.1
        2023-11-19T21:39:35.942+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:39:35.954+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:39:35.969+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers
        2023-11-19T21:39:35.982+0530 [TRACE] providercache.fillMetaCache: using cached result from previous scan of .terraform/providers

    
    ```

- we can also `disable the Terraform log` using the `same env variable and set to empty string as below`

- we can disable using the command as below for both the `TF_LOG` and `TF_LOG_PATH` env variable to dissabling the logging into the console and file as below 

- we can see the output in this case as below 

    ```bash
        export TF_LOG=""
        # disabling the Terraform console log 
        export TF_LOG_PATH= ""
        # disabling the Terraform LOG path in this case 
    
    ```

- nwe can define the same in the `windows platform` as below 

    ```powershell
        $env:TF_LOG=""
        # disabling the Terraform console log 
        $env:TF_LOG_PATH=""
        # disabling the Terraform LOG path in this case 
    
    ```