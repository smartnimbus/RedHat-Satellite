#---------------------------------------------------
# AWS DB instance role association
# Manages an RDS DB Instance association with an IAM Role. Example use cases:
# - Using Amazon RDS with Amazon S3 Integration
# - Using Amazon RDS with Amazon Kinesis Data Firehose
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance_role_association
#---------------------------------------------------
resource "aws_db_instance_role_association" "db_instance_role_association" {
  # Conditionally create the resource based on the 'enable_db_instance_role_association' variable
  count = var.enable_db_instance_role_association ? 1 : 0

  # The DB instance identifier. 
  # If 'db_instance_role_association_db_instance_identifier' is provided and 'enable_db_instance' is false, use that value.
  # Otherwise, get the ID of the first DB instance created by the 'aws_db_instance.db_instance' resource.
  db_instance_identifier = var.db_instance_role_association_db_instance_identifier != "" && !var.enable_db_instance ? var.db_instance_role_association_db_instance_identifier : element(concat(aws_db_instance.db_instance.*.id, [""]), 0)

  # The name of the feature associated with the IAM role. 
  # This value depends on the specific AWS service you want the DB instance to access.
  feature_name = var.db_instance_role_association_feature_name

  # The ARN of the IAM role that is associated with the DB instance.
  role_arn = var.db_instance_role_association_role_arn

  # Lifecycle management for the resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # Dependency on the 'aws_db_instance.db_instance' resource
  # Ensures the DB instance exists before creating the association
  depends_on = [
    aws_db_instance.db_instance
  ]
}



