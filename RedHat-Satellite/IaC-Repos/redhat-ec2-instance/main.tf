resource "aws_instance" "redhat_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.kms_key_id
  }

  user_data = file(var.user_data_file)

  tags = {
    Name = var.instance_name
    Environment = var.environment
  }
}

output "instance_public_ip" {
  value = aws_instance.redhat_instance.public_ip
}
