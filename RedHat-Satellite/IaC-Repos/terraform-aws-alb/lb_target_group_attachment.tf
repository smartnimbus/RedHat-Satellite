#------------------------------------------------------------------------------------------------------
# Resource         : aws_lb_target_group_attachment
# description      : Provides the ability to register instances and containers with a LB   target group
# module           : ELB (Elastic Load Balancing)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

resource "aws_lb_target_group_attachment" "this" {
  for_each = { for k, v in var.target_groups : k => v if var.create && lookup(v, "create_attachment", true) }

  target_group_arn  = aws_lb_target_group.this[each.key].arn
  target_id         = each.value.target_id
  port              = try(each.value.target_type, null) == "lambda" ? null : try(each.value.port, var.default_port)
  availability_zone = try(each.value.availability_zone, null)

  depends_on = [aws_lb_target_group.this]
}
