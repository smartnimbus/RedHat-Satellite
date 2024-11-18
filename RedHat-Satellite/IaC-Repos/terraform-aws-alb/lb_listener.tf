#------------------------------------------------------------------------------------------------------
# Resource         : aws_lb_listener
# description      : Provides a Load Balancer Listener resource.
# module           : ELB (Elastic Load Balancing)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


resource "aws_lb_listener" "this" {
  for_each = { for k, v in var.listeners : k => v if var.create }

  alpn_policy     = try(each.value.alpn_policy, null)
  certificate_arn = try(each.value.certificate_arn, null)

  dynamic "default_action" {
    for_each = try([each.value.authenticate_cognito], [])

    content {
      authenticate_cognito {
        authentication_request_extra_params = try(default_action.value.authentication_request_extra_params, null)
        on_unauthenticated_request          = try(default_action.value.on_unauthenticated_request, null)
        scope                               = try(default_action.value.scope, null)
        session_cookie_name                 = try(default_action.value.session_cookie_name, null)
        session_timeout                     = try(default_action.value.session_timeout, null)
        user_pool_arn                       = default_action.value.user_pool_arn
        user_pool_client_id                 = default_action.value.user_pool_client_id
        user_pool_domain                    = default_action.value.user_pool_domain
      }

      order = try(default_action.value.order, null)
      type  = "authenticate-cognito"
    }
  }

  dynamic "default_action" {
    for_each = try([each.value.authenticate_oidc], [])

    content {
      authenticate_oidc {
        authentication_request_extra_params = try(default_action.value.authentication_request_extra_params, null)
        authorization_endpoint              = default_action.value.authorization_endpoint
        client_id                           = default_action.value.client_id
        client_secret                       = default_action.value.client_secret
        issuer                              = default_action.value.issuer
        on_unauthenticated_request          = try(default_action.value.on_unauthenticated_request, null)
        scope                               = try(default_action.value.scope, null)
        session_cookie_name                 = try(default_action.value.session_cookie_name, null)
        session_timeout                     = try(default_action.value.session_timeout, null)
        token_endpoint                      = default_action.value.token_endpoint
        user_info_endpoint                  = default_action.value.user_info_endpoint
      }

      order = try(default_action.value.order, null)
      type  = "authenticate-oidc"
    }
  }

  dynamic "default_action" {
    for_each = try([each.value.fixed_response], [])

    content {
      fixed_response {
        content_type = default_action.value.content_type
        message_body = try(default_action.value.message_body, null)
        status_code  = try(default_action.value.status_code, null)
      }

      order = try(default_action.value.order, null)
      type  = "fixed-response"
    }
  }

  dynamic "default_action" {
    for_each = try([each.value.forward], [])

    content {
      order            = try(default_action.value.order, null)
      target_group_arn = length(try(default_action.value.target_groups, [])) > 0 ? null : try(default_action.value.arn, aws_lb_target_group.this[default_action.value.target_group_key].arn, null)
      type             = "forward"
    }
  }

  dynamic "default_action" {
    for_each = try([each.value.weighted_forward], [])

    content {
      forward {
        dynamic "target_group" {
          for_each = try(default_action.value.target_groups, [])

          content {
            arn    = try(target_group.value.arn, aws_lb_target_group.this[target_group.value.target_group_key].arn, null)
            weight = try(target_group.value.weight, null)
          }
        }

        dynamic "stickiness" {
          for_each = try([default_action.value.stickiness], [])

          content {
            duration = try(stickiness.value.duration, 60)
            enabled  = try(stickiness.value.enabled, null)
          }
        }
      }

      order = try(default_action.value.order, null)
      type  = "forward"
    }
  }

  dynamic "default_action" {
    for_each = try([each.value.redirect], [])

    content {
      order = try(default_action.value.order, null)

      redirect {
        host        = try(default_action.value.host, null)
        path        = try(default_action.value.path, null)
        port        = try(default_action.value.port, null)
        protocol    = try(default_action.value.protocol, null)
        query       = try(default_action.value.query, null)
        status_code = default_action.value.status_code
      }

      type = "redirect"
    }
  }

  dynamic "mutual_authentication" {
    for_each = try([each.value.mutual_authentication], [])
    content {
      mode                             = mutual_authentication.value.mode
      trust_store_arn                  = try(mutual_authentication.value.trust_store_arn, null)
      ignore_client_certificate_expiry = try(mutual_authentication.value.ignore_client_certificate_expiry, null)
    }
  }

  load_balancer_arn        = aws_lb.this[0].arn
  port                     = try(each.value.port, var.default_port)
  protocol                 = try(each.value.protocol, var.default_protocol)
  ssl_policy               = contains(["HTTPS", "TLS"], try(each.value.protocol, var.default_protocol)) ? try(each.value.ssl_policy, "ELBSecurityPolicy-TLS13-1-2-Res-2021-06") : try(each.value.ssl_policy, null)
  tcp_idle_timeout_seconds = try(each.value.tcp_idle_timeout_seconds, null)
  tags                     = merge(local.tags, try(each.value.tags, {}))
}
