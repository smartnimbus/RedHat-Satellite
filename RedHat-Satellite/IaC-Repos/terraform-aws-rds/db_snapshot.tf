#---------------------------------------------------
# AWS DB snapshot
# Provides an RDS DB snapshot resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_snapshot
#---------------------------------------------------
resource "aws_db_snapshot" "db_snapshot" {
  # Conditionally create the resource based on the 'enable_db_snapshot' variable
  count = var.enable_db_snapshot ? 1 : 0

  # The DB instance identifier.
  # If 'db_snapshot_db_instance_identifier' is provided, use that value.
  # Otherwise, get the ID of the first DB instance created by the 'aws_db_instance.db_instance' resource.
  db_instance_identifier = var.db_snapshot_db_instance_identifier != "" ? var.db_snapshot_db_instance_identifier : element(concat(aws_db_instance.db_instance.*.id, [""]), 0)

  # The identifier for the DB snapshot.
  # If 'db_snapshot_db_snapshot_identifier' is provided, use that value (converted to lowercase).
  # Otherwise, generate a name like "test-db-snapshot-stage" using variables.
  db_snapshot_identifier = var.db_snapshot_db_snapshot_identifier != "" ? lower(var.db_snapshot_db_snapshot_identifier) : "${lower(var.name)}-db-snapshot-${lower(var.environment)}"

  # Tags for the DB snapshot
  tags = merge(
    {
      # Set the 'Name' tag based on the snapshot identifier or generated name
      Name = var.db_snapshot_db_snapshot_identifier != "" ? lower(var.db_snapshot_db_snapshot_identifier) : "${lower(var.name)}-db-snapshot-${lower(var.environment)}"
    },
    var.tags
  )

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # Dependency on the 'aws_db_instance.db_instance' resource
  # Ensures the DB instance exists before creating the snapshot
  depends_on = [
    aws_db_instance.db_instance
  ]
}
