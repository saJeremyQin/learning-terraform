output "instance_ami" {
  value = aws_instance.mooji.ami
}

output "instance_arn" {
  value = aws_instance.mooji.arn
}
output "alb_dns_name" {
  value = module.alb.dns_name
}

# alb_dns_name = "blog-alb-1921363458.ap-southeast-2.elb.amazonaws.com"
# instance_ami = "ami-0725936c061dd32e4"
# instance_arn = "arn:aws:ec2:ap-southeast-2:205930647566:instance/i-04a9eabfb9b23f6ef"