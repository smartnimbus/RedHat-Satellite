#---------------------------------------------------
# AWS DB proxy
# Provides an RDS DB proxy resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy
#---------------------------------------------------
resource "aws_db_proxy" "db_proxy" {
  # Conditionally create the resource based on the 'enable_db_proxy' variable
  count = var.enable_db_proxy ? 1 : 0

  # The name of the DB proxy.
  # If 'db_proxy_name' is provided and not empty, use that value (converted to lowercase).
  # Otherwise, generate a name like "test-db-proxy-stage" using variables.
  name = var.db_proxy_name != "" && var.db_proxy_name == "" ? lower(var.db_proxy_name) : "${var.name}-db-proxy-${var.environment}"

  # The kinds of databases that the proxy can connect to.
  engine_family = upper(var.db_proxy_engine_family)

  # The Amazon Resource Name (ARN) of the IAM role that the proxy uses to access secrets in AWS Secrets Manager.
  role_arn = var.db_proxy_role_arn

  # One or more VPC subnet IDs to associate with the new proxy.
  vpc_subnet_ids = var.db_proxy_vpc_subnet_ids

  # Dynamic block for configuring authentication settings
  dynamic "auth" {
    iterator = auth
    # Iterate over the 'db_proxy_auth' variable (should be a list of maps)
    for_each = var.db_proxy_auth

    content {
      description = lookup(auth.value, "description", null)
      // username    = lookup(auth.value, "username", null)
      auth_scheme = lookup(auth.value, "auth_scheme", null)
      iam_auth    = lookup(auth.value, "iam_auth", null)
      secret_arn  = lookup(auth.value, "secret_arn", null)
    }
  }

  # Additional Configuration
  debug_logging          = var.db_proxy_debug_logging
  idle_client_timeout    = var.db_proxy_idle_client_timeout
  require_tls            = var.db_proxy_require_tls
  vpc_security_group_ids = var.db_proxy_vpc_security_group_ids

  # Dynamic block for setting timeouts for create, update, and delete operations
  dynamic "timeouts" {
    iterator = timeouts
    # Iterate if 'db_proxy_timeouts' is defined
    for_each = length(keys(var.db_proxy_timeouts)) > 0 ? [var.db_proxy_timeouts] : []

    content {
      create = lookup(timeouts.value, "create", null)
      update = lookup(timeouts.value, "update", null)
      delete = lookup(timeouts.value, "delete", null)
    }
  }

  # Tags for the DB proxy
  tags = merge(
    {
      Name = var.db_proxy_name != "" && var.db_proxy_name == "" ? lower(var.db_proxy_name) : "${var.name}-db-proxy-${var.environment}"
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