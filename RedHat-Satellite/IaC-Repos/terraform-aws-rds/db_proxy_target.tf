#---------------------------------------------------
# AWS DB proxy target
# Provides an RDS DB proxy target resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_target
#---------------------------------------------------
resource "aws_db_proxy_target" "db_proxy_target" {
  # Conditionally create the resource based on the 'enable_db_proxy_target' variable
  count = var.enable_db_proxy_target ? 1 : 0

  # The name of the DB proxy.
  # If 'db_proxy_target_db_proxy_name' is provided, use that value.
  # Otherwise, if 'enable_db_proxy' is true, get the name of the first DB proxy created by the 'aws_db_proxy.db_proxy' resource.
  # If 'enable_db_proxy' is false, set to null.
  db_proxy_name = var.db_proxy_target_db_proxy_name != "" ? var.db_proxy_target_db_proxy_name : (var.enable_db_proxy ? element(aws_db_proxy.db_proxy.*.name, 0) : null)
  # The name of the target group.
  # If 'db_proxy_target_target_group_name' is provided, use that value.
  # Otherwise, if 'enable_db_proxy_default_target_group' is true, get the name of the first DB proxy default target group created by the 'aws_db_proxy_default_target_group.db_proxy_default_target_group' resource.
  # If 'enable_db_proxy_default_target_group' is false, set to null.
  target_group_name = var.db_proxy_target_target_group_name != "" ? var.db_proxy_target_target_group_name : (var.enable_db_proxy_default_target_group ? element(aws_db_proxy_default_target_group.db_proxy_default_target_group.*.db_proxy_name, 0) : null)

  # The identifier of the DB instance.
  db_instance_identifier = var.db_proxy_target_db_instance_identifier
  # The identifier of the DB cluster.
  db_cluster_identifier = var.db_proxy_target_db_cluster_identifier

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # Dependencies on the 'aws_db_proxy.db_proxy' and 'aws_db_proxy_default_target_group.db_proxy_default_target_group' resources
  # Ensures the DB proxy and default target group exist before creating the target
  depends_on = [
    aws_db_proxy.db_proxy,
    aws_db_proxy_default_target_group.db_proxy_default_target_group
  ]
}
