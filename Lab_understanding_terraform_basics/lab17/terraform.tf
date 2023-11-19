terraform {

  required_version = ">1.0.0" # defining the terraform core version in this case 

  required_providers {
    aws = {
      source = "hashicorp/aws" # defining the aws module with the source version in  this case as below 
      version = "5.23.1" # defining the AWS version in here
    }
    http = {
      source  = "hashicorp/http" # defining the terraform http provider that we want to interact with 
      version = "3.4.0"          # defining the version for the terraform version in this case
    }
    random = {
      source  = "hashicorp/random" # defining the terraform random provider in this case as below
      version = "3.5.1"            # defining the terraform random module in this case out in here 
    }
    local = {
      source  = "hashicorp/local" # defining the Terraform local version in this case out in here
      version = "2.4.0"           # defining the version of the Terraform Local version in this case 
    }
    tls = {
      source  = "hashicorp/tls" # defining the terraform TLS provider in this case out in here  
      version = "4.0.4"         # defining the version of the Terraform TLS provider we will be using 
    }
  }

}