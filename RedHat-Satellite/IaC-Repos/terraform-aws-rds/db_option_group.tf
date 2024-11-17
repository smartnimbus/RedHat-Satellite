#---------------------------------------------------
# AWS DB option group
# Provides an RDS DB option group resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group
#---------------------------------------------------
resource "aws_db_option_group" "db_option_group" {
  # Conditionally create the resource based on the 'enable_db_option_group' variable
  count = var.enable_db_option_group ? 1 : 0

  # Set the option group name based on provided variables, prioritizing 'db_option_group_name'
  name = var.db_option_group_name != "" && var.db_option_group_name_prefix == "" ? lower(var.db_option_group_name) : null
  # Set the option group name prefix based on provided variables
  name_prefix = var.db_option_group_name_prefix != "" && var.db_option_group_name == "" ? lower(var.db_option_group_name_prefix) : null
  # Description for the option group
  option_group_description = var.db_option_group_option_group_description

  # Engine and Version
  engine_name          = var.db_option_group_engine_name
  major_engine_version = var.db_option_group_major_engine_version

  # Dynamic block for defining options within the option group
  dynamic "option" {
    iterator = option
    for_each = var.db_option_group_options

    content {
      # They should likely be referencing 'option.value' instead.

      option_name = lookup(option.value, "option_name", null)

      port                           = lookup(option.value, "port", null)
      version                        = lookup(option.value, "version", null)
      db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
      vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

      # Nested dynamic block for defining option settings
      dynamic "option_settings" {
        iterator = option_settings
        for_each = length(keys(lookup(option.value, "option_settings", {}))) > 0 ? [lookup(option.value, "option_settings", {})] : []

        content {
          name  = lookup(option_settings.value, "name", null)
          value = lookup(option_settings.value, "value", null)
        }
      }
    }
  }

  # Dynamic block for setting a timeout for the delete operation
  dynamic "timeouts" {
    iterator = timeouts
    # Iterate if 'db_option_group_timeouts' is defined
    for_each = length(keys(var.db_option_group_timeouts)) > 0 ? [var.db_option_group_timeouts] : []

    content {
      delete = lookup(timeouts.value, "delete", null)
    }
  }

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # No explicit dependencies on other resources
  depends_on = []
}
