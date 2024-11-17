#---------------------------------------------------
# AWS RDS global cluster
# Provides an RDS Global Cluster resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster
#---------------------------------------------------
resource "aws_rds_global_cluster" "rds_global_cluster" {
  # Conditionally create the resource based on the 'enable_rds_global_cluster' variable
  count = var.enable_rds_global_cluster ? 1 : 0

  # The global cluster identifier. If omitted, Terraform will assign a random, unique identifier.
  # If 'rds_global_cluster_global_cluster_identifier' is provided, use that value.
  # Otherwise, generate a name like "test-global-cluster-stage" using variables.
  global_cluster_identifier = var.rds_global_cluster_global_cluster_identifier != "" ? var.rds_global_cluster_global_cluster_identifier : "${lower(var.name)}-global-cluster-${lower(var.environment)}"

  # The name for your database of up to 64 alpha-numeric characters. If omitted, Terraform will assign a random, unique identifier.
  database_name = var.rds_global_cluster_database_name
  # The deletion protection setting for the new global database. The global database can't be deleted when deletion protection is enabled.
  deletion_protection = var.rds_global_cluster_deletion_protection
  # The name of the database engine to be used for this DB cluster.
  engine = var.rds_global_cluster_engine
  # The engine version to use.
  engine_version = var.rds_global_cluster_engine_version
  # Specifies whether the DB cluster is encrypted.
  storage_encrypted = var.rds_global_cluster_storage_encrypted

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # No explicit dependencies on other resources
  depends_on = []
}
