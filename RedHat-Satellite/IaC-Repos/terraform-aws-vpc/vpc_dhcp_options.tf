#------------------------------------------------------------------------------------------------------
# Resource         : aws_vpc_dhcp_options
# description      : Provides a VPC DHCP Options resource.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_vpc_dhcp_options" "this" {
  # Creates a custom DHCP options set if both create_vpc and enable_dhcp_options variables are true. The ternary operator (`condition ? true_val : false_val`) and logical AND (`&&`) are used.
  count = var.create_vpc && var.enable_dhcp_options ? 1 : 0

  # The domain name to be used by DHCP clients.
  domain_name                       = var.dhcp_options_domain_name
  # A list of DNS server IP addresses.
  domain_name_servers               = var.dhcp_options_domain_name_servers
  # A list of NTP server IP addresses.
  ntp_servers                       = var.dhcp_options_ntp_servers
  # A list of NetBIOS name server IP addresses.
  netbios_name_servers              = var.dhcp_options_netbios_name_servers
  # The NetBIOS node type (1, 2, 4, or 8).
  netbios_node_type                 = var.dhcp_options_netbios_node_type
  # The IPv6 address preferred lease time in seconds.
  ipv6_address_preferred_lease_time = var.dhcp_options_ipv6_address_preferred_lease_time

  # Tags for the DHCP options set.  Uses the `merge` function to combine tag maps.
  tags = merge(
    var.default_tags, # Include default tags
    { "Name" = var.name },
    var.tags,
    var.dhcp_options_tags,
  )
}