#------------------------------------------------------------------------------------------------------
# Resource         : aws_subnet
# description      : Provides an VPC subnet resource.
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------
# Publiс Subnets
#------------------------------------------------------------------------------------------------------

locals {
  # Determines whether public subnets should be created. This depends on VPC creation and `len_public_subnets` being greater than 0. Uses logical AND (`&&`).
  create_public_subnets = var.create_vpc && local.len_public_subnets > 0
}

resource "aws_subnet" "public" {
  # Creates public subnets. The number of subnets is determined dynamically.
  # The conditions are:
  # - Public subnets are being created (local.create_public_subnets).
  # - Either one NAT gateway per AZ is NOT being used, OR the number of public subnets is greater or equals to the number of availability zones.  This ensures enough subnets for NAT gateways if needed.
  count = local.create_public_subnets && (!var.one_nat_gateway_per_az || local.len_public_subnets >= length(var.azs)) ? local.len_public_subnets : 0

  # Assign IPv6 address on creation. If IPv6 and IPv6 native are enabled, assign it on creation. Otherwise use the variable value.
  assign_ipv6_address_on_creation                = var.enable_ipv6 && var.public_subnet_ipv6_native ? true : var.public_subnet_assign_ipv6_address_on_creation
  # The availability zone for the subnet.  Uses a regex and the `element` function to determine if AZ or AZ ID should be used. The ternary operator (`condition ? true_val : false_val`) is used.
  availability_zone                              = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  # IPv4 CIDR block for the subnet. If using IPv6 native subnets the IPv4 cidr_block must be null. Otherwise, get CIDR from variable based on count.index. The `concat` function adds an empty string to handle cases where `var.public_subnets` might be empty, preventing errors.
  cidr_block                                     = var.public_subnet_ipv6_native ? null : element(concat(var.public_subnets, [""]), count.index)
  # Enable DNS64 for the subnet if IPv6 and DNS64 are enabled. Uses logical AND (`&&`).
  enable_dns64                                   = var.enable_ipv6 && var.public_subnet_enable_dns64
  # Enable AAAA record on launch based on IPv6 and configuration variables.
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.public_subnet_enable_resource_name_dns_aaaa_record_on_launch
  # Enable A record on launch if not IPv6 native and based on a variable.
  enable_resource_name_dns_a_record_on_launch    = !var.public_subnet_ipv6_native && var.public_subnet_enable_resource_name_dns_a_record_on_launch
  # The IPv6 CIDR block. Conditionally assigned if ipv6 is enabled and ipv6 prefixes length is greater than 0. `cidrsubnet` calculates the subnet CIDR.
  ipv6_cidr_block                                = var.enable_ipv6 && length(var.public_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, var.public_subnet_ipv6_prefixes[count.index]) : null
  # Enable IPv6 native for the subnet based on IPv6 and configuration variables.
  ipv6_native                                    = var.enable_ipv6 && var.public_subnet_ipv6_native
  # Map public IP on launch based on configuration variable.
  map_public_ip_on_launch                        = var.map_public_ip_on_launch
  private_dns_hostname_type_on_launch            = var.public_subnet_private_dns_hostname_type_on_launch
  vpc_id                                         = local.vpc_id

  tags = merge(
    var.default_tags, # Include default tags
    {
      Name = try(
        var.public_subnet_names[count.index],
        format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index))
      )
    },
    var.tags,
    var.public_subnet_tags,
    # AZ-specific tags for the subnet using lookup.
    lookup(var.public_subnet_tags_per_az, element(var.azs, count.index), {}),
  )
}



#------------------------------------------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------------------------------------------

locals {
  # Determines whether private subnets will be created.  This depends on VPC creation (`var.create_vpc`) and the length of private subnets being greater than 0 (`local.len_private_subnets > 0`). Uses logical AND (`&&`).
  create_private_subnets = var.create_vpc && local.len_private_subnets > 0
}

resource "aws_subnet" "private" {
  # Creates private subnets.  The number of subnets created equals the number of private subnets specified (`local.len_private_subnets`) if the `create_private_subnets` local is true. The ternary operator (`condition ? true_val : false_val`) is used.
  count = local.create_private_subnets ? local.len_private_subnets : 0

  # Assigns IPv6 addresses on creation based on IPv6 and IPv6 native subnet settings.
  assign_ipv6_address_on_creation                = var.enable_ipv6 && var.private_subnet_ipv6_native ? true : var.private_subnet_assign_ipv6_address_on_creation
  # The availability zone for the subnet. Uses regex, element, and count.index. The regex checks if the AZ string starts with two lowercase letters followed by a hyphen. If it does, it uses the AZ from var.azs, otherwise uses the AZ ID (for Outposts). The ternary operator is used.
  availability_zone                              = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  # The IPv4 CIDR block for the subnet. If IPv6 native is enabled, the CIDR block is set to null (as the subnet will only have an IPv6 CIDR block). Otherwise, it retrieves the CIDR block from the `private_subnets` variable based on `count.index`.  The `concat` function is used to add an empty string to the list of CIDR blocks. This handles cases where the `private_subnets` list might be empty, preventing potential errors.
  cidr_block                                     = var.private_subnet_ipv6_native ? null : element(concat(var.private_subnets, [""]), count.index)
  # Enable DNS64 for the subnet. DNS64 allows IPv6-only instances to access IPv4 resources using NAT64. This depends on `enable_ipv6` and `private_subnet_enable_dns64` variables, using logical AND (`&&`).
  enable_dns64                                   = var.enable_ipv6 && var.private_subnet_enable_dns64
  # Enable Resource name DNS AAAA record on launch.
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.private_subnet_enable_resource_name_dns_aaaa_record_on_launch
  # Enable Resource name DNS A record on launch if not IPv6 native. Uses logical NOT (`!`).
  enable_resource_name_dns_a_record_on_launch    = !var.private_subnet_ipv6_native && var.private_subnet_enable_resource_name_dns_a_record_on_launch
  # The IPv6 CIDR block. Calculated using cidrsubnet function if IPv6 and `private_subnet_ipv6_prefixes` are enabled.
  ipv6_cidr_block                                = var.enable_ipv6 && length(var.private_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, var.private_subnet_ipv6_prefixes[count.index]) : null
  ipv6_native                                    = var.enable_ipv6 && var.private_subnet_ipv6_native
  private_dns_hostname_type_on_launch            = var.private_subnet_private_dns_hostname_type_on_launch
  vpc_id                                         = local.vpc_id

  tags = merge(
    var.default_tags, # Include default tags
    {
      # "Name" tag. `try` attempts to get the name from the `private_subnet_names` list. If the index is out of range (i.e., no name provided), then it uses the `format` function with string templating to generate the name from the VPC name, subnet suffix, and AZ.  The `element` function dynamically selects the availability zone based on count.index.
      Name = try(
        var.private_subnet_names[count.index],
        format("${var.name}-${var.private_subnet_suffix}-%s", element(var.azs, count.index))
      )
    },
    var.tags,
    var.private_subnet_tags,
    # Per-AZ tags using lookup, element, and count.index.
    lookup(var.private_subnet_tags_per_az, element(var.azs, count.index), {}),
  )
}


#------------------------------------------------------------------------------------------------------
# Database Subnets
#------------------------------------------------------------------------------------------------------

locals {
  # Determines if database subnets should be created.  Based on VPC creation (`var.create_vpc`) and the number of database subnets (`local.len_database_subnets`) being greater than zero.  Uses logical AND (`&&`).
  create_database_subnets     = var.create_vpc && local.len_database_subnets > 0
  # Determines if a database route table should be created. Based on `create_database_subnets` and `var.create_database_subnet_route_table`.
  create_database_route_table = local.create_database_subnets && var.create_database_subnet_route_table
}

resource "aws_subnet" "database" {
  # Creates database subnets. Number of subnets created is determined by `local.len_database_subnets` if `local.create_database_subnets` is true. Uses the ternary operator.
  count = local.create_database_subnets ? local.len_database_subnets : 0

  # Assign IPv6 address on creation.  Conditional: if both IPv6 is enabled and database subnets are IPv6-native, assign on creation. Otherwise, use the value of the dedicated variable.
  assign_ipv6_address_on_creation                = var.enable_ipv6 && var.database_subnet_ipv6_native ? true : var.database_subnet_assign_ipv6_address_on_creation
  # The availability zone or availability zone ID. Uses regex, element, and count.index.  The availability zone is used unless the AZ name doesn't match a regex (in which case the AZ ID is used). (For Local Zones and Outposts, the AZ ID should be provided)
  availability_zone                              = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id                           = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  # The IPv4 CIDR block.  If the database subnets are IPv6 native (`var.database_subnet_ipv6_native`), this is set to null. Otherwise, the CIDR is selected from the `database_subnets` list using `element` and `count.index`. The `concat` function handles the case where the input list might be empty.
  cidr_block                                     = var.database_subnet_ipv6_native ? null : element(concat(var.database_subnets, [""]), count.index)
  enable_dns64                                   = var.enable_ipv6 && var.database_subnet_enable_dns64
  # Configure DNS records.
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.database_subnet_enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = !var.database_subnet_ipv6_native && var.database_subnet_enable_resource_name_dns_a_record_on_launch
  # IPv6 CIDR block. Calculated using `cidrsubnet` if IPv6 is enabled and prefixes are provided.
  ipv6_cidr_block                                = var.enable_ipv6 && length(var.database_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, var.database_subnet_ipv6_prefixes[count.index]) : null
  ipv6_native                                    = var.enable_ipv6 && var.database_subnet_ipv6_native
  private_dns_hostname_type_on_launch            = var.database_subnet_private_dns_hostname_type_on_launch
  vpc_id                                         = local.vpc_id

  # Tags for the database subnets. Uses the `merge` function.
  tags = merge(
    var.default_tags, # Include default tags
    {
      Name = try(
        var.database_subnet_names[count.index],
        format("${var.name}-${var.database_subnet_suffix}-%s", element(var.azs, count.index), )
      )
    },
    var.tags,
    var.database_subnet_tags,
  )
}

#------------------------------------------------------------------------------------------------------
# Resource         : aws_db_subnet_group
# description      : Provides an RDS DB subnet group resource.
# module           : RDS (Relational Database)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_db_subnet_group" "database" {
  # Creates a database subnet group.  Conditional based on database subnet creation and create_database_subnet_group variable.
  count = local.create_database_subnets && var.create_database_subnet_group ? 1 : 0

  # The name of the subnet group. The `coalesce` function uses the provided `database_subnet_group_name` or defaults to the VPC `name`. The `lower` function converts the name to lowercase.
  name        = lower(coalesce(var.database_subnet_group_name, var.name))
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.database[*].id

  tags = merge(
    var.default_tags, # Include default tags
    {
      "Name" = lower(coalesce(var.database_subnet_group_name, var.name))
    },
    var.tags,
    var.database_subnet_group_tags,
  )
}


