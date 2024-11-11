# AWS EC2 Instance Module

This Terraform module creates an EC2 instance on AWS with customizable options for instance type, OS, monitoring, backups, and security.

## Features
- Forced encryption on root and EBS volumes
- Configurable region, availability zone, and instance type
- Preconfigured for Amazon Linux, Ubuntu, and Windows
- Optional detailed monitoring and SSM agent for remote Ansible execution
- Custom user data scripts

## Usage

```hcl
module "ec2_instance" {
  source           = "./modules/ec2-instance"
  name             = "my-ec2-instance"
  region           = "us-west-2"
  instance_type    = "t3.medium"
  os_type          = "Amazon Linux"
  ami              = "ami-0123456789"
  subnet_id        = "subnet-0abcd12345"
  security_group_ids = ["sg-0123456789abcdef0"]
  custom_user_data = <<-EOF
    echo "Custom script here"
  EOF
}



### Best Practices and Version Control

- **Security**: Use AWS IAM policies to secure the EC2 instance, ensuring all storage is encrypted and using SSM for managed connections.
- **Versioning**: Create a GitLab repository for this module and version control using tags and semantic versioning.
- **Modularity**: Isolate configurations into variables and templates, making the module reusable.

This structure and code sample make the module secure, configurable, and ready to be used as a shared module in GitLab.
