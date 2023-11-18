# Lab: Auto Formatting Terraform Code

- `Terraform` operate on a `command line interface` , there are multiple `sub command` which allow us to `interact with the Terraform configuration`

- `Terraform` provides a `useful subcommand` that `can be used to easily format all of your code.` 

- This `subcommand` is called `fmt`. 

- The `subcommand allows you to easily format your Terraform code to a canonical format and style based on a subset of Terraform language style conventions`.

- **Lab**
  
  - here we can define the `Terraform configuration` as below in this case and format it using the ` terraform fmt` command 
  
  - we can define the `terraform configuration` as below in this case 

    ```tf
        main.tf
        =======
        resource "random_string" "randomness" { # creating the resource block for the random_string in this case over here 

            special = true  # defining the special chaaracher allowed as true
            length = 16 # length which is mandetory for therandom string as the 16
            min_special = 2 # minimum special char as 2
            min_lower = 2 # minimum lower char needed is of 2


        }

        output "my_output" { # fetching the value using the output block in here 

            value = random_string.randomness.id # fetching the random hex value that been get generated in this case out in here

        }
    
    
    ```

  - if we want to fomat the `Terraform configuration` then we can run the `terraform fmt` command in this case 

  - whichver the `file` modified by the `terraform fmt` command will be updated in the terminal `<name of the file>` will be displayed in here 
  

    ```bash
        terraform fmt 
        # which will format the Terraform file and output which file are getting updated 
        # here we can see the below outcome as the result in this case 
        main.tf
        terraform.tf
        # we can also run the terraform apply -auto-approve to deploy the infrastructure as below 
        terraform apply -auto-approve
        # we will be seeing th below output as the result in this case 
        random_string.randomness: Refreshing state... [id=obq*)04Vjt[x}eov]
        No changes. Your infrastructure matches the configuration.

        Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

        Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

        Outputs:

        my_output = "obq*)04Vjt[x}eov"
    
    ```
