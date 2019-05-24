resource "aws_security_group" "nazmurwebserversg" {
    name = "nazmurwebserversg"
    vpc_id = "${aws_vpc.NazmurVPC.id}"

    #SSH access from anywhere
    ingress {
        from_port =22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #HTTP access from anywhere

  ingress {
        from_port =80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # Outbound
    egress {
        from_port =0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_instance" "nazmurwebserver" {
    ami = "${lookup(var.aws_amis,var.aws_region)}"
    instance_type = "t2.micro"
    associate_public_ip_address =true
    user_data = "${file("install_apache.sh")}"
    tags{
        Name = "NazmurWebServer1"
    }
  subnet_id = "${aws_subnet.nazmurpublicsubnet.*.id[0]}"
  vpc_security_group_ids = ["${aws_security_group.nazmurwebserversg.id}"]

} 


resource "aws_instance" "nazmurwebserver2" {
    ami = "${lookup(var.aws_amis,var.aws_region)}"
    instance_type = "t2.micro"
    associate_public_ip_address =true
    user_data = "${file("install_apache.sh")}"
    tags{
        Name = "NazmurWebServer2"
    }
  subnet_id = "${aws_subnet.nazmurpublicsubnet.*.id[1]}"
  vpc_security_group_ids = ["${aws_security_group.nazmurwebserversg.id}"]

} 