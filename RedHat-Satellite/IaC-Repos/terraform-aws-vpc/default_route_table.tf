#------------------------------------------------------------------------------------------------------
# Resource         : aws_default_route_table
# description      : Provides a resource to manage a default route table of a VPC.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_default_route_table" "default" {
  # Conditional creation: Create the default route table only if both `create_vpc` and `manage_default_route_table` variables are true. Uses logical AND (`&&`) and the ternary operator (`condition ? true_val : false_val`).
  count = var.create_vpc && var.manage_default_route_table ? 1 : 0

  # The ID of the default route table.  Retrieved from the `aws_vpc` resource.
  default_route_table_id = aws_vpc.this[0].default_route_table_id
  # A list of virtual gateway IDs for propagation.
  propagating_vgws = var.default_route_table_propagating_vgws

  # Dynamically define routes. The `dynamic` block generates multiple `route` blocks based on the elements within `var.default_route_table_routes`.
  dynamic "route" {
    # Iterate over the `var.default_route_table_routes` variable (which should be a list of maps), creating one `route` block for each map.
    for_each = var.default_route_table_routes
    content {
      # Destination:  One of the following is required to specify the destination for the route.
      cidr_block = route.value.cidr_block
      # The IPv6 CIDR block. The `lookup` function retrieves the value of "ipv6_cidr_block" from the current route map (route.value). If not found, it defaults to `null`.
      ipv6_cidr_block = lookup(route.value, "ipv6_cidr_block", null)

      # Target: One of the following is required to specify the target for the route.
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  # Timeouts for creating and updating the route table.
  timeouts {
    create = "5m"
    update = "5m"
  }


  # Tags for the default route table. The `merge` function combines multiple maps.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = coalesce(var.default_route_table_name, "${var.name}-default") },
    var.tags,
    var.default_route_table_tags,
  )
}



