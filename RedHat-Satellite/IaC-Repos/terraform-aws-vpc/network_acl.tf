#------------------------------------------------------------------------------------------------------
# Resource         : aws_network_acl
# description      : Provides an network ACL resource.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------
# Public Network ACLs
#------------------------------------------------------------------------------------------------------

resource "aws_network_acl" "public" {
  # Creates a Network ACL for public subnets if the following conditions are met:
  # - Public subnets are being created (`local.create_public_subnets`).
  # - A dedicated Network ACL is requested for public subnets (`var.public_dedicated_network_acl`).
  # Uses logical AND (`&&`) and the ternary operator (`condition ? true_val : false_val`).
  count = local.create_public_subnets && var.public_dedicated_network_acl ? 1 : 0

  # The VPC ID.
  vpc_id = local.vpc_id

  # A list of subnet IDs to associate with the Network ACL. The `[*]` splat operator expands the list of subnet IDs from the `aws_subnet` resource.
  subnet_ids = aws_subnet.public[*].id

  # Tags for the Network ACL. Uses the `merge` function to combine tag maps.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = "${var.name}-${var.public_subnet_suffix}" },
    var.tags,
    var.public_acl_tags,
  )
}


#------------------------------------------------------------------------------------------------------
# Private Network ACLs
#------------------------------------------------------------------------------------------------------

locals {
  # Determines whether to create a private Network ACL.  This is controlled by the `create_private_subnets` local variable and the `private_dedicated_network_acl` input variable. Uses logical AND (`&&`).
  create_private_network_acl = local.create_private_subnets && var.private_dedicated_network_acl
}

resource "aws_network_acl" "private" {
  # Creates a Network ACL for private subnets if `create_private_network_acl` is true.  Uses the ternary operator.
  count = local.create_private_network_acl ? 1 : 0

  # The VPC ID.
  vpc_id     = local.vpc_id
  subnet_ids = aws_subnet.private[*].id

  # Merges tags using the `merge` function.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = "${var.name}-${var.private_subnet_suffix}" },
    var.tags,
    var.private_acl_tags,
  )
}


#------------------------------------------------------------------------------------------------------
# Database Network ACLs
#------------------------------------------------------------------------------------------------------

locals {
  # Determines whether to create a dedicated database Network ACL. Similar to private Network ACL local.
  create_database_network_acl = local.create_database_subnets && var.database_dedicated_network_acl
}

resource "aws_network_acl" "database" {
  # Creates a Network ACL for database subnets conditionally. The ternary operator (`condition ? true_val : false_val`) is used.
  count = local.create_database_network_acl ? 1 : 0

  # The VPC ID.
  vpc_id = local.vpc_id

  # The list of subnet IDs to associate with the Network ACL. The splat operator (`[*]`) expands the list of database subnet IDs from the `aws_subnet.database` resource.
  subnet_ids = aws_subnet.database[*].id

  # Tags for the database Network ACL. Uses the `merge` function to combine maps.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = "${var.name}-${var.database_subnet_suffix}" },
    var.tags,
    var.database_acl_tags,
  )
}

