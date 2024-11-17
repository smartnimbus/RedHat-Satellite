#------------------------------------------------------------------------------------------------------
# Resource         : aws_vpc_ipv4_cidr_block_association
# description      : Associate additional IPv4 CIDR blocks with a VPC
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  # Creates secondary CIDR block associations for the VPC.  The number of associations created equals the number of secondary CIDR blocks provided, but only if a VPC is being created (`var.create_vpc`) and there are secondary CIDR blocks defined (length of `var.secondary_cidr_blocks` is greater than 0).  Uses the `length` function, logical AND (`&&`), and the ternary operator (`condition ? true_val : false_val`).
  count = var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  # The ID of the VPC.  Explicitly uses `aws_vpc.this[0].id`.  The comment indicates this is intentional and not to be replaced with a local variable. This is likely for dependency management to ensure the VPC is created before the associations.
  vpc_id = aws_vpc.this[0].id

  # The IPv4 CIDR block to associate with the VPC.  Uses the `element` function to select a CIDR block from the `secondary_cidr_blocks` list based on the current `count.index`.  This dynamically assigns each secondary CIDR block to a separate association.
  cidr_block = element(var.secondary_cidr_blocks, count.index)
}