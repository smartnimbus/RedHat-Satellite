#------------------------------------------------------------------------------------------------------
# Resource         : aws_lb_listener_rule
# description      : Provides a Load Balancer Listener Rule resource.
# module           : ELB (Elastic Load Balancing)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


locals {
  # This allows rules to be specified under the listener definition
  listener_rules = flatten([
    for listener_key, listener_values in var.listeners : [
      for rule_key, rule_values in lookup(listener_values, "rules", {}) :
      merge(rule_values, {
        listener_key = listener_key
        rule_key     = rule_key
      })
    ]
  ])
}

resource "aws_lb_listener_rule" "this" {
  for_each = { for v in local.listener_rules : "${v.listener_key}/${v.rule_key}" => v if var.create }

  listener_arn = try(each.value.listener_arn, aws_lb_listener.this[each.value.listener_key].arn)
  priority     = try(each.value.priority, null)

  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "authenticate-cognito"]

    content {
      type  = "authenticate-cognito"
      order = try(action.value.order, null)

      authenticate_cognito {
        authentication_request_extra_params = try(action.value.authentication_request_extra_params, null)
        on_unauthenticated_request          = try(action.value.on_unauthenticated_request, null)
        scope                               = try(action.value.scope, null)
        session_cookie_name                 = try(action.value.session_cookie_name, null)
        session_timeout                     = try(action.value.session_timeout, null)
        user_pool_arn                       = action.value.user_pool_arn
        user_pool_client_id                 = action.value.user_pool_client_id
        user_pool_domain                    = action.value.user_pool_domain
      }
    }
  }

  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "authenticate-oidc"]

    content {
      type  = "authenticate-oidc"
      order = try(action.value.order, null)

      authenticate_oidc {
        authentication_request_extra_params = try(action.value.authentication_request_extra_params, null)
        authorization_endpoint              = action.value.authorization_endpoint
        client_id                           = action.value.client_id
        client_secret                       = action.value.client_secret
        issuer                              = action.value.issuer
        on_unauthenticated_request          = try(action.value.on_unauthenticated_request, null)
        scope                               = try(action.value.scope, null)
        session_cookie_name                 = try(action.value.session_cookie_name, null)
        session_timeout                     = try(action.value.session_timeout, null)
        token_endpoint                      = action.value.token_endpoint
        user_info_endpoint                  = action.value.user_info_endpoint
      }
    }
  }

  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "redirect"]

    content {
      type  = "redirect"
      order = try(action.value.order, null)

      redirect {
        host        = try(action.value.host, null)
        path        = try(action.value.path, null)
        port        = try(action.value.port, null)
        protocol    = try(action.value.protocol, null)
        query       = try(action.value.query, null)
        status_code = action.value.status_code
      }
    }
  }

  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "fixed-response"]

    content {
      type  = "fixed-response"
      order = try(action.value.order, null)

      fixed_response {
        content_type = action.value.content_type
        message_body = try(action.value.message_body, null)
        status_code  = try(action.value.status_code, null)
      }
    }
  }

  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "forward"]

    content {
      type             = "forward"
      order            = try(action.value.order, null)
      target_group_arn = try(action.value.target_group_arn, aws_lb_target_group.this[action.value.target_group_key].arn, null)
    }
  }

  dynamic "action" {
    for_each = [for action in each.value.actions : action if action.type == "weighted-forward"]

    content {
      type  = "forward"
      order = try(action.value.order, null)

      forward {
        dynamic "target_group" {
          for_each = try(action.value.target_groups, [])

          content {
            arn    = try(target_group.value.arn, aws_lb_target_group.this[target_group.value.target_group_key].arn)
            weight = try(target_group.value.weight, null)
          }
        }

        dynamic "stickiness" {
          for_each = try([action.value.stickiness], [])

          content {
            enabled  = try(stickiness.value.enabled, null)
            duration = try(stickiness.value.duration, 60)
          }
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "host_header")]

    content {
      dynamic "host_header" {
        for_each = try([condition.value.host_header], [])

        content {
          values = host_header.value.values
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "http_header")]

    content {
      dynamic "http_header" {
        for_each = try([condition.value.http_header], [])

        content {
          http_header_name = http_header.value.http_header_name
          values           = http_header.value.values
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "http_request_method")]

    content {
      dynamic "http_request_method" {
        for_each = try([condition.value.http_request_method], [])

        content {
          values = http_request_method.value.values
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "path_pattern")]

    content {
      dynamic "path_pattern" {
        for_each = try([condition.value.path_pattern], [])

        content {
          values = path_pattern.value.values
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "query_string")]

    content {
      dynamic "query_string" {
        for_each = try(flatten([condition.value.query_string]), [])

        content {
          key   = try(query_string.value.key, null)
          value = query_string.value.value
        }
      }
    }
  }

  dynamic "condition" {
    for_each = [for condition in each.value.conditions : condition if contains(keys(condition), "source_ip")]

    content {
      dynamic "source_ip" {
        for_each = try([condition.value.source_ip], [])

        content {
          values = source_ip.value.values
        }
      }
    }
  }

  tags = merge(local.tags, try(each.value.tags, {}))
}



