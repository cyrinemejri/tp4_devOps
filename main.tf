provider "aws" {
  region = "us-east-1"
}

# Generate SSH key pair locally
resource "tls_private_key" "deployer_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key locally as a .pem file
resource "local_file" "private_key_pem" {
  content              = tls_private_key.deployer_key.private_key_pem
  filename             = "${path.module}/deployer-key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

# Create AWS key pair using the public key
resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key"
  public_key = tls_private_key.deployer_key.public_key_openssh
}

# Create EC2 instance using the key
resource "aws_instance" "web" {
  ami           = "ami-084568db4383264d4" # Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name

  tags = {
    Name = "DevOps-Instance"
  }
}

