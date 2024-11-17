#---------------------------------------------------
# AWS DB subnet group
# Provides an RDS DB subnet group resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
#---------------------------------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  # Conditionally create the resource based on the 'enable_db_subnet_group' variable
  count = var.enable_db_subnet_group ? 1 : 0

  # The name for the DB subnet group. 
  # If 'db_subnet_group_name' is provided and 'db_subnet_group_name_prefix' is null, use 'db_subnet_group_name' (converted to lowercase).
  # Otherwise, set to null.
  name = var.db_subnet_group_name != "" && var.db_subnet_group_name_prefix == null ? lower(var.db_subnet_group_name) : null

  # Creates a unique name beginning with the specified prefix. Conflicts with name.
  # If 'db_subnet_group_name_prefix' is provided and not null and 'db_subnet_group_name' is empty, use 'db_subnet_group_name_prefix' (converted to lowercase).
  # Otherwise, set to null.
  name_prefix = var.db_subnet_group_name_prefix != null && var.db_subnet_group_name == "" ? lower(var.db_subnet_group_name_prefix) : null

  # The description for the DB subnet group.
  description = var.db_subnet_group_description

  # A list of VPC subnet IDs.
  subnet_ids = var.db_subnet_group_subnet_ids

  # Tags for the DB subnet group
  tags = merge(
    {
      # Set the 'Name' tag based on the subnet group name or prefix
      Name = var.db_subnet_group_name != "" ? lower(var.db_subnet_group_name) : lower(var.db_subnet_group_name_prefix)
    },
    var.tags
  )

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # No explicit dependencies on other resources
  depends_on = []
}
