#---------------------------------------------------
# lb
#---------------------------------------------------

output "id" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.this[0].id, null)
}

output "arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.this[0].arn, null)
}

output "arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = try(aws_lb.this[0].arn_suffix, null)
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.this[0].dns_name, null)
}

output "zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = try(aws_lb.this[0].zone_id, null)
}

#---------------------------------------------------
# lb_listener
#---------------------------------------------------

output "listeners" {
  description = "Map of listeners created and their attributes"
  value       = aws_lb_listener.this
}

output "listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = aws_lb_listener_rule.this
}

#---------------------------------------------------
# lb_listener_certificate
#---------------------------------------------------

output "target_groups" {
  description = "Map of target groups created and their attributes"
  value       = aws_lb_target_group.this
}

# #---------------------------------------------------
# # lb_listener_rule
# #---------------------------------------------------

# output "lb_listener_rule_id" {
#   description = "The ARN of the rule (matches `arn`) * `arn` - The ARN of the rule (matches `id`) * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block)."
#   value       = aws_lb_listener_rule.lb_listener_rule.id
# }

# #---------------------------------------------------
# # lb_target_group
# #---------------------------------------------------

# output "lb_target_group_arn_suffix" {
#   description = "ARN suffix for use with CloudWatch Metrics. * `arn` - ARN of the Target Group (matches `id`). * `id` - ARN of the Target Group (matches `arn`). * `name` - Name of the Target Group. * `load_balancer_arns` - ARNs of the Load Balancers associated with the Target Group. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block)."
#   value       = aws_lb_target_group.lb_target_group.arn_suffix
# }

# #---------------------------------------------------
# # lb_target_group_attachment
# #---------------------------------------------------

# output "lb_target_group_attachment_id" {
#   description = "A unique identifier for the attachment."
#   value       = aws_lb_target_group_attachment.lb_target_group_attachment.id
# }

# #---------------------------------------------------
# # lb_trust_store
# #---------------------------------------------------

# output "lb_trust_store_arn_suffix" {
#   description = "ARN suffix for use with CloudWatch Metrics. * `arn` - ARN of the Trust Store (matches `id`). * `id` - ARN of the Trust Store (matches `arn`). * `name` - Name of the Trust Store. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block)."
#   value       = aws_lb_trust_store.lb_trust_store.arn_suffix
# }

# #---------------------------------------------------
# # lb_trust_store_revocation
# #---------------------------------------------------

# output "lb_trust_store_revocation_revocation_id" {
#   description = "AWS assigned RevocationId, (number). * `id` - "combination of the Trust Store ARN and RevocationId `${trust_store_arn},{revocation_id}`""
#   value       = aws_lb_trust_store_revocation.lb_trust_store_revocation.revocation_id
# }

