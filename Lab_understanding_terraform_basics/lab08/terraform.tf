terraform {

  required_version = ">1.0.0" # defining the terraform core required for the configuration

  required_providers { # defining the terraform providers in this case

    aws = {

      source  = "hashicorp/aws" # here sourcing it from the terraform registry
      version = "~>5.23.0"      # which can support the version from 5.23.0 where only the right most part is going to change

    }

    tls = { # defining the TLS module of terraform in here 

      source  = "hashicorp/tls" # defining the Terraform.tf file over here
      version = "4.0.4"         # here we are using the version of the Terraform TLS provider in this case

    }

    local = { # defining the local module in here 

      source  = "hashicorp/local" # defining the terraform local Provider which available in the registry
      version = "~>2.4.0"         # defining the version of the Terraform local provider in this case 

    }

    random = {

      source  = "hashicorp/random" # defining the Terraform random provider which can be fetched from the registry
      version = "=3.5.1"         # defining the Terraform Random provider in this case over here 

    }

    http = { # defining the http module in here which will define the source and version in this case 

      source  = "hashicorp/http" # defining the Terraform http provider in this case out here 
      version = "~>3.4.0"        # defining the version of the Terrafotm http module in this case 

    }

  }

}