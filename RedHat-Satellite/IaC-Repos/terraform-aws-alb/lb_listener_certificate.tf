#------------------------------------------------------------------------------------------------------
# Resource         : aws_lb_listener_certificate
# description      : Provides a Load Balancer Listener Certificate resource.
# module           : ELB (Elastic Load Balancing)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------


locals {
  # Take the list of `additional_certificate_arns` from the listener and create
  # a map entry that maps each certificate to the listener key. This map of maps
  # is then used to create the certificate resources.
  additional_certs = merge(values({
    for listener_key, listener_values in var.listeners : listener_key =>
    {
      # This will cause certs to be detached and reattached if certificate_arns
      # towards the front of the list are updated/removed. However, we need to have
      # unique keys on the resulting map and we can't have computed values (i.e. cert ARN)
      # in the key so we are using the array index as part of the key.
      for idx, cert_arn in lookup(listener_values, "additional_certificate_arns", []) :
      "${listener_key}/${idx}" => {
        listener_key    = listener_key
        certificate_arn = cert_arn
      }
    } if length(lookup(listener_values, "additional_certificate_arns", [])) > 0
  })...)
}

resource "aws_lb_listener_certificate" "this" {
  for_each = { for k, v in local.additional_certs : k => v if var.create }

  listener_arn    = aws_lb_listener.this[each.value.listener_key].arn
  certificate_arn = each.value.certificate_arn
}