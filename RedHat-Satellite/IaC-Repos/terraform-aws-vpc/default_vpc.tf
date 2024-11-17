#------------------------------------------------------------------------------------------------------
# Resource         : aws_default_vpc
# description      : Manage a default VPC resource.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


resource "aws_default_vpc" "this" {
  # Conditional creation: Manages the default VPC only if `manage_default_vpc` is true.  Uses the ternary operator (`condition ? true_val : false_val`).
  count = var.manage_default_vpc ? 1 : 0

  # Whether DNS support is enabled for the default VPC.
  enable_dns_support = var.default_vpc_enable_dns_support
  # Whether DNS hostnames are enabled for the default VPC.
  enable_dns_hostnames = var.default_vpc_enable_dns_hostnames

  # Tags for the default VPC. Uses the `merge` function to combine multiple tag maps.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = coalesce(var.default_vpc_name, "default") },
    var.tags,
    var.default_vpc_tags,
  )
}

resource "aws_default_security_group" "this" {
  # Conditional creation: Manages the default security group only if both `create_vpc` and `manage_default_security_group` are true. Uses logical AND (`&&`) and a ternary operator.
  count = var.create_vpc && var.manage_default_security_group ? 1 : 0
  # The ID of the VPC. Retrieved from the `aws_vpc` resource.
  vpc_id = aws_vpc.this[0].id

  # Dynamically create ingress rules.
  dynamic "ingress" {
    # Iterate over the `var.default_security_group_ingress` variable (a list of maps).
    for_each = var.default_security_group_ingress
    content {
      # Allow access from the security group itself.  The `lookup` function retrieves the value of "self" from the current element in the list, defaulting to `null`.
      self = lookup(ingress.value, "self", null)
      # List of CIDR blocks.  The `compact` function removes empty strings from the list created by `split`.
      # Splits the "cidr_blocks" string by commas and removes empty strings.
      cidr_blocks      = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(ingress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(ingress.value, "security_groups", "")))
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", 0)
      to_port          = lookup(ingress.value, "to_port", 0)
      protocol         = lookup(ingress.value, "protocol", "-1")
    }
  }
  # Dynamically create egress rules (similar to ingress rules).
  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self             = lookup(egress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(egress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(egress.value, "security_groups", "")))
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", 0)
      to_port          = lookup(egress.value, "to_port", 0)
      protocol         = lookup(egress.value, "protocol", "-1")
    }
  }

  # Tags for the default security group. Uses the `merge` function.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = coalesce(var.default_security_group_name, "${var.name}-default") },
    var.tags,
    var.default_security_group_tags,
  )
}

