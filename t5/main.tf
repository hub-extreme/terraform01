provider "aws" {
    region = "ap-south-1"
    access_key = ""
    secret_key = ""
  
}

variable "ec2-count" {
    description = "the count of instance" 
    type = number
    default = 1
}

variable "ec2-type" {
    description = "this is t2.micro type of instance "
    type = string
    default = "t2.micro"
  
}

locals {
  ec2 = "webpage"
}

variable "cidr" {
    default = "172.0.0.0/16"
  
}

resource "aws_key_pair" "web-key" {
    key_name = "web-key"
    public_key = file("")
  
}
 resource "aws_vpc" "web_vpc" {
    cidr_block = var.cidr
   
 }

resource "aws_internet_gateway" "web_ig" {
    vpc_id = aws_vpc.web_vpc.id
  
}  

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.web_vpc.id
    availability_zone = "ap-south-1a"
    cidr_block = "172.0.1.0/24"
    map_public_ip_on_launch = true
  
}

resource "aws_route_table" "web-rt" {
    vpc_id = aws_vpc.web_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.web_ig.id
    }
  
}

resource "aws_route_table_association" "web_rt_assoc" {
    route_table_id = aws_route_table.web-rt.id
    subnet_id = aws_subnet.subnet1.id
  
}

resource "aws_security_group" "web_sg" {
    name = "web_sg"
    vpc_id = aws_vpc.web_vpc.id

    ingress {
        description = "ssh connection"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allows http connection"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "outgoing traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      name="web_sg"
    }
}

resource "aws_instance" "web_instance" {
    ami = ""
    instance_type = var.ec2-type
    count = var.ec2-count
    key_name = aws_key_pair.web-key.key_name
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    subnet_id = aws_subnet.subnet1.id
    tags = {
      name = "${local.ec2}"
    }

    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = file("")
    }

    provisioner "file" {
        source = "~/terra/title.html"
        destination = "/home/ubuntu/title.html"
      
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo apt-get update -y",
            "sudo apt-get install apache2 -y",
            "sudo systemctl enable apache2",
            "sudo systemctl start apache2",
            "cd /home/ubuntu",
            "sudo mv title.html /var/www/html/title.html"
         ]
      
    }
  
}