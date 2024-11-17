#------------------------------------------------------------------------------------------------------
# Resource         : aws_vpc
# description      : Provides a VPC resource.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_vpc" "this" {
  # Conditional creation: Create the VPC only if the 'create_vpc' variable is true.
  # The ternary operator `condition ? true_val : false_val` is used here.
  count = var.create_vpc ? 1 : 0

  # IPv4 CIDR block: Set the CIDR block if not using IPAM.  If var.use_ipam_pool is true, this is set to null, as IPAM handles the CIDR allocation.
  cidr_block = var.use_ipam_pool ? null : var.cidr

  # IPAM settings (for IPv4): Used when allocating CIDR from an IP Address Management (IPAM) pool.
  ipv4_ipam_pool_id   = var.ipv4_ipam_pool_id
  ipv4_netmask_length = var.ipv4_netmask_length

  # IPv6 settings:
  # Automatically assigns an IPv6 CIDR block if enabled and not using IPAM.
  assign_generated_ipv6_cidr_block     = var.enable_ipv6 && !var.use_ipam_pool ? true : null
  ipv6_cidr_block                      = var.ipv6_cidr
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group

  # Instance tenancy:  The allowed tenancy of instances launched into the VPC.
  instance_tenancy = var.instance_tenancy

  # DNS settings: Control DNS support and hostnames.
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # Network address usage metrics: Whether to enable metrics.
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  # Tags for the instanc
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}
