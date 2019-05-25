#VPC
resource "aws_vpc" "NazmurVPC" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags{
        Name = "NazmurVPC"
    }  
}
#InternetGateway
resource "aws_internet_gateway" "NazmurIgw" {
  vpc_id = "${aws_vpc.NazmurVPC.id}"
  tags{
      Name = "NazmurIGW"
  }
}

#public subnet

resource "aws_subnet" "nazmurpublicsubnet" {
vpc_id = "${aws_vpc.NazmurVPC.id}"

count = "${length(var.public_subnet_cidr)}"
cidr_block = "${element(var.public_subnet_cidr, count.index)}"    
availability_zone = "${element(var.azs, count.index)}"
#for single availability zone
#availability_zone = "${var.azs}" 
    tags{
        Name = "NazmurPublicSubnet-${count.index+1}" 
    }
    map_public_ip_on_launch = true #assign the public ip automatically whereever the subnet is created
    }
#Public Route Table : Define Route for IGW
resource "aws_route_table" "nazmurpublicroutetable" {
    vpc_id = "${aws_vpc.NazmurVPC.id}"
    route{
        cidr_block = "0.0.0/0"
        gateway_id = "{aws_internet_gateway.nazmurigw.id}"
    }
        tags{
            Name = "NazmurPublicRouteTable"
        }
    }
  

#Public Route Table Association to Subnet
resource "aws_route_table_association" "nazmurpublicroutetableassociation" {
    
count = "${length(var.public_subnet_cidr)}"
subnet_id = "${element(aws_subnet.nazmurpublicsubnet.*.id, count.index)}"
route_table_id = "{aws_route_table.nazmurpublicroutetable.id}"
  }

#Private Subnet
resource "aws_subnet" "nazmurprivatesubnet" {
vpc_id = "${aws_vpc.NazmurVPC.id}"

count = "${length(var.private_subnet_cidr)}"
cidr_block = "${element(var.private_subnet_cidr, count.index)}"    
availability_zone = "${element(var.azs, count.index)}"
#for single availability zone
#availability_zone = "${var.azs}" 
    tags{
        Name = "NazmurPrivateSubnet-${count.index+1}" 
    }
}

#Private Route Table
resource "aws_route_table" "nazmurroutetable" {
    vpc_id = "${aws_vpc.NazmurVPC.id}"
        tags{
            Name = "NazmurRouteTable"
        }
    }
  

#Private Route Table Association to PrivateSubnet
resource "aws_route_table_association" "nazmurprivateroutetableassociation" {
    
count = "${length(var.private_subnet_cidr)}"
subnet_id = "${element(aws_subnet.nazmurprivatesubnet.*.id, count.index)}"
route_table_id = "{aws_route_table.nazmurroutetable.id}"
  }
