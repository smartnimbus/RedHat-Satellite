#---------------------------------------------------
# AWS DB security group
# Provides an RDS DB security group resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_security_group
#---------------------------------------------------
resource "aws_db_security_group" "db_security_group" {
  # Conditionally create the resource based on the 'enable_db_security_group' variable
  count = var.enable_db_security_group ? 1 : 0

  # The name of the DB security group.
  # If 'db_security_group_name' is provided and not empty, use that value (converted to lowercase).
  # Otherwise, generate a name like "test-db-sg-stage" using variables.
  name = var.db_security_group_name != "" ? lower(var.db_security_group_name) : "${lower(var.name)}-db-sg-${lower(var.environment)}"

  # The description of the DB security group.
  # If 'db_security_group_description' is provided and not empty, use that value (converted to lowercase).
  # Otherwise, set to null.
  description = var.db_security_group_description != "" ? lower(var.db_security_group_description) : null

  # Dynamic block for defining ingress rules
  dynamic "ingress" {
    iterator = ingress
    # Iterate over the 'db_security_group_ingress' variable (should be a list of maps)
    for_each = var.db_security_group_ingress

    content {
      cidr                    = lookup(ingress.value, "cidr", null)
      security_group_name     = lookup(ingress.value, "security_group_name", null)
      security_group_id       = lookup(ingress.value, "security_group_id", null)
      security_group_owner_id = lookup(ingress.value, "security_group_owner_id", null)
    }
  }

  # Tags for the DB security group
  tags = merge(
    {
      # Set the 'Name' tag based on the security group name or generated name
      Name = var.db_security_group_name != "" ? lower(var.db_security_group_name) : "${lower(var.name)}-db-sg-${lower(var.environment)}"
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
