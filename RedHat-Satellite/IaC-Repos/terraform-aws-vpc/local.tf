locals {
  # Calculate the number of public subnets based on IPv4 and IPv6 prefixes.
  # The `length` function returns the number of elements in a list. The `max` function returns the largest value from a set of numbers.  This ensures that if either IPv4 or IPv6 subnets are defined, the correct count is used.
  len_public_subnets = max(length(var.public_subnets), length(var.public_subnet_ipv6_prefixes))

  # Calculate the number of private subnets (similar logic to public subnets).
  len_private_subnets = max(length(var.private_subnets), length(var.private_subnet_ipv6_prefixes))

  # Calculate the number of database subnets.
  len_database_subnets = max(length(var.database_subnets), length(var.database_subnet_ipv6_prefixes))

  # Determine the maximum subnet length among public, private, and database subnets. This helps manage the index for resources that iterate over the AZs.
  max_subnet_length = max(
    local.len_private_subnets,
    local.len_public_subnets,
    local.len_database_subnets,
  )

  # Get the VPC ID. The `try` function attempts to get the VPC ID from the `aws_vpc_ipv4_cidr_block_association` resource.  If that fails (e.g., if no association exists), it tries to get the ID from `aws_vpc.this`. If that also fails, it defaults to an empty string. This is primarily to manage dependencies for deleting secondary CIDR blocks which depend on the VPC and its subnets.
  vpc_id = try(aws_vpc_ipv4_cidr_block_association.this[0].vpc_id, aws_vpc.this[0].id, "")
}
