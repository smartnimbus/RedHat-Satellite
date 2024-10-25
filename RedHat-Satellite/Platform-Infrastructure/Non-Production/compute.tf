# Deploy EC2 instance with hardened RedHat image
module "redhat_ec2" {
  source  = "./modules/redhat-ec2-instance"
  ami_id  = "ami-123456" # Hardened RedHat AMI from Packer
  instance_type = "t3.medium"
  key_name      = var.key_name
  subnet_id     = module.vpc.public_subnets[0]
  security_group_ids = [aws_security_group.satellite_sg.id]
  kms_key_id    = aws_kms_key.ebs_key.arn
  instance_name = "satellite-server"
  environment   = "Production"
  user_data_file = "userdata/satellite_userdata.sh"
}
