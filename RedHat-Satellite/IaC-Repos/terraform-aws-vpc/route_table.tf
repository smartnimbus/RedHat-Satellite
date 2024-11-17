#------------------------------------------------------------------------------------------------------
# Resource         : aws_route_table
# description      : Provides a resource to create a VPC routing table.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------
# Publiс Subnets
#------------------------------------------------------------------------------------------------------

locals {
  # Calculate the number of public route tables to create.  If multiple public route tables are desired (one per subnet), then the count is equal to the number of public subnets (`local.len_public_subnets`). Otherwise, only one public route table is created.  The ternary operator (`condition ? true_val : false_val`) is used here.
  num_public_route_tables = var.create_multiple_public_route_tables ? local.len_public_subnets : 1
}

resource "aws_route_table" "public" {
  # Creates public route tables. The number of route tables created depends on whether multiple public route tables are desired.
  count = local.create_public_subnets ? local.num_public_route_tables : 0

  # The VPC ID to create the route table in.
  vpc_id = local.vpc_id

  # Tags for the route table. The `merge` function combines multiple tag maps.
  tags = merge(
    var.default_tags, # Include default tags
    {
      "Name" = var.create_multiple_public_route_tables ? format(
        "${var.name}-${var.public_subnet_suffix}-%s",
        element(var.azs, count.index),
      ) : "${var.name}-${var.public_subnet_suffix}"
    },
    var.tags,
    var.public_route_table_tags,
  )
}


#------------------------------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------------------------------

# Creates route tables for private subnets.  The number of route tables matches the number of NAT gateways.
resource "aws_route_table" "private" {
  # Create private route tables if private subnets are being created (`local.create_private_subnets`) and the maximum subnet length is greater than 0 (`local.max_subnet_length > 0`).  The number of route tables created equals the number of NAT gateways (`local.nat_gateway_count`).
  count = local.create_private_subnets && local.max_subnet_length > 0 ? local.nat_gateway_count : 0

  vpc_id = local.vpc_id

  tags = merge(
    var.default_tags, # Include default tags
    {
      "Name" = var.single_nat_gateway ? "${var.name}-${var.private_subnet_suffix}" : format(
        "${var.name}-${var.private_subnet_suffix}-%s",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_route_table_tags,
  )
}


#------------------------------------------------------------------------------------------------------
# Database Subnets
#------------------------------------------------------------------------------------------------------

resource "aws_route_table" "database" {
  # Creates database route tables conditionally.
  # - If 'create_database_route_table' is true AND either 'single_nat_gateway' OR 'create_database_internet_gateway_route' is true: create 1 route table.  The logical OR operator is represented by `||`.
  # - Otherwise if create_database_route_table is true, create a route table for each database subnet (`local.len_database_subnets`).
  # - Otherwise, create no database route tables.  The ternary operator is used here.
  count = local.create_database_route_table ? var.single_nat_gateway || var.create_database_internet_gateway_route ? 1 : local.len_database_subnets : 0

  vpc_id = local.vpc_id

  tags = merge(
    var.default_tags, # Include default tags
    {
      "Name" = var.single_nat_gateway || var.create_database_internet_gateway_route ? "${var.name}-${var.database_subnet_suffix}" : format(
        "${var.name}-${var.database_subnet_suffix}-%s",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.database_route_table_tags,
  )
}
