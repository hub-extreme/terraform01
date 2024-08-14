/* creating a terra-server/instance using different variables*/

provider "aws" {
    region = ""
    secret_key = " "
    access_key = ""
  
}



/*this variable is used to give the number of instances to be created.*/
variable "server-count" {
    description = "this vaariable is used to give the number of instances"
    type = number
    default = 2
  
}

/*this variable is used to assign the instance type*/

variable "inst-type" {
    description = "this variable assign the type of instance"
    type = string
    default = "t2.micro"
  
}

/*this variable is used to give tag with the help of local variables.*/

 locals {
   xyz= "production-server"
 }

 /* creating variable for s3 bucket*/
 variable "s3-bucket" {
  description = "this is the simple storage service from amazon."
  type = string
  default = "your-s3"

   
 }

 /* creating resource block for ec2 instance*/
 resource "aws_instance" "terra-server" {
    ami = "ami-04a81a99f5ec58529"
    instance_type =  var.inst-type   /* here value of instance type is in the variable inst-type, so we provide variable instead of direct value.*/
    count = var.server-count       /* here value of count is in the variable server-count,so we provide that variable.*/
    tags = {
      environment = "${local.xyz}"  /*here we gave key= environment and value =local variable that we created i.e xyz*/

    }
 }

resource "aws_s3_bucket" "my-s3" {
  bucket_prefix = var.s3-bucket
  
}

output "bucket" {
  value = "this is s3 bucket" 
  
}
   
 



