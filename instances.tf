resource "aws_instance" "egosphere_web" {
  ami           = "ami-0c1d44089d8a1eeaf"
  instance_type = "t2.micro"
  key_name      = "ridd"
  vpc_security_group_ids = ["${aws_security_group.egosphere.id}"]
  subnet_id     = "${aws_subnet.egosphere-web.id}"
  root_block_device {
    volume_size           = 40
    volume_type           = "standard"
  }

}

resource "aws_eip" "egosphere_ip" {
  instance = "${aws_instance.egosphere_web.id}"
}


