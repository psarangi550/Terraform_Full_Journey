# Terraform configuration block

- `Terraform` relies on the `plugin` which is also known as `providers` in order to `interact with the backend remote system` and `expand` the `functionality of the terraform core which is the binary`

- `Terraform configuration` need to declare `which provider to use` inside the `terraform configuration` or `terraform.tf` file so that `terraform` can `go ahead,install and use them`

- we have seen the `terraform.tf` , this lab is `terraform version` inside `specific to terraform configuration block`

- this is going to get performed using the `terraform configuration block`

- **Lab13**
  
  - here we will be `checking` the `terraform version`
  
  - we will tell `terraform` to `run specific version` of the `terraform` before running any `terraqform configuration`
  
  - we can check the `terraform version` as below 

    ```bash
        terraform version
        # this will display the current version of terraform which been used in here
        Terraform v1.6.3-dev
        on linux_amd64

        Your version of Terraform is out of date! The latest version
        is 1.6.3. You can update by downloading from https://www.terraform.io/downloads.html
    ```

  - we can tell `terraform` in order to install the `very specific version of terraform` in the `terraform.tf` file 
  
    ```tf
        terraform.tf
        ============
        terraform { # defining the terraform block in here
            
            required_version = ">=1.0.0"
            # here defining the required version for the terraform in the configuration is greater than 1.0.0 

        }

    ``` 
  
  - if we want to use the `specific terraform` version such as `v1.0.0` then we can define that as below

    ```tf
        terraform.tf
        ============
        terraform { # defining the terraform block in here

            required_version = "=1.0.0"
            # here defining the required version for the terraform in the configuration should be of 1.0.0 

        }
        
    ```
  
  - now if we want to run the `terraform configuration` and the `terraform version` is not of `1.0.0` then it will throw the error as below


    ```bash
        terraform init # trying to initialize the terraform in this case over here 
        # here we will be getting the below error in that case 
        Initializing the backend...
        │ Error: Unsupported Terraform Core version
        │ 
        │   on terraform.tf line 3, in terraform:
        │    3:     required_version = "=1.0.0"
        │ 
        │ This configuration does not support Terraform version 1.6.3-dev. To proceed, either choose another supported Terraform version or update this version constraint. Version constraints are
        │ normally set for good reason, so updating the constraint may lead to other errors or unexpected behavior.

    ```

  - here that means we `have to have the specific terraform version` in order to run the configuration file in this case
  
  - this will help in pinning the `particular version of terraform` based on the `configuration file` that we have choose 
  
  - this mostly happen when `terraform makes substantial changes` from `one version to another version`  and out code `may not be backward compatible`
  
  - by this way we can pin the `terraform cversion` which will run on the `specific version of terraform configuration` 


