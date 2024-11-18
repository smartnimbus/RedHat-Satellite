#------------------------------------------------------------------------------------------------------
# Resource         : aws_iam_instance_profile
# description      : Provides an IAM instance profile.
# module           : IAM (Identity & Access Management)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

#---------------------------------------------------
# AWS IAM Instance Profile
# Creates an instance profile for the IAM role, allowing EC2 instances to assume it
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
#---------------------------------------------------
resource "aws_iam_instance_profile" "ssm_role_profile" {
  # The name of the instance profile
  name = "${var.instance_name}-ssm-profile"
  # The name of the IAM role to associate with the instance profile
  role = coalesce(
    aws_iam_role.ssm_ec2_role[count.index].instance_name,
    data.aws_iam_role.ssm_ec2_role.instance_name
  )
}