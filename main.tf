provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # À adapter à ta région
  instance_type = "t2.micro"

  tags = {
    Name = "DevOps-Instance"
  }
}

