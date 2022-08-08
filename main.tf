module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "task1-balazs-vp"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Name = "Nagy"
  }

}

resource "aws_security_group" "allow_ssh_pub" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Nagy"
  }
}

resource "aws_instance" "My-EC2" {
  ami           = "ami-0d75513e7706cf2d9"
  instance_type = "t2.small"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = "key"
  security_groups =["${aws_security_group.allow_ssh_pub.id}"]

  tags = {
    Name = "Nagy"
  }

}
