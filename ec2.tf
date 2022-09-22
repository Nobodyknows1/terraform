resource "aws_instance" "web" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.TF_SG.name]
  count = 2
  #key_name = "demo"
  tags = {
    Name = "TerraF Ec2"
  }
}

#keypair second method for Key_pair

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "TF_key"
}


# security group using terraform

resource "aws_security_group" "TF_SG" {
  name        = "security group using Terraform"
  description = "security group using Terraform"
  vpc_id      = "vpc-c211c1b8"

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  #ingress {
  #  description      = "HTTP"
  #  from_port        = 8080
  #  to_port          = 8080
  #  protocol         = "tcp"
  #  cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  #}
 

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}
