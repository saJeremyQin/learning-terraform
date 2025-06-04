data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

module "blog_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


resource "aws_instance" "mooji" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.blog_sg.security_group_id]

  subnet_id = module.blog_vpc.public_subnets[0]

  tags = {
    Name = "Mooji"
  }
}

module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  name    = "blog"

  # vpc_id        = data.aws_vpc.default.id
  vpc_id = module.blog_vpc.vpc_id
  ingress_rules = ["http-80-tcp", "https-443-tcp"] 
  egress_rules  = ["all-all"]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

# resource "aws_security_group" "blog" {
#   name        = "blog"
#   description = "Allow http and https in, allow everything out"

#   vpc_id = data.aws_vpc.default.id
# }

# resource "aws_security_group_rule" "blog_http_in" {
#   security_group_id = aws_security_group.blog.id
#   type        = "ingress"
#   from_port   = 80
#   to_port     = 80
#   protocol    = "tcp"
#   cidr_blocks = [ "0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "blog_https_in" {
#   security_group_id = aws_security_group.blog.id
#   type        = "ingress"
#   from_port   = 443
#   to_port     = 443
#   protocol    = "tcp"
#   cidr_blocks = [ "0.0.0.0/0" ]
# }

# resource "aws_security_group_rule" "blog_everything_out" {
#   security_group_id = aws_security_group.blog.id
#   type        = "egress"
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = [ "0.0.0.0/0" ]
# }