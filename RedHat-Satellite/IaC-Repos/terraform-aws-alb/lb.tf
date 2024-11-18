#------------------------------------------------------------------------------------------------------
# Resource         : aws_lb
# description      : Provides a Load Balancer resource.
# module           : ELB (Elastic Load Balancing)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------
data "aws_partition" "current" {}

locals {
  tags = merge(var.tags, { terraform-aws-modules = "alb" })
}


resource "aws_lb" "this" {
  count = var.create ? 1 : 0

  dynamic "access_logs" {
    for_each = length(var.access_logs) > 0 ? [var.access_logs] : []

    content {
      bucket  = access_logs.value.bucket
      enabled = try(access_logs.value.enabled, true)
      prefix  = try(access_logs.value.prefix, null)
    }
  }

  dynamic "connection_logs" {
    for_each = length(var.connection_logs) > 0 ? [var.connection_logs] : []
    content {
      bucket  = connection_logs.value.bucket
      enabled = try(connection_logs.value.enabled, true)
      prefix  = try(connection_logs.value.prefix, null)
    }
  }

  client_keep_alive                                            = var.client_keep_alive
  customer_owned_ipv4_pool                                     = var.customer_owned_ipv4_pool
  desync_mitigation_mode                                       = var.desync_mitigation_mode
  dns_record_client_routing_policy                             = var.dns_record_client_routing_policy
  drop_invalid_header_fields                                   = var.drop_invalid_header_fields
  enable_cross_zone_load_balancing                             = var.enable_cross_zone_load_balancing
  enable_deletion_protection                                   = var.enable_deletion_protection
  enable_http2                                                 = var.enable_http2
  enable_tls_version_and_cipher_suite_headers                  = var.enable_tls_version_and_cipher_suite_headers
  enable_waf_fail_open                                         = var.enable_waf_fail_open
  enable_xff_client_port                                       = var.enable_xff_client_port
  enable_zonal_shift                                           = var.enable_zonal_shift
  enforce_security_group_inbound_rules_on_private_link_traffic = var.enforce_security_group_inbound_rules_on_private_link_traffic
  idle_timeout                                                 = var.idle_timeout
  internal                                                     = var.internal
  ip_address_type                                              = var.ip_address_type
  load_balancer_type                                           = var.load_balancer_type
  name                                                         = var.name
  name_prefix                                                  = var.name_prefix
  preserve_host_header                                         = var.preserve_host_header
  security_groups                                              = var.create_security_group ? concat([aws_security_group.this[0].id], var.security_groups) : var.security_groups

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping

    content {
      allocation_id        = lookup(subnet_mapping.value, "allocation_id", null)
      ipv6_address         = lookup(subnet_mapping.value, "ipv6_address", null)
      private_ipv4_address = lookup(subnet_mapping.value, "private_ipv4_address", null)
      subnet_id            = subnet_mapping.value.subnet_id
    }
  }

  subnets                    = var.subnets
  tags                       = local.tags
  xff_header_processing_mode = var.xff_header_processing_mode

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  lifecycle {
    ignore_changes = [
      tags["elasticbeanstalk:shared-elb-environment-count"]
    ]
  }
}