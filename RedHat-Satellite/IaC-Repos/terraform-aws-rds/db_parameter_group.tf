#---------------------------------------------------
# AWS DB parameter group
# Provides an RDS DB parameter group resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
#---------------------------------------------------
resource "aws_db_parameter_group" "db_parameter_group" {
  # Conditionally create the resource based on the 'enable_db_parameter_group' variable
  count = var.enable_db_parameter_group ? 1 : 0

  # Set the parameter group name based on provided variables, prioritizing 'db_parameter_group_name'
  name = var.db_parameter_group_name != "" ? lower(var.db_parameter_group_name) : null
  # Set the parameter group name prefix based on provided variables
  name_prefix = var.db_parameter_group_name_prefix != "" ? lower(var.db_parameter_group_name_prefix) : null
  description = var.db_parameter_group_description != "" ? lower(var.db_parameter_group_description) : null
  # Set the parameter group family based on provided variables
  family = var.db_parameter_group_family != "" ? var.db_parameter_group_family : lookup(var.db_group_family, var.db_instance_engine)

  # Dynamic block for defining parameters within the parameter group
  dynamic "parameter" {
    iterator = parameter
    for_each = var.db_parameter_group_parameters

    content {
      name         = lookup(parameter.value, "name", null)
      value        = lookup(parameter.value, "value", null)
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  # Dynamic block for setting a timeout for the delete operation
  tags = merge(
    {
      Name = var.db_parameter_group_name != "" && var.db_parameter_group_name_prefix == "" ? lower(var.db_parameter_group_name) : lower(var.db_parameter_group_name_prefix)
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
