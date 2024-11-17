#------------------------------------------------------------------------------------------------------
# Resource         : aws_internet_gateway
# description      : Provides a resource to create a VPC Internet Gateway.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


resource "aws_internet_gateway" "this" {
  # Creates an internet gateway only if public subnets are being created and the `create_igw` variable is set to true.  Logical AND (`&&`) and the ternary operator are used.
  count = local.create_public_subnets && var.create_igw ? 1 : 0

  # The VPC ID to attach the internet gateway to. Retrieved from a local variable.
  vpc_id = local.vpc_id

  # Tags for the internet gateway. The `merge` function combines multiple tag maps.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}

