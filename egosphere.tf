provider "aws" {
  profile    = "egosphere-tf"
  region     = "eu-west-1"
}

resource "aws_instance" "egosphere_web" {
  ami           = "ami-0c1d44089d8a1eeaf"
  instance_type = "t2.micro"
}
