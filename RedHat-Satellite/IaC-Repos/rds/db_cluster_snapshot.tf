#---------------------------------------------------
# AWS DB cluster snapshot
# Manages an RDS database cluster snapshot for Aurora clusters. 
# For managing RDS database instance snapshots, see the 'aws_db_snapshot' resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_cluster_snapshot
#---------------------------------------------------
resource "aws_db_cluster_snapshot" "db_cluster_snapshot" {
  # Conditional creation of the snapshot based on the 'enable_db_cluster_snapshot' variable
  count = var.enable_db_cluster_snapshot ? 1 : 0

  # Identifier of the DB cluster to snapshot
  # If 'db_cluster_snapshot_db_cluster_identifier' is provided, use that value (converted to lowercase)
  # Otherwise, get the ID of the first DB cluster created by the 'aws_rds_cluster.rds_cluster' resource
  db_cluster_identifier = var.db_cluster_snapshot_db_cluster_identifier != "" ? lower(var.db_cluster_snapshot_db_cluster_identifier) : element(concat(aws_rds_cluster.rds_cluster.*.id, [""]), 0)

  # Identifier for the DB cluster snapshot
  # If 'db_cluster_snapshot_identifier' is provided, use that value (converted to lowercase)
  # Otherwise, generate a name like "test-rds-db-cluster-snapshot-stage" using variables
  db_cluster_snapshot_identifier = var.db_cluster_snapshot_identifier != "" ? lower(var.db_cluster_snapshot_identifier) : "${lower(var.name)}-db-cluster-snapshot-${lower(var.environment)}"

  # Dynamic block to set a timeout for the snapshot creation process
  dynamic "timeouts" {
    iterator = timeouts
    # Iterate if 'db_cluster_snapshot_timeouts' is defined
    for_each = length(keys(var.db_cluster_snapshot_timeouts)) > 0 ? [var.db_cluster_snapshot_timeouts] : []

    content {
      # Use the "create" timeout value from the variable
      create = lookup(timeouts.value, "create", null)
    }
  }

  # Tags for the snapshot
  tags = merge(
    {
      # Set the 'Name' tag based on the snapshot identifier or generated name
      Name = var.db_cluster_snapshot_identifier != "" ? lower(var.db_cluster_snapshot_identifier) : "${lower(var.name)}-db-cluster-snapshot-${lower(var.environment)}"
    },
    var.tags
  )

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # Dependency on the 'aws_rds_cluster.rds_cluster' resource
  # Ensures the DB cluster exists before creating the snapshot
  depends_on = [
    aws_rds_cluster.rds_cluster
  ]
}

