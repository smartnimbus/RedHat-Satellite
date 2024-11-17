#------------------------------------------------------------------------------------------------------
# Resource         : aws_nat_gateway
# description      : Provides a resource to create a VPC NAT Gateway.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


locals {
  # Determines the number of NAT gateways to create.
  # The ternary operator is used multiple times for conditional logic:
  # - If `single_nat_gateway` is true, create 1 NAT gateway.
  # - Otherwise, if `one_nat_gateway_per_az` is true, create a NAT gateway for each availability zone (length of `var.azs`).
  # - Otherwise, create a NAT gateway for each subnet (using the value of `local.max_subnet_length`).
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length

  # Determines the allocation IDs or Elastic IPs (EIPs) to use for the NAT gateways.
  # - If `reuse_nat_ips` is true, use the provided `external_nat_ip_ids` (which should be a list of existing EIP allocation IDs).
  # - Otherwise, create new EIPs using the `aws_eip.nat` resource and get their IDs.
  nat_gateway_ips = var.reuse_nat_ips ? var.external_nat_ip_ids : aws_eip.nat[*].id
}

resource "aws_nat_gateway" "this" {
  # Conditional creation:  Creates NAT gateways only if `create_vpc` AND `enable_nat_gateway` are true. Uses the logical AND operator (`&&`) and ternary operator.
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  # The allocation ID of the Elastic IP address to associate with the NAT gateway.
  # Uses the `element` function to select an EIP from the `local.nat_gateway_ips` list. The index is determined by whether or not we create single nat gateway.
  allocation_id = element(
    local.nat_gateway_ips,
    var.single_nat_gateway ? 0 : count.index,
  )

  # The subnet ID to launch the NAT gateway in.  Retrieves the subnet ID based on count index using the element function from `aws_subnet.public`.  Similar logic to allocation_id.
  subnet_id = element(
    aws_subnet.public[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )

  # Tags for the NAT gateway. Uses the `merge` function.
  tags = merge(
    var.default_tags, # Include default tags
    {
      "Name" = format(
        "${var.name}-%s",
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
    var.nat_gateway_tags,
  )

  # Explicit dependency on the internet gateway. Ensures the internet gateway is created before the NAT gateway.
  depends_on = [aws_internet_gateway.this]
}

#------------------------------------------------------------------------------------------------------
# Resource         : aws_eip
# description      : Provides an Elastic IP resource.
# module           : EC2 (Elastic Compute Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_eip" "nat" {
  # Creates Elastic IP addresses for the NAT gateways. Only created if:
  # - A VPC is being created (`var.create_vpc`).
  # - NAT gateways are enabled (`var.enable_nat_gateway`).
  # - NAT IPs are *not* being reused (`!var.reuse_nat_ips`).  This ensures we create new EIPs only when they're needed. The `!` operator represents logical NOT.
  count = var.create_vpc && var.enable_nat_gateway && !var.reuse_nat_ips ? local.nat_gateway_count : 0

  domain = "vpc"

  # Tags for the Elastic IP addresses.  Uses the `merge` function.
  tags = merge(
    var.default_tags, # Include default tags
    {
      "Name" = format(
        "${var.name}-%s",
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
    var.nat_eip_tags,
  )

  # Explicit dependency on the internet gateway.  Ensures the internet gateway is created before the EIPs.
  depends_on = [aws_internet_gateway.this]
}