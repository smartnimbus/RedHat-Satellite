#------------------------------------------------------------------------------------------------------
# Resource         : aws_vpc_dhcp_options_association
# description      : Provides a VPC DHCP Options Association resource.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

# Conditional creation: Create the association only if a VPC is being created (`var.create_vpc`) AND custom DHCP options are enabled (`var.enable_dhcp_options`). Uses logical AND (`&&`) and the ternary operator.
resource "aws_vpc_dhcp_options_association" "this" {
  count = var.create_vpc && var.enable_dhcp_options ? 1 : 0

  # The ID of the VPC.
  vpc_id          = local.vpc_id
  # The ID of the DHCP options set. Retrieved from the `aws_vpc_dhcp_options` resource.
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}



