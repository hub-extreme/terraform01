provider "aws" {
    region = ""
    access_key = ""
    secret_key = ""
  
}
/*variable "instance_count" {
    description = "no. of instance"
    type = number
    default = 2
  
}
variable "instance_type" {
    description = "it is a type of instance"
    type = string
    default = "t2.micro"

}

locals {
  xdata = "container"
}

resource "aws_instance" "myinstance" {
    ami = "ami-0ad21ae1d0696ad58"
    instance_type = var.instance_type
    tags = {
    servertype = "${local.xdata}"
    }
    count = var.instance_count

}

output "ipaddress" {
    value = "this is dockerserver."

  
}*/

/*variable "terrausers" {
    description = "cloudusers"
    type = list(string)
    default = [ "u1","u2","u3" ]
  
}
 
 resource "aws_iam_user" "users" {
   count = length(var.terrausers)
   name = var.terrausers[count.index]
 }*/

 variable "sss" {
    description = "bucket"
    type = string
    default = "s3bucket-00123"
   
 }

 resource "aws_s3_bucket" "s3block" {
    bucket = var.sss
   
 }

 resource "aws_s3_object" "ojects3" {
    bucket = aws_s3_bucket.s3block.bucket 
    source = ""
    key = ""
 }
 