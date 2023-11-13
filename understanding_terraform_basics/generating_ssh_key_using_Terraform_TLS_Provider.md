# Generating SSH Key using Terraform TLS Provider

- here in this Lab we will be using the `terraform TLS provider` in order to create `ssh key`

- `Terraform` can have `one to many Terraform provider` with its `plugable architeture` , we can add a `new provider` into the `Terraform configuration block`

- here we will be adding the `Terraform TLS povider` to create the `new ssh key` , which we will use in future , hence will be the foundation for `upcoming lab`

- when we perform the `terraform version` which will show below things
  
  - `Terraform core version` 
  
  - `Terraform providers that being installed`   

- we can use the command as below in this case 

    ```bash
        terraform version # checking terraform version in this case over here
        Terraform v1.6.3-dev
        on linux_amd64
        + provider registry.terraform.io/hashicorp/tls v4.0.4

        Your version of Terraform is out of date! The latest version
        is 1.6.3. You can update by downloading from https://www.terraform.io/downloads.html
            
    ```

- we can install the `terraform tls provider` by going into `registry.terraform.io` &rarr; `search for the provider as tls` ; &rarr; `which will redirect to the page as` [TLS provider](https://registry.terraform.io/providers/hashicorp/tls/latest/)

- we can add that to the `terraform.tf` underneath the `required_providers` section  as below 

    ```tf
        terraform.tf
        ============

        terraform {
            required_version = ">1.0.0" # defining the terraform version that being required
            required_providers { # defining all the Terraform providers required for the terraform configuration
                tls = { # using the tls module in this case
                    source = "hashicorp/tls" # here we are using the source as the hashicorp provider registry
                    version = "!>4.0.0" # here defining to use the version as the 4.0.0 in this case
                }
            }
        }
    
    ```

- now we can `install` that using the `terraform init` command in this case below command

    ```bash
        terraform init
        # defining the terraform version this case over here
        Initializing the backend...
        Initializing provider plugins...
        - Reusing previous version of hashicorp/tls from the dependency lock file
        - Using previously-installed hashicorp/tls v4.0.4

        Terraform has been successfully initialized!

        You may now begin working with Terraform. Try running "terraform plan" to see
        any changes that are required for your infrastructure. All Terraform commands
        should now work.

        If you ever set or change modules or backend configuration for Terraform,
        rerun this command to reinitialize your working directory. If you forget, other
        commands will detect it and remind you to do so if necessary.
    

    ```

- once after  the `provider being installed` we can validate the same using the command as `terraform version` which will show both the `Terraform core version` as well as the `Terraform provider version`

- we can see the output as below in this case 

    ```bash
        terraform version 
        # which will show  all the installed providers as well the erraform core version in this case over here
        Terraform v1.6.3-dev
        on linux_amd64
        + provider registry.terraform.io/hashicorp/tls v4.0.4 # here we can see the Terraform TLS provider being installed 

        Your version of Terraform is out of date! The latest version
        is 1.6.3. You can update by downloading from https://www.terraform.io/downloads.html
    
    ```

- we can now add the `resource block` onto the `terraform configuration` in order to create the `ssh key` using the `Terraform TLS provider`

- we can define that as below 

    ```tf
        main.tf
        =======

        resource "tls_private_key" "generated" { # using the tls_private_key module with the name as generated
            
            algorithm = "RSA" # defining the algorithm as RSA in this case out in here 

            rsa_bits =  4096 # defining the number of bits used for RSA is of 4096

        }

        resource "local_file" "private_pem_key" { # using the resource as the local_file which being present in the Terraform local provider with the name as  private_pem_key

            content = tls_private_key.generated.private_key_pem # here defining the content as the private_key_content in this case over here
            # private_key_pem will generate Private key data in PEM (RFC 1421) format. and referencing the reource block in this case 
            filename = "myAmazonSshKey.PEM" # saving this content with the file name as  myAmazonSshKey.PEM

        }
    
    ```

- as here we are using the `Terraform local provider` hence we ned to define that as below 

    ```tf
        terraform.tf
        ============
        terraform {

        required_version = ">1.0.0"

        required_providers {

            tls = {
                source  = "hashicorp/tls"
                version = "4.0.4"
            }

            local = {
                source = "hashicorp/local"
                version = "~>2.4.0"
            }

        }
        }
        
    ```

- now we can install the `multiple Terraform providers` using the command as `terraform init`

- the output in this case will be as below 

    ```bash
        terraform init
        # installing the provider using the terraform init command
        Initializing the backend...

        Initializing provider plugins...
        - Reusing previous version of hashicorp/tls from the dependency lock file
        - Finding hashicorp/local versions matching "~> 2.4.0"...
        - Using previously-installed hashicorp/tls v4.0.4
        - Installing hashicorp/local v2.4.0...
        - Installed hashicorp/local v2.4.0 (signed by HashiCorp)

        Terraform has made some changes to the provider dependency selections recorded
        in the .terraform.lock.hcl file. Review those changes and commit them to your
        version control system if they represent changes you intended to make.

        Terraform has been successfully initialized!

        You may now begin working with Terraform. Try running "terraform plan" to see
        any changes that are required for your infrastructure. All Terraform commands
        should now work.

        If you ever set or change modules or backend configuration for Terraform,
        rerun this command to reinitialize your working directory. If you forget, other
        commands will detect it and remind you to do so if necessary.
    
        # then we can use the terraform version command in order to check the version of Terraform core and provider installed
        terraform version
        Terraform v1.6.3-dev
        on linux_amd64
        + provider registry.terraform.io/hashicorp/local v2.4.0  # here the Terraform local Provider being installed 
        + provider registry.terraform.io/hashicorp/tls v4.0.4 # here the Terraform tls provider being installed

        Your version of Terraform is out of date! The latest version
        is 1.6.3. You can update by downloading from https://www.terraform.io/downloads.html
    

    ```

- now when we ran the `terraform plan` and `teraform apply -auto-approve` in order to show the `execution plan` and `deploy the infrastructure` then we can use it as below 

    ```bash
        terraform plan
        # seeing the execution plan in this case over here
        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

        # local_file.private_pem_key will be created
        + resource "local_file" "private_pem_key" { # this will create the localfile in thsi case 
            + content              = (sensitive value)
            + content_base64sha256 = (known after apply)
            + content_base64sha512 = (known after apply)
            + content_md5          = (known after apply)
            + content_sha1         = (known after apply)
            + content_sha256       = (known after apply)
            + content_sha512       = (known after apply)
            + directory_permission = "0777"
            + file_permission      = "0777"
            + filename             = "myAmazonSshKey.PEM"
            + id                   = (known after apply)
            }

        # tls_private_key.generated will be created
        + resource "tls_private_key" "generated" { # this ill generate the private key as  PEM
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

        Plan: 2 to add, 0 to change, 0 to destroy. # which suggest 2 changes need to nbe made

        ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

        Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
    
        # we can deploy the infrastructure using the command as below
        terraform apply -auto-approve 
        # here this will provide the below output in this case 
        Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
        + create

        Terraform will perform the following actions:

        # local_file.private_pem_key will be created
        + resource "local_file" "private_pem_key" {
            + content              = (sensitive value)
            + content_base64sha256 = (known after apply)
            + content_base64sha512 = (known after apply)
            + content_md5          = (known after apply)
            + content_sha1         = (known after apply)
            + content_sha256       = (known after apply)
            + content_sha512       = (known after apply)
            + directory_permission = "0777"
            + file_permission      = "0777"
            + filename             = "myAmazonSshKey.PEM"
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

        Plan: 2 to add, 0 to change, 0 to destroy.
        tls_private_key.generated: Creating...
        tls_private_key.generated: Creation complete after 1s [id=a9969e5779832798c205c76d04578f7f92acb6fd]
        local_file.private_pem_key: Creating...
        local_file.private_pem_key: Creation complete after 0s [id=619f7bc6c5704d94573ac6ae6b23fe15edf0b755]

        Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    ```

- we can associate the `private Key that got geerated` to the `server instances` for `Authentication`




