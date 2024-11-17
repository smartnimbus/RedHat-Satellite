#---------------------------------------------------
# VPC Configuration
#---------------------------------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

#---------------------------------------------------
# Subnet Configuration
#---------------------------------------------------
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "main_subnet"
  }
}

#---------------------------------------------------
# Security Group Configuration
#---------------------------------------------------
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
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
    Name = "instance_sg"
  }
}

#---------------------------------------------------
# KMS Key for EBS Encryption
#---------------------------------------------------
resource "aws_kms_key" "ebs_key" {
  description             = "KMS key for encrypting EBS volumes"
  deletion_window_in_days = 30
}

#---------------------------------------------------
# Elastic IP and NAT Gateway
#---------------------------------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.main_subnet.id
}

#---------------------------------------------------
# SSM IAM Role and Instance Profile
#---------------------------------------------------
data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ssm_ec2_role" {
  name = "${var.instance_name}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_instance_profile" "ssm_role_profile" {
  name = "${var.instance_name}-ssm-profile"
  role = aws_iam_role.ssm_ec2_role.name
}

#---------------------------------------------------
# EC2 Instance with Encrypted EBS Volumes and Custom User Data
#---------------------------------------------------
resource "aws_instance" "main_instance" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_role_profile.name
  key_name                    = var.key_name
  associate_public_ip_address = true

  # User data - combines custom and default user data scripts
  user_data = templatefile("${path.module}/combined_userdata.tpl", {
    default_userdata = file("${path.module}/default_userdata.sh")
    custom_userdata  = var.instance_user_data
  })

  # Root Block Device (Encrypted)
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
    kms_key_id  = aws_kms_key.ebs_key.arn
  }

  # Additional Encrypted EBS Volumes
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = 10
    volume_type           = "gp3"
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs_key.arn
    delete_on_termination = true
  }

  tags = {
    Name        = "Main Instance"
    Environment = "Production"
  }
}

#---------------------------------------------------
# Output Values
#---------------------------------------------------
output "instance_id" {
  value = aws_instance.main_instance.id
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_id" {
  value = aws_subnet.main_subnet.id
}
