#---------------------------------------------------
# AWS DB event subscription
# Provides a DB event subscription resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription
#---------------------------------------------------
resource "aws_db_event_subscription" "db_event_subscription" {
  # Conditionally create the resource based on the 'enable_db_event_subscription' variable
  count = var.enable_db_event_subscription ? 1 : 0

  # Set the subscription name based on provided variables, prioritizing 'db_event_subscription_name'
  name = var.db_event_subscription_name != "" && var.db_event_subscription_name_prefix == "" ? lower(var.db_event_subscription_name) : null
  # Set the subscription name prefix based on provided variables
  name_prefix = var.db_event_subscription_name_prefix != "" && var.db_event_subscription_name == "" ? lower(var.db_event_subscription_name_prefix) : null
  # The ARN of the SNS topic to send notifications to
  sns_topic = var.db_event_subscription_sns_topic

  # Event Source Configuration
  source_type      = var.db_event_subscription_source_type
  source_ids       = var.db_event_subscription_source_ids
  enabled          = var.db_event_subscription_enabled
  event_categories = var.db_event_subscription_event_categories

  # Dynamic block for setting timeouts for create, update, and delete operations
  dynamic "timeouts" {
    iterator = timeouts
    # Iterate if 'db_event_subscription_timeouts' is defined
    for_each = length(keys(var.db_event_subscription_timeouts)) > 0 ? [var.db_event_subscription_timeouts] : []

    content {
      create = lookup(timeouts.value, "create", null)
      update = lookup(timeouts.value, "update", null)
      delete = lookup(timeouts.value, "delete", null)
    }
  }

  # Tags for the event subscription
  tags = merge(
    {
      # Set the 'Name' tag based on the subscription name or prefix
      Name = var.db_event_subscription_name != "" && var.db_event_subscription_name_prefix == "" ? lower(var.db_event_subscription_name) : lower(var.db_event_subscription_name_prefix)
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

