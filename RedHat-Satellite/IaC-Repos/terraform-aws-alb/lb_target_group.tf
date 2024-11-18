#------------------------------------------------------------------------------------------------------
# Resource         : aws_lb_target_group
# description      : Provides a Target Group resource for use with Load Balancers.
# module           : ELB (Elastic Load Balancing)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


resource "aws_lb_target_group" "this" {
  for_each = { for k, v in var.target_groups : k => v if var.create }

  connection_termination = try(each.value.connection_termination, null)
  deregistration_delay   = try(each.value.deregistration_delay, null)

  dynamic "health_check" {
    for_each = try([each.value.health_check], [])

    content {
      enabled             = try(health_check.value.enabled, null)
      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      interval            = try(health_check.value.interval, null)
      matcher             = try(health_check.value.matcher, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, null)
      protocol            = try(health_check.value.protocol, null)
      timeout             = try(health_check.value.timeout, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
    }
  }

  ip_address_type                    = try(each.value.ip_address_type, null)
  lambda_multi_value_headers_enabled = try(each.value.lambda_multi_value_headers_enabled, null)
  load_balancing_algorithm_type      = try(each.value.load_balancing_algorithm_type, null)
  load_balancing_anomaly_mitigation  = try(each.value.load_balancing_anomaly_mitigation, null)
  load_balancing_cross_zone_enabled  = try(each.value.load_balancing_cross_zone_enabled, null)
  name                               = try(each.value.name, null)
  name_prefix                        = try(each.value.name_prefix, null)
  port                               = try(each.value.target_type, null) == "lambda" ? null : try(each.value.port, var.default_port)
  preserve_client_ip                 = try(each.value.preserve_client_ip, null)
  protocol                           = try(each.value.target_type, null) == "lambda" ? null : try(each.value.protocol, var.default_protocol)
  protocol_version                   = try(each.value.protocol_version, null)
  proxy_protocol_v2                  = try(each.value.proxy_protocol_v2, null)
  slow_start                         = try(each.value.slow_start, null)

  dynamic "stickiness" {
    for_each = try([each.value.stickiness], [])

    content {
      cookie_duration = try(stickiness.value.cookie_duration, null)
      cookie_name     = try(stickiness.value.cookie_name, null)
      enabled         = try(stickiness.value.enabled, true)
      type            = var.load_balancer_type == "network" ? "source_ip" : stickiness.value.type
    }
  }

  dynamic "target_failover" {
    for_each = try(each.value.target_failover, [])

    content {
      on_deregistration = target_failover.value.on_deregistration
      on_unhealthy      = target_failover.value.on_unhealthy
    }
  }

  dynamic "target_group_health" {
    for_each = try([each.value.target_group_health], [])

    content {

      dynamic "dns_failover" {
        for_each = try([target_group_health.value.dns_failover], [])

        content {
          minimum_healthy_targets_count      = try(dns_failover.value.minimum_healthy_targets_count, null)
          minimum_healthy_targets_percentage = try(dns_failover.value.minimum_healthy_targets_percentage, null)
        }
      }

      dynamic "unhealthy_state_routing" {
        for_each = try([target_group_health.value.unhealthy_state_routing], [])

        content {
          minimum_healthy_targets_count      = try(unhealthy_state_routing.value.minimum_healthy_targets_count, null)
          minimum_healthy_targets_percentage = try(unhealthy_state_routing.value.minimum_healthy_targets_percentage, null)
        }
      }
    }
  }

  dynamic "target_health_state" {
    for_each = try([each.value.target_health_state], [])
    content {
      enable_unhealthy_connection_termination = try(target_health_state.value.enable_unhealthy_connection_termination, true)
      unhealthy_draining_interval             = try(target_health_state.value.unhealthy_draining_interval, null)
    }
  }

  target_type = try(each.value.target_type, null)
  vpc_id      = try(each.value.vpc_id, var.vpc_id)

  tags = merge(local.tags, try(each.value.tags, {}))

  lifecycle {
    create_before_destroy = true
  }
}



