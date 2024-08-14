


provider "aws" {
    region = ""
    secret_key = ""
    access_key = ""
  
}

resource "aws_instance" "terra-server" {
    ami = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    tags = {
        desc = "sample terra-server"
    }
        
}