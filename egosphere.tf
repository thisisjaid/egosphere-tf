## declare our provider

provider "aws" {
  profile    = "egosphere-tf"
  region     = "eu-west-1"
}

## create a VPC

resource "aws_vpc" "egosphere" {
  cidr_block = "10.0.0.0/16"
}

## create an internet gateway for our VPC

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.egosphere.id}"
}

## Grant the VPC internet access on its main route table

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.egosphere.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into

resource "aws_subnet" "egosphere-web" {
  vpc_id                  = "${aws_vpc.egosphere.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Create and assign an Elastic IP so we always have the same external IP

resource "aws_eip" "egosphere_ip" {
  instance = "${aws_instance.egosphere_web.id}"
}

# Create a security group and allow SSH access

resource "aws_security_group" "egosphere" {
  name        = "egosphere"
  description = "Egosphere specific rules"
  vpc_id      = "${aws_vpc.egosphere.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Finally create the actual instance

resource "aws_instance" "egosphere_web" {
  ami           = "ami-0c1d44089d8a1eeaf"
  instance_type = "t2.micro"
  key_name      = "ridd"
  vpc_security_group_ids = ["${aws_security_group.egosphere.id}"]
  subnet_id     = "${aws_subnet.egosphere-web.id}"

}

