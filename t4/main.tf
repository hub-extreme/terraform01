provider "aws" {
    region = ""
    secret_key = ""
    access_key = ""
  
}
variable "instancetype" {
    description = "type of instance"
    type = string
    default = ""
  
}
variable "instancecount" {
    description = "count of instance"
    type = number
    default = 1
  
}

variable "cidrblock" {
    default = "192.0.0.0/16"    
  
}

resource "aws_key_pair" "keypair" {
    key_name = "terra-key"
    public_key = file("${path.module}/path of public kry")
  
}

resource "aws_vpc" "terra-vpc" {
    cidr_block = var.cidrblock
  
}

resource "aws_internet_gateway" "terra-ig" {
    vpc_id = aws_vpc.terra-vpc.id
  
}

resource "aws_subnet" "terra-subnet1" {
    vpc_id = aws_vpc.terra-vpc.id
    availability_zone = ""
    cidr_block = "192.0.1.0/24"
    map_public_ip_on_launch = true

  
}

resource "aws_route_table" "terra-rt" {
    vpc_id = aws_vpc.terra-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terra-ig.id
    }
  
}

resource "aws_route_table_association" "terra-rt-asso" {
    subnet_id = aws_subnet.terra-subnet1.id
    route_table_id = aws_route_table.terra-rt.id
  
}

resource "aws_security_group" "terra-sg" {
    name = "web-sg"
    vpc_id = aws_vpc.terra-vpc.id

    ingress {
        description = "http connection"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }

    ingress {
        description = "ssh connection"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }

    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = "0.0.0.0/0"
    }

    tags = {
        name ="terra-sg"
    }

}

resource "aws_instance" "terra-server" {
    ami = ""
    instance_type = var.instancetype
    count = var.instancecount
    vpc_security_group_ids = [aws_security_group.terra-sg.id]
    subnet_id = aws_subnet.terra-subnet1.id
    key_name = aws_key_pair.keypair.key_name

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("${path.module}/path of private key")
      host = self.public_ip
    }

    provisioner "file" {
        source = ""
        destination = ""
      
    }

    provisioner "remote-exec" {
        inline = [ 
            #bootstrap that you want run remotly
         ]
      
    }
}

