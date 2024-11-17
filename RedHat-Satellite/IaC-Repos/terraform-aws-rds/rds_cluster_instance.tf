#---------------------------------------------------
# AWS RDS cluster instance
# Provides an RDS Cluster Instance Resource. A Cluster Instance is an instance in a DB cluster.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance
#---------------------------------------------------
resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  # Conditionally create one or more RDS cluster instances based on 'enable_rds_cluster_instance' and 'number_rds_cluster_instances' variables
  count = var.enable_rds_cluster_instance ? var.number_rds_cluster_instances : 0

  # Instance Identification
  # Set the instance identifier based on provided variables, prioritizing 'rds_cluster_instance_identifier' and appending the instance index
  identifier = var.rds_cluster_instance_identifier != "" && var.rds_cluster_instance_identifier_prefix == "" ? "${lower(var.rds_cluster_instance_identifier)}-${count.index + 1}" : null
  # Set the instance identifier prefix based on provided variables and appending the instance index
  identifier_prefix = var.rds_cluster_instance_identifier_prefix != "" && var.rds_cluster_instance_identifier == "" ? "${lower(var.rds_cluster_instance_identifier_prefix)}-${count.index + 1}" : null
  # Set the cluster identifier based on provided variables, prioritizing 'rds_cluster_instance_cluster_identifier' if 'enable_rds_cluster' is false
  cluster_identifier = var.rds_cluster_instance_cluster_identifier != "" && !var.enable_rds_cluster ? lower(var.rds_cluster_instance_cluster_identifier) : element(concat(aws_rds_cluster.rds_cluster.*.id, [""]), 0)
  # The instance class to use.
  instance_class = var.rds_cluster_instance_instance_class

  # Database Engine Configuration
  engine         = var.rds_cluster_instance_engine
  engine_version = var.rds_cluster_instance_engine_version

  # Networking and Security
  publicly_accessible     = var.rds_cluster_instance_publicly_accessible
  db_subnet_group_name    = var.rds_cluster_instance_db_subnet_group_name != "" && !var.enable_db_subnet_group ? lower(var.rds_cluster_instance_db_subnet_group_name) : element(concat(aws_db_subnet_group.db_subnet_group.*.id, [""]), 0)
  db_parameter_group_name = var.rds_cluster_instance_db_parameter_group_name != "" && !var.enable_db_parameter_group ? var.rds_cluster_instance_db_parameter_group_name : element(concat(aws_rds_cluster_parameter_group.rds_cluster_parameter_group.*.id, [""]), 0)
  promotion_tier          = var.rds_cluster_instance_promotion_tier
  availability_zone       = var.rds_cluster_instance_availability_zone
  ca_cert_identifier      = var.rds_cluster_instance_ca_cert_identifier

  # Monitoring
  monitoring_role_arn = var.rds_cluster_instance_monitoring_role_arn
  monitoring_interval = var.rds_cluster_instance_monitoring_interval

  # Maintenance and Management
  preferred_backup_window      = var.rds_cluster_instance_preferred_backup_window
  preferred_maintenance_window = var.rds_cluster_instance_preferred_maintenance_window
  apply_immediately            = var.rds_cluster_instance_apply_immediately
  auto_minor_version_upgrade   = var.rds_cluster_instance_auto_minor_version_upgrade

  # Performance Insights
  performance_insights_enabled    = var.rds_cluster_instance_performance_insights_enabled
  performance_insights_kms_key_id = var.rds_cluster_instance_performance_insights_kms_key_id

  # Backup and Recovery
  copy_tags_to_snapshot = var.rds_cluster_instance_copy_tags_to_snapshot

  # Dynamic block for timeouts configuration
  dynamic "timeouts" {
    iterator = timeouts
    for_each = var.rds_cluster_instance_timeouts
    # var.length(keys(var.rds_cluster_instance_timeouts)) > 0 ? [var.rds_cluster_instance_timeouts] : []

    content {
      create = lookup(timeouts.value, "create", null)
      update = lookup(timeouts.value, "update", null)
      delete = lookup(timeouts.value, "delete", null)
    }
  }

  # Tags
  tags = merge(
    {
      Name = var.rds_cluster_instance_identifier != "" && var.rds_cluster_instance_identifier_prefix == "" ? lower(var.rds_cluster_instance_identifier) : lower(var.rds_cluster_instance_identifier_prefix)
    },
    var.tags
  )

  # Lifecycle management
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # Dependencies on other resources
  depends_on = [
    aws_rds_cluster.rds_cluster,
    aws_db_subnet_group.db_subnet_group,
    aws_rds_cluster_parameter_group.rds_cluster_parameter_group
  ]
}
