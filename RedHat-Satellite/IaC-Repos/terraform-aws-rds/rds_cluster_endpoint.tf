#---------------------------------------------------
# AWS RDS cluster endpoint
# Provides an RDS Cluster Endpoint Resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_endpoint
#---------------------------------------------------
resource "aws_rds_cluster_endpoint" "rds_cluster_endpoint" {
  # Conditionally create the resource based on the 'enable_rds_cluster_endpoint' variable
  count = var.enable_rds_cluster_endpoint ? 1 : 0

  # The identifier of the RDS cluster.
  # If 'rds_cluster_endpoint_cluster_identifier' is provided, use that value (converted to lowercase).
  # Otherwise, get the ID of the first RDS cluster created by the 'aws_rds_cluster.rds_cluster' resource.
  cluster_identifier = var.rds_cluster_endpoint_cluster_identifier != "" ? lower(var.rds_cluster_endpoint_cluster_identifier) : element(concat(aws_rds_cluster.rds_cluster.*.id, [""]), 0)

  # The identifier to use for the new endpoint. This parameter is stored as a lowercase string.
  cluster_endpoint_identifier = var.rds_cluster_endpoint_cluster_endpoint_identifier

  # The type of the endpoint. One of: READER, ANY.
  custom_endpoint_type = upper(var.rds_cluster_endpoint_custom_endpoint_type)

  # List of DB instance identifiers that aren't part of the custom endpoint group. 
  # All other eligible instances are reachable through the custom endpoint. Only relevant if the list of static members is empty.
  excluded_members = var.rds_cluster_endpoint_excluded_members

  # List of DB instance identifiers that are part of the custom endpoint group.
  static_members = var.rds_cluster_endpoint_static_members

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # Dependency on the 'aws_rds_cluster.rds_cluster' resource
  # Ensures the RDS cluster exists before creating the endpoint
  depends_on = [
    aws_rds_cluster.rds_cluster
  ]
}
