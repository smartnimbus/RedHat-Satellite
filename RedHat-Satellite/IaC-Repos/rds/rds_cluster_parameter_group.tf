#---------------------------------------------------
# AWS RDS cluster parameter group
# Provides an RDS Cluster Parameter Group resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group
#---------------------------------------------------
resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  # Conditionally create the resource based on the 'enable_rds_cluster_parameter_group' variable
  count = var.enable_rds_cluster_parameter_group ? 1 : 0

  # The name of the DB cluster parameter group.
  # If 'rds_cluster_parameter_group_name' is provided, use that value (converted to lowercase).
  # Otherwise, set to null.
  name = var.rds_cluster_parameter_group_name != "" ? lower(var.rds_cluster_parameter_group_name) : null

  # Creates a unique name beginning with the specified prefix. Conflicts with name.
  # If 'rds_cluster_parameter_group_name_prefix' is provided, use that value (converted to lowercase).
  # Otherwise, set to null.
  name_prefix = var.rds_cluster_parameter_group_name_prefix != "" ? lower(var.rds_cluster_parameter_group_name_prefix) : null

  # The description for the DB cluster parameter group.
  description = var.rds_cluster_parameter_group_description

  # The family of the DB cluster parameter group.
  # If 'rds_cluster_parameter_group_family' is provided, use that value.
  # Otherwise, look up the family in the 'var.db_group_family' map based on the 'var.rds_cluster_engine' value.
  family = var.rds_cluster_parameter_group_family != "" ? var.rds_cluster_parameter_group_family : lookup(var.db_group_family, var.rds_cluster_engine)

  # Dynamic block for defining parameters within the parameter group
  dynamic "parameter" {
    iterator = parameter
    # Iterate over the 'rds_cluster_parameter_group_parameters' variable (should be a list of maps)
    for_each = var.rds_cluster_parameter_group_parameters

    content {
      name         = lookup(parameter.value, "name", null)
      value        = lookup(parameter.value, "value", null)
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  # Tags for the DB cluster parameter group
  tags = merge(
    {
      Name = var.rds_cluster_parameter_group_name != "" && var.rds_cluster_parameter_group_name_prefix == "" ? lower(var.rds_cluster_parameter_group_name) : lower(var.rds_cluster_parameter_group_name_prefix)
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
