terraform {
  
  required_version = ">1.0.0"

  required_providers {

    http = {

        source = "hashicorp/http"
        version = "~>3.4.0"
    }

    aws = {
        source = "hashicorp/aws"
        version = "~>5.23.0"
    }

    random = {
        
        source = "hashicorp/random"
        version = "3.5.1"
    }
    
    
  }


}