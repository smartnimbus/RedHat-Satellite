module "ec2_instance" {
  source             = "git::https://gitlab.com/......?ref=v1.0.0"
  name               = "production-ec2-instance"
  region             = "us-east-1"
  availability_zone  = "us-east-1a"
  instance_type      = "t3.large"
  os_type            = "redha"
  ami                = "ami-0123456789"
  subnet_id          = "subnet-0abcd12345"
  security_group_ids = ["sg-0123456789abcdef0"]

  # Optional configurations
  enable_monitoring = true


  custom_user_data = <<-EOF
    # Custom startup script
    echo "Hello, World!"
  EOF

  additional_ebs_volumes = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 20
    }
  ]

  tags = {
    Environment = "production"
    Team        = "devops"
  }
}
