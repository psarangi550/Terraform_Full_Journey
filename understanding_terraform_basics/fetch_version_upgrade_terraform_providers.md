# Terraform Fetch version and Upgrade Terraform Providers

- **Q:- Describe How `Terraform` `find and fetches` the Provisders ?**

- Hashicorp want to make sure that you to understand the below things as 
  
  -  what `Terraform Providers` are 
  
  - How that can be `installed , versioned and upgraded`  

- A Lot of folks `who don't version their Terraform providers` , which is a `bad practise` which can lead to `configuration which are brittle`

- we can check the `Terraform version` and `Provider version` using the command as `terraform version` command 


    ```bash
        terraform version 
        # which will provide terraform core and provider version in this case 
        Terraform v1.6.3-dev
        on linux_amd64
        + provider registry.terraform.io/hashicorp/aws v5.23.0
        + provider registry.terraform.io/hashicorp/http v3.4.0
        + provider registry.terraform.io/hashicorp/local v2.4.0
        + provider registry.terraform.io/hashicorp/random v3.5.1
        + provider registry.terraform.io/hashicorp/tls v4.0.4

        Your version of Terraform is out of date! The latest version
        is 1.6.3. You can update by downloading from https://www.terraform.io/downloads.html
    
    ```

- we can define the `certain version` of the `Terraform provider` inside `terraform .tf` file as below

  ```tf
      terraform.tf
      ============

      terraform  {

        required_version = ">1.0.0" # defining the terraform core required for the configuration

        required_providers {  # defining the terraform providers in this case

            aws = {
              
              source = "hashicorp/aws" # here sourcing it from the terraform registry
              version = "~>5.23.0" # which can support the version from 5.23.0 where only the right most part is going to change

            }

            tls = { # defining the TLS module of terraform in here 

              source = "hashicorp/tls" # defining the Terraform.tf file over here
              version = "4.0.4" # here we are using the version of the Terraform TLS provider in this case

            }

            local = { # defining the local module in here 

              source = "hashicorp/local" # defining the terraform local Provider which available in the registry
              version = "~>2.4.0" # defining the version of the Terraform local provider in this case 

            }

            random = {
              
              source = "hshicorp/random" # defining the Terraform random provider which can be fetched from the registry
              version = "~>3.5.0" # defining the Terraform Random provider in this case over here 

            }

            http = { # defining the http module in here which will define the source and version in this case 

              source = "hashicorp/http" # defining the Terraform http provider in this case out here 
              version = "~>3.4.0" # defining the version of the Terrafotm http module in this case 

            }

        }

      }
  

  ```

- inside the `terraform.tf` inside the `terrform configuration block` we can define 
  
  - what version of the `terraform core` we need 
  
  - also we can specify `what version of terraform provider` we want to use , there can be `multiple terraform provider version` which being available

- we can specify `a particular version` of the `Terraform provider` by changing the `terraform Provider version` inside the `required_providers` inside `terraform.tf` as below 

- we can define the `terraform.tf` where we are changing the random provider in this case over here as 

  ```tf
      terraform.tf
      ============
      terraform {
        
        required_version = ">=1.0.0" #4 defining the terraform version in this case out in here as >1.0.0

        required_providers { # defining the required providers where we will downgrade the Terraform random provider

          aws = {
              
              source = "hashicorp/aws" # here sourcing it from the terraform registry
              version = "~>5.23.0" # which can support the version from 5.23.0 where only the right most part is going to change

            }

            tls = { # defining the TLS module of terraform in here 

              source = "hashicorp/tls" # defining the Terraform.tf file over here
              version = "4.0.4" # here we are using the version of the Terraform TLS provider in this case

            }

            local = { # defining the local module in here 

              source = "hashicorp/local" # defining the terraform local Provider which available in the registry
              version = "~>2.4.0" # defining the version of the Terraform local provider in this case 

            }

            random = {
              
              source = "hshicorp/random" # defining the Terraform random provider which can be fetched from the registry
              version = "=3.5.0" # defining the Terraform Random provider in this case over here 
              # here defining that we need the version 3.5.0 for the Terraform random provider 

            }

            http = { # defining the http module in here which will define the source and version in this case 

              source = "hashicorp/http" # defining the Terraform http provider in this case out here 
              version = "~>3.4.0" # defining the version of the Terrafotm http module in this case 

            }
        }

      }
  
  ```

- we can upgrade the `version` of the `Terraform Provider` using the command as below 

    ```bash
        terraform init -upgrade 
        # this will upgrade the version of the terraform provider using the above command 
        Initializing the backend...

        Initializing provider plugins...
        - Finding hashicorp/http versions matching "~> 3.4.0"...
        - Finding hashicorp/aws versions matching "~> 5.23.0"...
        - Finding hashicorp/tls versions matching "4.0.4"...
        - Finding hashicorp/local versions matching "~> 2.4.0"...
        - Finding hashicorp/random versions matching "3.5.0"...
        - Using previously-installed hashicorp/http v3.4.0
        - Installing hashicorp/aws v5.23.1...
        - Installed hashicorp/aws v5.23.1 (signed by HashiCorp)
        - Using previously-installed hashicorp/tls v4.0.4
        - Using previously-installed hashicorp/local v2.4.0
        - Installing hashicorp/random v3.5.0...
        - Installed hashicorp/random v3.5.0 (signed by HashiCorp)

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
            

    ```

- we can also run the `terraform init -upgrade` while we define the `terraform.tf` , but will be more helpful if we are changing the version of the `Terraform provider` in that case

- if we specify the `terraform init -upgrade` it will check the `preveious version` of the `terraform configuration block terraform provider version`

- if `no changes mentioned` then it will going with the `preveiously-installed version` of the `Terraform Provider` in that case 

- if the `version being changed` then it will going to the `source which is terraform registry` in order to install the `new version of the Terraform provider` in that case

- once the `Terraform provider` being installed then it does record the `terraform Provider Version` it instaled and use it in the configuration 

- it generate the `dependency lock` once the `terraform Provider version` mentioned in the `terraform.tf` being installed for `record purpose`

- the `dependency lock` file name being `.terraform.lock.hcl` which being generated once the `required Terraform Provider` being installed 

- the content of the dependency lock are of as below 

  ```tf
      .terraform.lock.hcl
      ===================
      # This file is maintained automatically by "terraform init".
      # Manual edits may be lost in future updates.

      provider "registry.terraform.io/hashicorp/aws" {
        version     = "5.23.1"
        constraints = "~> 5.23.0"
        hashes = [
          "h1:s23thJVPJHUdS7ESZHoeMkxNcTeaqWvg2usv8ylFVL4=",
          "zh:024a188ad3c979a9ec0d7d898aaa90a3867a8839edc8d3543ea6155e6e010064",
          "zh:05b73a04c58534a7527718ef55040577d5c573ea704e16a813e7d1b18a7f4c26",
          "zh:13932cdee2fa90f40ebaa783f033752864eb6899129e055511359f8d1ada3710",
          "zh:3500f5febc7878b4426ef89a16c0096eefd4dd0c5b0d9ba00f9ed54387df5d09",
          "zh:394a48dea7dfb0ae40e506ccdeb5387829dbb8ab00fb64f41c347a1de092aa00",
          "zh:51a57f258b3bce2c167b39b6ecf486f72f523da05d4c92adc6b697abe1c5ff1f",
          "zh:7290488a96d8d10119b431eb08a37407c0812283042a21b69bcc2454eabc08ad",
          "zh:7545389dbbba624c0ffa72fa376b359b27f484aba02139d37ee5323b589e0939",
          "zh:92266ac6070809e0c874511ae93097c8b1eddce4c0213e487c5439e89b6ad64d",
          "zh:9b12af85486a96aedd8d7984b0ff811a4b42e3d88dad1a3fb4c0b580d04fa425",
          "zh:9c3841bd650d6ba471c7159bcdfa35200e5e49c2ea11032c481a33cf7875879d",
          "zh:bd103c46a16e7f9357e08d6427c316ccc56d203452130eed8e36ede3afa3322c",
          "zh:cab0a16e320c6ca285a3a51f40c8f46dbaa0712856594819b415b4d8b3e63910",
          "zh:e8adedcda4d6ff47dcae9c9bb884da26ca448fb6f7436be95ad6a341e4d8094a",
          "zh:fc23701a3723f50878f440dcdf8768ea96d60a0d7c351aa6dfb912ad832c8384",
        ]
      }

      provider "registry.terraform.io/hashicorp/http" {
        version     = "3.4.0"
        constraints = "~> 3.4.0"
        hashes = [
          "h1:h3URn6qAnP36OlSqI1tTuKgPL3GriZaJia9ZDrUvRdg=",
          "zh:56712497a87bc4e91bbaf1a5a2be4b3f9cfa2384baeb20fc9fad0aff8f063914",
          "zh:6661355e1090ebacab16a40ede35b029caffc279d67da73a000b6eecf0b58eba",
          "zh:67b92d343e808b92d7e6c3bbcb9b9d5475fecfed0836963f7feb9d9908bd4c4f",
          "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
          "zh:86ebb9be9b685c96dbb5c024b55d87526d57a4b127796d6046344f8294d3f28e",
          "zh:902be7cfca4308cba3e1e7ba6fc292629dfd150eb9a9f054a854fa1532b0ceba",
          "zh:9ba26e0215cd53b21fe26a0a98c007de1348b7d13a75ae3cfaf7729e0f2c50bb",
          "zh:a195c941e1f1526147134c257ff549bea4c89c953685acd3d48d9de7a38f39dc",
          "zh:a7967b3d2a8c3e7e1dc9ae381ca753268f9fce756466fe2fc9e414ca2d85a92e",
          "zh:bde56542e9a093434d96bea21c341285737c6d38fea2f05e12ba7b333f3e9c05",
          "zh:c0306f76903024c497fd01f9fd9bace5854c263e87a97bc2e89dcc96d35ca3cc",
          "zh:f9335a6c336171e85f8e3e99c3d31758811a19aeb21fa8c9013d427e155ae2a9",
        ]
      }

      provider "registry.terraform.io/hashicorp/local" {
        version     = "2.4.0"
        constraints = "~> 2.4.0"
        hashes = [
          "h1:R97FTYETo88sT2VHfMgkPU3lzCsZLunPftjSI5vfKe8=",
          "zh:53604cd29cb92538668fe09565c739358dc53ca56f9f11312b9d7de81e48fab9",
          "zh:66a46e9c508716a1c98efbf793092f03d50049fa4a83cd6b2251e9a06aca2acf",
          "zh:70a6f6a852dd83768d0778ce9817d81d4b3f073fab8fa570bff92dcb0824f732",
          "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
          "zh:82a803f2f484c8b766e2e9c32343e9c89b91997b9f8d2697f9f3837f62926b35",
          "zh:9708a4e40d6cc4b8afd1352e5186e6e1502f6ae599867c120967aebe9d90ed04",
          "zh:973f65ce0d67c585f4ec250c1e634c9b22d9c4288b484ee2a871d7fa1e317406",
          "zh:c8fa0f98f9316e4cfef082aa9b785ba16e36ff754d6aba8b456dab9500e671c6",
          "zh:cfa5342a5f5188b20db246c73ac823918c189468e1382cb3c48a9c0c08fc5bf7",
          "zh:e0e2b477c7e899c63b06b38cd8684a893d834d6d0b5e9b033cedc06dd7ffe9e2",
          "zh:f62d7d05ea1ee566f732505200ab38d94315a4add27947a60afa29860822d3fc",
          "zh:fa7ce69dde358e172bd719014ad637634bbdabc49363104f4fca759b4b73f2ce",
        ]
      }

      provider "registry.terraform.io/hashicorp/random" {
        version     = "3.5.0"
        constraints = "3.5.0"
        hashes = [
          "h1:HDccvrn3jyMiCD1fFDXpk6zLZiCKkeP+iRuP1pNqOS4=",
          "zh:0d95ed87398d5592e9c699f658eeef04e945945c996174222071c217e46f3c76",
          "zh:57df331c814e3d7fa5b60807e9c742a62084a8330496b3ec00db94760f6411e1",
          "zh:5c14b04b9b430383ac819bda73ce4291c8a677a894662adc71e409e8a0bf7ce7",
          "zh:61958056bd163fa0dcb4af562df9974506ce1b2c95473b8fd48714ce599bb143",
          "zh:6c5d33b170de17c0e045c30b973f265af02c8ad15d694d5337501592244c936c",
          "zh:78687a24d88cc067fd81227e8f3dc6b3c7f13d9808e9c1da336e29722464e45b",
          "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
          "zh:9590a4bb4f333e34ad4fcac3efba5b3a8ba53120b3ff4e38948dd176726c2fc1",
          "zh:9eafa5aa49699cecc338f8787e2ccf5a0e652500174ec5112f68f9e098c5c30a",
          "zh:b8917751bb3e195657e284b28d07b8ca6d47889e7249b5fd84dd9c3abe5fa01b",
          "zh:cc666a522256ad9a977c5a85e882e573a6422adf887cd21817a504c38ea19178",
          "zh:ed2390933b029578583cf60517b783ea77ea644f33b525e0d5c037b992047070",
        ]
      }

      provider "registry.terraform.io/hashicorp/tls" {
        version     = "4.0.4"
        constraints = "4.0.4"
        hashes = [
          "h1:pe9vq86dZZKCm+8k1RhzARwENslF3SXb9ErHbQfgjXU=",
          "zh:23671ed83e1fcf79745534841e10291bbf34046b27d6e68a5d0aab77206f4a55",
          "zh:45292421211ffd9e8e3eb3655677700e3c5047f71d8f7650d2ce30242335f848",
          "zh:59fedb519f4433c0fdb1d58b27c210b27415fddd0cd73c5312530b4309c088be",
          "zh:5a8eec2409a9ff7cd0758a9d818c74bcba92a240e6c5e54b99df68fff312bbd5",
          "zh:5e6a4b39f3171f53292ab88058a59e64825f2b842760a4869e64dc1dc093d1fe",
          "zh:810547d0bf9311d21c81cc306126d3547e7bd3f194fc295836acf164b9f8424e",
          "zh:824a5f3617624243bed0259d7dd37d76017097dc3193dac669be342b90b2ab48",
          "zh:9361ccc7048be5dcbc2fafe2d8216939765b3160bd52734f7a9fd917a39ecbd8",
          "zh:aa02ea625aaf672e649296bce7580f62d724268189fe9ad7c1b36bb0fa12fa60",
          "zh:c71b4cd40d6ec7815dfeefd57d88bc592c0c42f5e5858dcc88245d371b4b8b1e",
          "zh:dabcd52f36b43d250a3d71ad7abfa07b5622c69068d989e60b79b2bb4f220316",
          "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
        ]
      }

  ```

- in the `provider` block it will highlight `what is the exact terraform provider been downloaded from` we want to use inside `.terraform.lock.hcl` file 

- it also define the `what version of the Terraform Provider` that being installed 

- it also define the `met the constrsaint condition ` in this `.terraform.lock.hcl` file 

- also define the `hashes` for that `Particular Terraform Provider` which being `installed and used`

- if someone want to `mask the Terraform provider` and `inject some malicious code to the environment` , for which `Hashicorp` `hashes out` the `Terraform Provider Version`

- during the time of `terraform init -upgrade` it will do a comparison of the hashes and  matches the `hashes` for what being asked of 

- when we change the `version of the Terraform Provider inside the terraform.tf` it will change the `version`, `constraint` and `hashes` of the `Terraform Provider` inside the `.terraform.lock.hcl` file as well

- for each of the `Terraform Provider` we have defined the same pattern of `version` , `constraint` , `hashes`  will be created for `Each terraform Provider` inside `.terraform.lock.hcl` file

- lets suppose we changr the `Terraform Random Provider` as below 

  ```tf
      terraform.tf
      ============
      terraform {
        
        required_version = ">=1.0.0" #4 defining the terraform version in this case out in here as >1.0.0

        required_providers { # defining the required providers where we will downgrade the Terraform random provider

          aws = {
              
              source = "hashicorp/aws" # here sourcing it from the terraform registry
              version = "~>5.23.0" # which can support the version from 5.23.0 where only the right most part is going to change

            }

            tls = { # defining the TLS module of terraform in here 

              source = "hashicorp/tls" # defining the Terraform.tf file over here
              version = "4.0.4" # here we are using the version of the Terraform TLS provider in this case

            }

            local = { # defining the local module in here 

              source = "hashicorp/local" # defining the terraform local Provider which available in the registry
              version = "~>2.4.0" # defining the version of the Terraform local provider in this case 

            }

            random = {
              
              source = "hshicorp/random" # defining the Terraform random provider which can be fetched from the registry
              version = "=3.5.1" # defining the Terraform Random provider in this case over here 
              # here defining that we need the version 3.5.1 for the Terraform random provider 

            }

            http = { # defining the http module in here which will define the source and version in this case 

              source = "hashicorp/http" # defining the Terraform http provider in this case out here 
              version = "~>3.4.0" # defining the version of the Terrafotm http module in this case 

            }
        }

      }

  
  ```

- now we can run the command as `terraform init -upgrade` in order to change the `Terraform Provider Version` and then we can run the command as `terraform version` to check after the `particular Terraform Provider version` being installed 

- we can run the command as below 

  ```bash
      terraform init -upgrade
      # upgrading the Terraform version using the command as below 
      Initializing the backend...

      Initializing provider plugins...
      - Finding hashicorp/aws versions matching "~> 5.23.0"...
      - Finding hashicorp/tls versions matching "4.0.4"...
      - Finding hashicorp/local versions matching "~> 2.4.0"...
      - Finding hashicorp/random versions matching "3.5.1"...
      - Finding hashicorp/http versions matching "~> 3.4.0"...
      - Using previously-installed hashicorp/aws v5.23.1
      - Using previously-installed hashicorp/tls v4.0.4
      - Using previously-installed hashicorp/local v2.4.0
      - Installing hashicorp/random v3.5.1...
      - Installed hashicorp/random v3.5.1 (signed by HashiCorp)
      - Using previously-installed hashicorp/http v3.4.0

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

      terraform version # checking which version of the Terrafom random version being installed 
      # the output will be as below 
      Terraform v1.6.3-dev
    on linux_amd64
    + provider registry.terraform.io/hashicorp/aws v5.23.1
    + provider registry.terraform.io/hashicorp/http v3.4.0
    + provider registry.terraform.io/hashicorp/local v2.4.0
    + provider registry.terraform.io/hashicorp/random v3.5.1
    + provider registry.terraform.io/hashicorp/tls v4.0.4

    Your version of Terraform is out of date! The latest version
    is 1.6.3. You can update by downloading from https://www.terraform.io/downloads.html

      
  ```

- we can see that the `version`,`constraint`,`hashes` for that `terraform Provider` section being changed in this case for `.terraform.lock.hcl`

- here the is new `terraform.lock.hcl` file as below 


  ```tf
      .terraform.lock.hcl
      ===================
      # This file is maintained automatically by "terraform init".
    # Manual edits may be lost in future updates.

    provider "registry.terraform.io/hashicorp/aws" {
      version     = "5.23.1"
      constraints = "~> 5.23.0"
      hashes = [
        "h1:s23thJVPJHUdS7ESZHoeMkxNcTeaqWvg2usv8ylFVL4=",
        "zh:024a188ad3c979a9ec0d7d898aaa90a3867a8839edc8d3543ea6155e6e010064",
        "zh:05b73a04c58534a7527718ef55040577d5c573ea704e16a813e7d1b18a7f4c26",
        "zh:13932cdee2fa90f40ebaa783f033752864eb6899129e055511359f8d1ada3710",
        "zh:3500f5febc7878b4426ef89a16c0096eefd4dd0c5b0d9ba00f9ed54387df5d09",
        "zh:394a48dea7dfb0ae40e506ccdeb5387829dbb8ab00fb64f41c347a1de092aa00",
        "zh:51a57f258b3bce2c167b39b6ecf486f72f523da05d4c92adc6b697abe1c5ff1f",
        "zh:7290488a96d8d10119b431eb08a37407c0812283042a21b69bcc2454eabc08ad",
        "zh:7545389dbbba624c0ffa72fa376b359b27f484aba02139d37ee5323b589e0939",
        "zh:92266ac6070809e0c874511ae93097c8b1eddce4c0213e487c5439e89b6ad64d",
        "zh:9b12af85486a96aedd8d7984b0ff811a4b42e3d88dad1a3fb4c0b580d04fa425",
        "zh:9c3841bd650d6ba471c7159bcdfa35200e5e49c2ea11032c481a33cf7875879d",
        "zh:bd103c46a16e7f9357e08d6427c316ccc56d203452130eed8e36ede3afa3322c",
        "zh:cab0a16e320c6ca285a3a51f40c8f46dbaa0712856594819b415b4d8b3e63910",
        "zh:e8adedcda4d6ff47dcae9c9bb884da26ca448fb6f7436be95ad6a341e4d8094a",
        "zh:fc23701a3723f50878f440dcdf8768ea96d60a0d7c351aa6dfb912ad832c8384",
      ]
    }

    provider "registry.terraform.io/hashicorp/http" {
      version     = "3.4.0"
      constraints = "~> 3.4.0"
      hashes = [
        "h1:h3URn6qAnP36OlSqI1tTuKgPL3GriZaJia9ZDrUvRdg=",
        "zh:56712497a87bc4e91bbaf1a5a2be4b3f9cfa2384baeb20fc9fad0aff8f063914",
        "zh:6661355e1090ebacab16a40ede35b029caffc279d67da73a000b6eecf0b58eba",
        "zh:67b92d343e808b92d7e6c3bbcb9b9d5475fecfed0836963f7feb9d9908bd4c4f",
        "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
        "zh:86ebb9be9b685c96dbb5c024b55d87526d57a4b127796d6046344f8294d3f28e",
        "zh:902be7cfca4308cba3e1e7ba6fc292629dfd150eb9a9f054a854fa1532b0ceba",
        "zh:9ba26e0215cd53b21fe26a0a98c007de1348b7d13a75ae3cfaf7729e0f2c50bb",
        "zh:a195c941e1f1526147134c257ff549bea4c89c953685acd3d48d9de7a38f39dc",
        "zh:a7967b3d2a8c3e7e1dc9ae381ca753268f9fce756466fe2fc9e414ca2d85a92e",
        "zh:bde56542e9a093434d96bea21c341285737c6d38fea2f05e12ba7b333f3e9c05",
        "zh:c0306f76903024c497fd01f9fd9bace5854c263e87a97bc2e89dcc96d35ca3cc",
        "zh:f9335a6c336171e85f8e3e99c3d31758811a19aeb21fa8c9013d427e155ae2a9",
      ]
    }

    provider "registry.terraform.io/hashicorp/local" {
      version     = "2.4.0"
      constraints = "~> 2.4.0"
      hashes = [
        "h1:R97FTYETo88sT2VHfMgkPU3lzCsZLunPftjSI5vfKe8=",
        "zh:53604cd29cb92538668fe09565c739358dc53ca56f9f11312b9d7de81e48fab9",
        "zh:66a46e9c508716a1c98efbf793092f03d50049fa4a83cd6b2251e9a06aca2acf",
        "zh:70a6f6a852dd83768d0778ce9817d81d4b3f073fab8fa570bff92dcb0824f732",
        "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
        "zh:82a803f2f484c8b766e2e9c32343e9c89b91997b9f8d2697f9f3837f62926b35",
        "zh:9708a4e40d6cc4b8afd1352e5186e6e1502f6ae599867c120967aebe9d90ed04",
        "zh:973f65ce0d67c585f4ec250c1e634c9b22d9c4288b484ee2a871d7fa1e317406",
        "zh:c8fa0f98f9316e4cfef082aa9b785ba16e36ff754d6aba8b456dab9500e671c6",
        "zh:cfa5342a5f5188b20db246c73ac823918c189468e1382cb3c48a9c0c08fc5bf7",
        "zh:e0e2b477c7e899c63b06b38cd8684a893d834d6d0b5e9b033cedc06dd7ffe9e2",
        "zh:f62d7d05ea1ee566f732505200ab38d94315a4add27947a60afa29860822d3fc",
        "zh:fa7ce69dde358e172bd719014ad637634bbdabc49363104f4fca759b4b73f2ce",
      ]
    }

    provider "registry.terraform.io/hashicorp/random" { # here  we can see the New Provider section in this case 
      version     = "3.5.1" # new version being defined for the Provider
      constraints = "3.5.1" # new constraint content being defined as well in here 
      hashes = [ # here also it will be the new hashes that being generated
        "h1:VSnd9ZIPyfKHOObuQCaKfnjIHRtR7qTw19Rz8tJxm+k=",
        "zh:04e3fbd610cb52c1017d282531364b9c53ef72b6bc533acb2a90671957324a64",
        "zh:119197103301ebaf7efb91df8f0b6e0dd31e6ff943d231af35ee1831c599188d",
        "zh:4d2b219d09abf3b1bb4df93d399ed156cadd61f44ad3baf5cf2954df2fba0831",
        "zh:6130bdde527587bbe2dcaa7150363e96dbc5250ea20154176d82bc69df5d4ce3",
        "zh:6cc326cd4000f724d3086ee05587e7710f032f94fc9af35e96a386a1c6f2214f",
        "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
        "zh:b6d88e1d28cf2dfa24e9fdcc3efc77adcdc1c3c3b5c7ce503a423efbdd6de57b",
        "zh:ba74c592622ecbcef9dc2a4d81ed321c4e44cddf7da799faa324da9bf52a22b2",
        "zh:c7c5cde98fe4ef1143bd1b3ec5dc04baf0d4cc3ca2c5c7d40d17c0e9b2076865",
        "zh:dac4bad52c940cd0dfc27893507c1e92393846b024c5a9db159a93c534a3da03",
        "zh:de8febe2a2acd9ac454b844a4106ed295ae9520ef54dc8ed2faf29f12716b602",
        "zh:eab0d0495e7e711cca367f7d4df6e322e6c562fc52151ec931176115b83ed014",
      ]
    }

    provider "registry.terraform.io/hashicorp/tls" {
      version     = "4.0.4"
      constraints = "4.0.4"
      hashes = [
        "h1:pe9vq86dZZKCm+8k1RhzARwENslF3SXb9ErHbQfgjXU=",
        "zh:23671ed83e1fcf79745534841e10291bbf34046b27d6e68a5d0aab77206f4a55",
        "zh:45292421211ffd9e8e3eb3655677700e3c5047f71d8f7650d2ce30242335f848",
        "zh:59fedb519f4433c0fdb1d58b27c210b27415fddd0cd73c5312530b4309c088be",
        "zh:5a8eec2409a9ff7cd0758a9d818c74bcba92a240e6c5e54b99df68fff312bbd5",
        "zh:5e6a4b39f3171f53292ab88058a59e64825f2b842760a4869e64dc1dc093d1fe",
        "zh:810547d0bf9311d21c81cc306126d3547e7bd3f194fc295836acf164b9f8424e",
        "zh:824a5f3617624243bed0259d7dd37d76017097dc3193dac669be342b90b2ab48",
        "zh:9361ccc7048be5dcbc2fafe2d8216939765b3160bd52734f7a9fd917a39ecbd8",
        "zh:aa02ea625aaf672e649296bce7580f62d724268189fe9ad7c1b36bb0fa12fa60",
        "zh:c71b4cd40d6ec7815dfeefd57d88bc592c0c42f5e5858dcc88245d371b4b8b1e",
        "zh:dabcd52f36b43d250a3d71ad7abfa07b5622c69068d989e60b79b2bb4f220316",
        "zh:f569b65999264a9416862bca5cd2a6177d94ccb0424f3a4ef424428912b9cb3c",
      ]
    }

  
  ```

- this will be really slick , as we can share the `code` along with the `lock file` to someone , when they perform the `terraform init` it will `read the Terraform Provider info` from the `.terraform.lock.hcl` dependency lock file and download the `specific Terraform Version` which being required which also match the `terraform.tf`


