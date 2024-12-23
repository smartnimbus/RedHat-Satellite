#---------------------------------------------------
# AWS RDS cluster
# Provides an RDS Cluster Resource. A DB Cluster is an isolated database environment in the cloud.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
#---------------------------------------------------
resource "aws_rds_cluster" "rds_cluster" {
  # Conditionally create the resource based on the 'enable_rds_cluster' variable
  count = var.enable_rds_cluster ? 1 : 0

  # Database Credentials
  master_username = var.rds_cluster_master_username
  master_password = var.rds_cluster_master_password
  database_name   = var.rds_cluster_database_name

  # Cluster Identification
  cluster_identifier        = var.rds_cluster_cluster_identifier != "" ? lower(var.rds_cluster_cluster_identifier) : null
  cluster_identifier_prefix = var.rds_cluster_cluster_identifier_prefix != "" ? lower(var.rds_cluster_cluster_identifier_prefix) : null
  # The global cluster identifier. If omitted, Terraform will assign a random, unique identifier.
  # If 'rds_cluster_global_cluster_identifier' is provided and 'enable_rds_global_cluster' is false, use that value.
  # Otherwise, get the ID of the first RDS global cluster created by the 'aws_rds_global_cluster.rds_global_cluster' resource.
  global_cluster_identifier = var.rds_cluster_global_cluster_identifier != "" && !var.enable_rds_global_cluster ? var.rds_cluster_global_cluster_identifier : element(concat(aws_rds_global_cluster.rds_global_cluster.*.id, [""]), 0)

  # Database Engine Configuration
  engine         = var.rds_cluster_engine
  engine_version = var.rds_cluster_engine_version
  engine_mode    = lower(var.rds_cluster_engine_mode)
  source_region  = var.rds_cluster_source_region != "" ? var.rds_cluster_source_region : var.region

  # Networking and Security
  db_subnet_group_name            = var.rds_cluster_db_subnet_group_name != "" && !var.enable_db_subnet_group ? var.rds_cluster_db_subnet_group_name : element(aws_db_subnet_group.db_subnet_group.*.id, 0)
  db_cluster_parameter_group_name = var.rds_cluster_db_cluster_parameter_group_name != "" && !var.enable_rds_cluster_parameter_group ? var.rds_cluster_db_cluster_parameter_group_name : element(concat(aws_rds_cluster_parameter_group.rds_cluster_parameter_group.*.id, [""]), 0)
  vpc_security_group_ids          = var.rds_cluster_vpc_security_group_ids
  # A list of EC2 Availability Zones that instances in the DB cluster can be created in.
  availability_zones = length(var.rds_cluster_availability_zones) > 0 ? var.rds_cluster_availability_zones : split(",", (lookup(var.availability_zones, var.region)))
  port               = var.rds_cluster_port != null ? var.rds_cluster_port : lookup(var.default_ports, var.rds_cluster_engine)

  # IAM and Authentication
  iam_roles                           = var.rds_cluster_iam_roles
  iam_database_authentication_enabled = var.rds_cluster_iam_database_authentication_enabled != null ? var.rds_cluster_iam_database_authentication_enabled : null

  # Backup and Recovery
  backtrack_window             = var.rds_cluster_backtrack_window
  backup_retention_period      = var.rds_cluster_backup_retention_period
  preferred_backup_window      = var.rds_cluster_backup_window
  preferred_maintenance_window = var.rds_cluster_preferred_maintenance_window

  # Storage and Encryption
  storage_encrypted = var.rds_cluster_storage_encrypted
  kms_key_id        = var.rds_cluster_kms_key_id

  # Management and Configuration
  apply_immediately               = var.rds_cluster_apply_immediately
  deletion_protection             = var.rds_cluster_deletion_protection
  replication_source_identifier   = var.rds_cluster_replication_source_identifier
  enabled_cloudwatch_logs_exports = var.rds_cluster_enabled_cloudwatch_logs_exports

  # Snapshot Configuration
  snapshot_identifier       = var.rds_cluster_snapshot_identifier != "" ? var.rds_cluster_snapshot_identifier : null
  final_snapshot_identifier = var.rds_cluster_final_snapshot_identifier != "" ? var.rds_cluster_final_snapshot_identifier : "${lower(var.name)}-cluster-${lower(var.environment)}-${md5(timestamp())}"
  skip_final_snapshot       = var.rds_cluster_skip_final_snapshot
  enable_http_endpoint      = var.rds_cluster_enable_http_endpoint
  copy_tags_to_snapshot     = var.rds_cluster_copy_tags_to_snapshot

  # Dynamic block for scaling configuration (for serverless clusters)
  dynamic "scaling_configuration" {
    # for_each = var.engine_mode == "serverless" ? var.scaling_configuration : 0
    # for_each = var.engine_mode == "serverless" ? var.scaling_configuration : null
    iterator = scaling_configuration
    for_each = var.rds_cluster_scaling_configuration

    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
    }
  }

  # Dynamic block for S3 import configuration
  dynamic "s3_import" {
    #for_each = var.engine_mode == "serverless" ? var.s3_import : 0
    iterator = s3_import
    for_each = var.rds_cluster_s3_import

    content {
      source_engine         = lookup(s3_import.value, "source_engine", null)
      source_engine_version = lookup(s3_import.value, "source_engine_version", null)
      bucket_name           = lookup(s3_import.value, "bucket_name", null)
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = lookup(s3_import.value, "ingestion_role", null)
    }
  }

  # Dynamic block for timeouts configuration
  dynamic "timeouts" {
    iterator = timeouts
    for_each = var.rds_cluster_timeouts
    # var.length(keys(var.rds_cluster_timeouts)) > 0 ? [var.rds_cluster_timeouts] : []

    content {
      create = lookup(timeouts.value, "create", null)
      update = lookup(timeouts.value, "update", null)
      delete = lookup(timeouts.value, "delete", null)
    }
  }

  # Tags
  tags = merge(
    {
      Name = var.rds_cluster_cluster_identifier != "" && var.rds_cluster_cluster_identifier_prefix == "" ? lower(var.rds_cluster_cluster_identifier) : lower(var.rds_cluster_cluster_identifier_prefix)
    },
    var.tags
  )

  # Lifecycle management
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [availability_zones, final_snapshot_identifier, backup_retention_period]
  }

  # Dependencies on other resources
  depends_on = [
    aws_rds_global_cluster.rds_global_cluster,
    aws_db_subnet_group.db_subnet_group,
    aws_rds_cluster_parameter_group.rds_cluster_parameter_group
  ]
}
