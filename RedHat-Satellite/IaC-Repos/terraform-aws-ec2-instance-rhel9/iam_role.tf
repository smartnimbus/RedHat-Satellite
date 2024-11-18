#------------------------------------------------------------------------------------------------------
# Resource         : aws_iam_role
# description      : Provides an IAM role.
# module           : IAM (Identity & Access Management)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

#---------------------------------------------------
# Data lookup for existing SSM role by name (if already created in AWS account)
# Checks if an IAM role with the specified name exists.
# If it does, the data source will retrieve its properties for later use.
#---------------------------------------------------
data "aws_iam_role" "ssm_ec2_role" {
  # Conditionally create the data source if an IAM role with the specified name exists
  count = length(try([data.aws_iam_role.ssm_ec2_role.instance_name], [])) > 0 ? 1 : 0
  # The name of the IAM role to look for
  name = "${var.instance_name}-ssm-role"
}

#---------------------------------------------------
# AWS IAM Role Resource
# SSM IAM role for EC2 instance - created only if it does not already exist
# Allows the EC2 instance to communicate with SSM (Systems Manager)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
#---------------------------------------------------
resource "aws_iam_role" "ssm_ec2_role" {
  # Conditionally create the resource if the data source did not find an existing role
  count = length(data.aws_iam_role.ssm_ec2_role) == 0 ? 1 : 0
  # The name of the IAM role
  name = "${var.instance_name}-ssm-role"

  # The policy that grants an entity permission to assume the role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
