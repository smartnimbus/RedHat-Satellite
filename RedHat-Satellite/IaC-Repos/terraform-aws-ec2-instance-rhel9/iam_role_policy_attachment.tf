#------------------------------------------------------------------------------------------------------
# Resource         : aws_iam_role_policy_attachment
# description      : Attaches a Managed IAM Policy to an IAM role
# module           : IAM (Identity & Access Management)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

#---------------------------------------------------
# AWS IAM Role Policy Attachment
# Attaches the SSM Managed Policy to the IAM role to enable SSM actions
# Only attaches policy if the IAM role was created in this configuration
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
#---------------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  # Conditionally create the resource if the IAM role was created in this configuration
  count = length(data.aws_iam_role.ssm_ec2_role) == 0 ? 1 : 0
  # The name of the IAM role to attach the policy to
  role = aws_iam_role.ssm_ec2_role.instance_name
  # The ARN of the policy to attach
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


