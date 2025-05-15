provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/deployer-key.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-084568db4383264d4" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "DevOps-Instance"
  }
}

