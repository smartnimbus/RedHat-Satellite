#------------------------------------------------------------------------------------------------------
# Resource         : aws_route
# description      : Provides a resource to create a routing entry in a VPC routing table.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------
# Publiс Subnets
#------------------------------------------------------------------------------------------------------


resource "aws_route" "public_internet_gateway" {
  # Creates a route to the internet gateway for public subnets.  A route is created for each public route table using the count.index.
  # The number of routes created equals the number of public route tables (`local.num_public_route_tables`) if public subnets are being created (`local.create_public_subnets`) and an internet gateway is being created (`var.create_igw`). Uses logical AND (`&&`) and the ternary operator.
  count = local.create_public_subnets && var.create_igw ? local.num_public_route_tables : 0

  # The ID of the route table to add the route to. The element function retrieves based on count.index.
  route_table_id = aws_route_table.public[count.index].id
  # The destination CIDR block (0.0.0.0/0 for all IPv4 addresses).
  destination_cidr_block = "0.0.0.0/0"
  # The ID of the internet gateway.
  gateway_id = aws_internet_gateway.this[0].id

  # Timeout for route creation.
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_ipv6" {
  # Creates an IPv6 route to the internet gateway for public subnets. Similar to the IPv4 route above. Created for each public route table.
  # Conditional creation: public subnets must be created, an IGW must be created, and IPv6 must be enabled.
  count = local.create_public_subnets && var.create_igw && var.enable_ipv6 ? local.num_public_route_tables : 0

  route_table_id              = aws_route_table.public[count.index].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this[0].id
}



#------------------------------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------------------------------



#------------------------------------------------------------------------------------------------------
# Database Subnets
#------------------------------------------------------------------------------------------------------


resource "aws_route" "database_internet_gateway" {
  # Creates a route to the internet gateway for database subnets.  Only created if specific conditions are met.

  # Conditional creation:
  # - A database route table must be created (`local.create_database_route_table`).
  # - An internet gateway must be created (`var.create_igw`).
  # - A database internet gateway route must be explicitly requested (`var.create_database_internet_gateway_route`).
  # - A database NAT gateway route must *not* be requested (`!var.create_database_nat_gateway_route`).
  count = local.create_database_route_table && var.create_igw && var.create_database_internet_gateway_route && !var.create_database_nat_gateway_route ? 1 : 0

  route_table_id         = aws_route_table.database[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "database_nat_gateway" {
  # Creates a route to a NAT gateway for database subnets if several conditions are met.

  # Conditional creation:  Database route table, database Nat gateway route requested, Nat gateway enabled. Creates multiple routes, either 1 or number of database subnets based on single_nat_gateway.
  count = local.create_database_route_table && !var.create_database_internet_gateway_route && var.create_database_nat_gateway_route && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : local.len_database_subnets : 0

  # The route table ID. Selected using element and count.index.
  route_table_id         = element(aws_route_table.database[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  # ID of the NAT gateway. Selected dynamically based on count.index.
  nat_gateway_id = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "database_dns64_nat_gateway" {
  # Creates a DNS64 NAT gateway route for database subnets for IPv6 traffic if several conditions are met.

  # Conditional creation:  Database route table must be created, no database internet gateway, NAT gateway enabled and IPv6 enabled and Private DNS64 enabled.  Count determined by single_nat_gateway.
  count = local.create_database_route_table && !var.create_database_internet_gateway_route && var.create_database_nat_gateway_route && var.enable_nat_gateway && var.enable_ipv6 && var.private_subnet_enable_dns64 ? var.single_nat_gateway ? 1 : local.len_database_subnets : 0

  route_table_id              = element(aws_route_table.database[*].id, count.index)
  destination_ipv6_cidr_block = "64:ff9b::/96"
  nat_gateway_id              = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "database_ipv6_egress" {
  # Creates an IPv6 egress route for database subnets if certain conditions are met.

  # Conditional creation: database route table, egress only IGW created, IPv6 enabled and database internet gateway route creation is requested.
  count = local.create_database_route_table && var.create_egress_only_igw && var.enable_ipv6 && var.create_database_internet_gateway_route ? 1 : 0

  route_table_id              = aws_route_table.database[0].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

#------------------------------------------------------------------------------------------------------
# Internet Gateway
#------------------------------------------------------------------------------------------------------

resource "aws_route" "private_ipv6_egress" {
  # Creates a route for IPv6 egress traffic from private subnets.
  # The count is determined by multiple conditions and the number of NAT gateways:
  # - VPC creation (`var.create_vpc`), Egress only IGW creation (`var.create_egress_only_igw`) , IPv6 enabled (`var.enable_ipv6`) and number of private subnets is greater than 0 (`local.len_private_subnets > 0`).
  # - The number of NAT gateways (`local.nat_gateway_count`). This creates one route per NAT gateway.  The ternary operator is used.
  count = var.create_vpc && var.create_egress_only_igw && var.enable_ipv6 && local.len_private_subnets > 0 ? local.nat_gateway_count : 0

  # The ID of the route table to add the route to. The `element` function retrieves the route table ID based on the current count index.
  route_table_id = element(aws_route_table.private[*].id, count.index)

  # The destination IPv6 CIDR block (::/0 for all IPv6 addresses).
  destination_ipv6_cidr_block = "::/0"

  # The ID of the egress-only internet gateway.  `element` retrieves the ID from the list of egress-only gateways.
  egress_only_gateway_id = element(aws_egress_only_internet_gateway.this[*].id, 0)
}


#------------------------------------------------------------------------------------------------------
# NAT Gateway
#------------------------------------------------------------------------------------------------------


resource "aws_route" "private_nat_gateway" {
  # Creates routes to the NAT gateway for private subnets.
  # Conditional creation: create VPC, enable NAT gateway and enable private NAT gateway route. Number of routes created equals the number of NAT gateways.
  count = var.create_vpc && var.enable_nat_gateway && var.create_private_nat_gateway_route ? local.nat_gateway_count : 0

  # The route table ID. The `element` function selects the appropriate private route table based on the `count.index`.
  route_table_id = element(aws_route_table.private[*].id, count.index)
  # The destination CIDR block.  This variable specifies which traffic should be routed through the NAT gateway.
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  # The ID of the NAT gateway. The `element` function selects the correct NAT gateway based on the `count.index`.
  nat_gateway_id = element(aws_nat_gateway.this[*].id, count.index)

  # Timeout configuration for route creation.
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_dns64_nat_gateway" {
  # Creates a DNS64 NAT gateway route for private subnets. This enables IPv6-only instances in private subnets to access IPv4 resources via DNS64 and NAT64.

  # Conditional creation: VPC creation, NAT gateway enabled, IPv6 enabled and Private subnet DNS64 enabled.  Count determined by number of Nat gateways.
  count = var.create_vpc && var.enable_nat_gateway && var.enable_ipv6 && var.private_subnet_enable_dns64 ? local.nat_gateway_count : 0

  route_table_id              = element(aws_route_table.private[*].id, count.index)
  destination_ipv6_cidr_block = "64:ff9b::/96"
  nat_gateway_id              = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}
