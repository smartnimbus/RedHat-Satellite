#---------------------------------------------------
# AWS DB proxy default target group
# Provides an RDS DB proxy default target group resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_default_target_group
#---------------------------------------------------
resource "aws_db_proxy_default_target_group" "db_proxy_default_target_group" {
  # Conditionally create the resource based on the 'enable_db_proxy_default_target_group' variable
  count = var.enable_db_proxy_default_target_group ? 1 : 0

  # The name of the DB proxy.
  # If 'db_proxy_default_target_group_db_proxy_name' is provided, use that value.
  # Otherwise, if 'enable_db_proxy' is true, get the name of the first DB proxy created by the 'aws_db_proxy.db_proxy' resource.
  # If 'enable_db_proxy' is false, set to null.
  db_proxy_name = var.db_proxy_default_target_group_db_proxy_name != "" ? var.db_proxy_default_target_group_db_proxy_name : (var.enable_db_proxy ? element(aws_db_proxy.db_proxy.*.name, 0) : null)

  # Dynamic block for configuring the connection pool
  dynamic "connection_pool_config" {
    iterator = connection_pool_config
    # Iterate over the 'db_proxy_default_target_group_connection_pool_config' variable (should be a map)
    for_each = var.db_proxy_default_target_group_connection_pool_config

    content {
      connection_borrow_timeout    = lookup(connection_pool_config.value, "connection_borrow_timeout", null)
      init_query                   = lookup(connection_pool_config.value, "init_query", null)
      max_connections_percent      = lookup(connection_pool_config.value, "max_connections_percent", null)
      max_idle_connections_percent = lookup(connection_pool_config.value, "max_idle_connections_percent", null)
      session_pinning_filters      = lookup(connection_pool_config.value, "session_pinning_filters", null)
    }
  }

  # Dynamic block for setting timeouts for create and update operations
  dynamic "timeouts" {
    iterator = timeouts
    # Iterate if 'db_proxy_default_target_group_timeouts' is defined
    for_each = length(keys(var.db_proxy_default_target_group_timeouts)) > 0 ? [var.db_proxy_default_target_group_timeouts] : []

    content {
      create = lookup(timeouts.value, "create", null)
      update = lookup(timeouts.value, "update", null)
    }
  }

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # Dependency on the 'aws_db_proxy.db_proxy' resource
  # Ensures the DB proxy exists before creating the default target group
  depends_on = [
    aws_db_proxy.db_proxy
  ]
}


