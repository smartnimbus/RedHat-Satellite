# example.tf
module "vpc" {
  source = "../vpc" # Adjust path as needed

  vpc_cidr_block              = var.vpc_cidr_block
  vpc_enable_dns_hostnames     = true
  vpc_enable_dns_support       = true
  vpc_name                    = "main_vpc"  # Or make this a variable
  public_subnet_cidr_blocks   = [var.subnet_cidr_block] # List of subnet CIDRs
  availability_zones            = [var.availability_zone] # AZs matching subnets
  igw_name                    = "main_igw" # Or make this a variable

  tags = {
    Name = "main_vpc"
  }
}


module "ec2_instance" {
  source = "../ec2-instance"  # Adjust path as needed

  enable_instance                      = true
  instance_name                        = var.instance_name
  instance_type                        = var.instance_type
  instance_ami                         = var.instance_ami # Pass in the AMI
  instance_associate_public_ip_address = true
  instance_key_name                    = var.key_name #  Key pair
 instance_subnet_id                   = module.vpc.public_subnet_ids[0] # Use output from VPC module
 instance_vpc_security_group_ids      = [aws_security_group.instance_sg.id]

  instance_root_block_device = [{
    volume_size = 20
    volume_type = "gp3"
    encrypted = true
    kms_key_id = aws_kms_key.ebs_key.arn
  }]

 instance_ebs_block_device = [{
    device_name           = "/dev/sdf"
    volume_size           = 10
    volume_type           = "gp3"
    encrypted = true
    kms_key_id = aws_kms_key.ebs_key.arn
    delete_on_termination = true
 }]
  # User Data
  user_data = templatefile("${path.module}/combined_userdata.tpl", {
    default_userdata = file("${path.module}/default_userdata.sh") #Path to your script
    custom_userdata  = var.instance_user_data
  })

  tags = {
    Name        = "Main Instance"
    Environment = "Production"
  }

}


resource "aws_security_group" "instance_sg" {
  vpc_id = module.vpc.vpc_id # Get VPC ID from module

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this - very open right now
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this - VERY open
  }

  tags = {
    Name = "instance_sg"
  }
}

resource "aws_kms_key" "ebs_key" {
  description             = "KMS key for encrypting EBS volumes"
  deletion_window_in_days = 30
  # ... other key settings (policy, etc.) ...
}



# Outputs - Get these from the ec2_instance module
output "instance_id" {
  value = module.ec2_instance.instance_ids # Use module output
}

output "vpc_id" {
  value = module.vpc.vpc_id # VPC ID from the vpc module
}

output "subnet_id" {
  value = module.vpc.public_subnet_ids[0] # Subnet ID from the vpc module
}
