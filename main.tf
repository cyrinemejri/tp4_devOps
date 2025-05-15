provider "aws" {
  region = "us-east-1"
}

# 1. Générer une paire de clés SSH localement
resource "tls_private_key" "deployer_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Sauvegarder la clé privée localement
resource "local_file" "private_key_pem" {
  content              = tls_private_key.deployer_key.private_key_pem
  filename             = "${path.module}/deployer-key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

# 3. Créer la clé publique dans AWS (Key Pair)
resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key"
  public_key = tls_private_key.deployer_key.public_key_openssh
}

# 4. Créer un Security Group avec port 22 ouvert
resource "aws_security_group" "ssh_access" {
  name        = "ssh-access"
  description = "Allow SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Pour restreindre à ton IP: ["<ton-ip>/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access"
  }
}

# 5. Récupérer le VPC par défaut
data "aws_vpc" "default" {
  default = true
}

# 6. Créer une instance EC2 avec la clé SSH et le security group
resource "aws_instance" "web" {
  ami           = "ami-084568db4383264d4" # Ubuntu AMI dans us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name

  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "DevOps-Instance"
  }
}


