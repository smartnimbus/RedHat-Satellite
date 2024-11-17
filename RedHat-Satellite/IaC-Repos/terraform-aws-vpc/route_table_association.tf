#------------------------------------------------------------------------------------------------------
# Resource         : aws_route_table_association
# description      : Provides a resource to create an association between a route table and a subnet or a route table and an internet gateway or virtual private gateway.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------
# Publiс Subnets
#------------------------------------------------------------------------------------------------------


resource "aws_route_table_association" "public" {
  # Creates route table associations for public subnets. The number of associations created is equal to the number of public subnets (`local.len_public_subnets`) if public subnets are created (`local.create_public_subnets`). The ternary operator is used here.
  count = local.create_public_subnets ? local.len_public_subnets : 0

  # Associates the subnet with the route table.  The `element` function retrieves the subnet ID from the `aws_subnet.public` list based on the current `count.index`.
  subnet_id = element(aws_subnet.public[*].id, count.index)

  # The ID of the route table to associate. The `element` function is used to select the route table ID.  If `create_multiple_public_route_tables` is true, a separate route table is used for each subnet (selected by `count.index`). Otherwise, the first route table (index 0) is used for all public subnets. The ternary operator is used for this conditional logic.
  route_table_id = element(aws_route_table.public[*].id, var.create_multiple_public_route_tables ? count.index : 0)
}




#------------------------------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------------------------------

resource "aws_route_table_association" "private" {
  # Creates route table associations for private subnets (similar logic to public subnets).
  count = local.create_private_subnets ? local.len_private_subnets : 0

  # Subnet ID for the association. Uses `element` to select the subnet based on `count.index`.
  subnet_id = element(aws_subnet.private[*].id, count.index)

  # Route table ID. If `single_nat_gateway` is true, the first route table (index 0) is used. Otherwise, separate route tables are used based on the count index, presumably for multiple NAT gateways.
  route_table_id = element(
    aws_route_table.private[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}


#------------------------------------------------------------------------------------------------------
# Database Subnets
#------------------------------------------------------------------------------------------------------

resource "aws_route_table_association" "database" {
  # Creates route table associations for database subnets.
  count = local.create_database_subnets ? local.len_database_subnets : 0

  # Subnet ID to associate. Uses `element` and `count.index`.
  subnet_id = element(aws_subnet.database[*].id, count.index)

  # The route table ID.  More complex logic is used here with the coalescelist function and conditional selection based on `create_database_subnet_route_table`, `single_nat_gateway`, and `create_database_internet_gateway_route` variables.
  route_table_id = element(
    # The `coalescelist` function returns the first non-empty list.  This either selects the `aws_route_table.database` IDs (if a separate database route table is created) or falls back to the `aws_route_table.private` IDs.
    coalescelist(aws_route_table.database[*].id, aws_route_table.private[*].id),
    # The index for the route table is determined by several conditions:
    # 1. If a dedicated database route table is created (`create_database_subnet_route_table`)
    # 2. And either a single NAT gateway is used (`single_nat_gateway`) OR a database internet gateway route is created (`create_database_internet_gateway_route`):  Select the first route table (index 0). The logical OR (`||`) operator is used.
    # 3. Otherwise, use a separate route table based on the `count.index`.
    # 4. If no database subnet route is created, select based on `count.index`
    var.create_database_subnet_route_table ? var.single_nat_gateway || var.create_database_internet_gateway_route ? 0 : count.index : count.index,
  )
}
