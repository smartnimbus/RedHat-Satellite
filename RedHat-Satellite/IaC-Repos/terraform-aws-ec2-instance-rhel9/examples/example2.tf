# Simple EC2 Instance

resource "aws_instance" "simple" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  # Tags
  tags = {
    Name = "simple-instance"
  }
}


# EC2 Instance with EBS Volume and Key Pair

resource "aws_instance" "ebs_keypair" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.instance_key_name # Add key pair


  root_block_device {
    volume_size           = 100 # Specify root volume size in GB
    volume_type           = "gp3"
    delete_on_termination = true

  }


  # Tags
  tags = {
    Name = "ebs-keypair-instance"
  }
}



# EC2 Instance with Encrypted EBS Volume and Custom User Data

resource "aws_instance" "encrypted_userdata" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.instance_key_name # Add key pair

  root_block_device {
    volume_size           = 100
    volume_type           = "gp3"
    encrypted             = true # Enable encryption for root volume
    delete_on_termination = true
  }

  user_data = file("${path.module}/user_data.sh") # Provide custom user data


  # Tags
  tags = {
    Name = "encrypted-userdata-instance"
  }
}


# EC2 Instance with KMS Key for Encryption

resource "aws_kms_key" "example" {
  description             = "KMS key 1"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  is_enabled              = true
  multi_region            = false
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    "Name" = "kms-key"

  }
}


resource "aws_instance" "kms_encrypted" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.instance_key_name # Add key pair


  root_block_device {
    volume_size           = 100
    volume_type           = "gp3"
    encrypted             = true
    kms_key_id            = aws_kms_key.example.id # Use a KMS key for encryption
    delete_on_termination = true

  }
  user_data = file("${path.module}/user_data.sh") # Provide custom user data


  # Tags
  tags = {
    Name = "kms-encrypted-instance"
  }
}



# Complex Example with Advanced Networking

resource "aws_instance" "complex_networking" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.instance_key_name # Add key pair


  # Networking
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  private_ip                  = "10.0.1.100"
  vpc_security_group_ids      = [aws_security_group.example.id] # Assign a security group


  root_block_device {
    volume_size           = 100
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

  }

  user_data = file("${path.module}/user_data.sh") # Provide custom user data



  # Tags
  tags = {
    Name = "complex-networking-instance"
  }
}

resource "aws_security_group" "example" {

  description = "Example security group"


  dynamic "ingress" {
    for_each = var.ingress_rules # Use a list of rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}


