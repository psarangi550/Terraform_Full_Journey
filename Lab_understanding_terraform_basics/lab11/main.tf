resource "random_string" "randomness" { # creating the resource block for the random_string in this case over here 

  special     = true # defining the special chaaracher allowed as true
  length      = 16   # length which is mandetory for therandom string as the 16
  min_special = 2    # minimum special char as 2
  min_lower   = 2    # minimum lower char needed is of 2


}

output "my_output" { # fetching the value using the output block in here 

  value = random_string.randomness.id # fetching the random hex value that been get generated in this case out in here

}