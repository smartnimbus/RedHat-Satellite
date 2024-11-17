#------------------------------------------------------------------------------------------------------
# Resource         : aws_default_network_acl
# description      : Manage a default network ACL.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_default_network_acl" "this" {
  # Conditional creation: The default Network ACL is created only if both `create_vpc` AND `manage_default_network_acl` are true.
  # The `&&` operator represents a logical AND. The ternary operator (`condition ? true_val : false_val`) is used.
  count = var.create_vpc && var.manage_default_network_acl ? 1 : 0

  # The ID of the default network ACL.  This is retrieved from the `aws_vpc` resource.
  default_network_acl_id = aws_vpc.this[0].default_network_acl_id

  # The `subnet_ids` attribute is intentionally set to `null` and ignored using a lifecycle block. 
  # By default, the default Network ACL is associated with all subnets in the VPC.  Explicitly managing `subnet_ids` here could cause unexpected behavior.
  subnet_ids = null

  # Dynamically define ingress rules. The `dynamic` block creates multiple `ingress` blocks based on the elements in the `var.default_network_acl_ingress` list.
  dynamic "ingress" {
    # The `for_each` expression iterates over the `var.default_network_acl_ingress` variable, which should be a list of maps.
    for_each = var.default_network_acl_ingress
    content {
      # The `action` attribute specifies whether to "allow" or "deny" traffic.
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null) # The `cidr_block` attribute specifies the IPv4 CIDR block to match. The `lookup` function retrieves the value associated with the "cidr_block" key from the current element (ingress.value) of the `var.default_network_acl_ingress` list.  If "cidr_block" isn't defined in the map, it defaults to `null`.
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }

  # Dynamically define egress rules.  Similar structure and logic to the `ingress` block above.
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  # Set tags for the Default Network ACL. The `merge` function combines maps.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = coalesce(var.default_network_acl_name, "${var.name}-default") },
    var.tags,
    var.default_network_acl_tags,
  )

  # Lifecycle management: Ignore changes to the `subnet_ids` attribute to avoid unintended disassociations.
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}