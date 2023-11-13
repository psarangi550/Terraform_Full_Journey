resource "tls_private_key" "generated" { # using the tls_private_key module with the name as generated

  algorithm = "RSA" # defining the algorithm as RSA in this case out in here 

  rsa_bits = 4096 # defining the number of bits used for RSA is of 4096

}

resource "local_file" "private_pem_key" { # using the resource as the local_file which being present in the Terraform local provider with the name as  private_pem_key

  content = tls_private_key.generated.private_key_pem # here defining the content as the private_key_content in this case over here
  # private_key_pem will generate Private key data in PEM (RFC 1421) format.
  filename = "myAmazonSshKey.PEM" # saving this content with the file name as  myAmazonSshKey.PEM

}