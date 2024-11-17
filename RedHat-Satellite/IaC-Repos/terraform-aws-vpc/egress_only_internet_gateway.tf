#------------------------------------------------------------------------------------------------------
# Resource         : aws_egress_only_internet_gateway
# description      : Provides a resource to create an egress-only Internet gateway.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_egress_only_internet_gateway" "this" {
  # Creates an egress-only internet gateway if several conditions are met:
  # - A VPC is being created (`var.create_vpc`).
  # - The `create_egress_only_igw` variable is true.
  # - IPv6 is enabled (`var.enable_ipv6`).
  # - The maximum subnet length is greater than 0 (`local.max_subnet_length > 0`).
  # Uses logical AND (`&&`) and the ternary operator.
  count = var.create_vpc && var.create_egress_only_igw && var.enable_ipv6 && local.max_subnet_length > 0 ? 1 : 0

  # The ID of the VPC.  Retrieved from a local variable.
  vpc_id = local.vpc_id

  # Tags for the egress-only internet gateway.  Uses `merge` to combine tag maps.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}
