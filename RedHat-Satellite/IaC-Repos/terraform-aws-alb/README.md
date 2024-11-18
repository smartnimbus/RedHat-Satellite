<a href=""><img src="banner.png" alt="Project Banner"/></a><br/>
# ELB (Elastic Load Balancing) Modules

## Features

- [X] **lb:** Provides a Load Balancer resource.
- [X] **lb_listener:** Provides a Load Balancer Listener resource.
- [X] **lb_listener_certificate:** Provides a Load Balancer Listener Certificate resource.
- [X] **lb_listener_rule:** Provides a Load Balancer Listener Rule resource.
- [X] **lb_target_group:** Provides a Target Group resource for use with Load Balancers.
- [X] **lb_target_group_attachment:** Provides the ability to register instances and containers with a LB
  target group
- [ ] **lb_trust_store:** Provides a Trust Store resource for use with Load Balancers.
- [ ] **lb_trust_store_revocation:** Provides a Trust Store Revocation resource for use with Load Balancers.


## Components

### Data Sources
- `aws_partition.current`

### Resources
- `aws_aws_lb_trust_store.lb_trust_store`
- `aws_aws_lb_trust_store_revocation.lb_trust_store_revocation`
- `aws_aws_security_group.security_group`
- `aws_aws_security_group_rule.security_group_rule`
- `aws_aws_vpc_security_group_egress_rule.vpc_security_group_egress_rule`
- `aws_aws_vpc_security_group_ingress_rule.vpc_security_group_ingress_rule`
- `aws_lb.this`
- `aws_lb_listener.this`
- `aws_lb_listener_certificate.this`
- `aws_lb_listener_rule.this`
- `aws_lb_target_group.this`
- `aws_lb_target_group_attachment.this`

### Local Variables
- `additional_certs`
- `listener_rules`
- `tags`


### Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `access_logs` | Map containing access logging configuration for load balancer | map(string) | {} | No |
| `client_keep_alive` | Client keep alive value in seconds. The valid range is 60-604800 seconds. The default is 3600 seconds. | number | {} | No |
| `connection_logs` | Map containing access logging configuration for load balancer | map(string) | {} | No |
| `create` | Controls if resources should be created (affects nearly all resources) | bool | true | No |
| `create_security_group` | Determines if a security group is created | bool | true | No |
| `customer_owned_ipv4_pool` | The ID of the customer owned ipv4 pool to use for this load balancer | string | 80 | No |
| `default_port` | Default port used across the listener and target group | number | 80 | No |
| `default_protocol` | Default protocol used across the listener and target group | string | "HTTP" | No |
| `desync_mitigation_mode` | Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. Valid values are `monitor`, `defensive` (default), `strictest` | string | true | No |
| `dns_record_client_routing_policy` | Indicates how traffic is distributed among the load balancer Availability Zones. Possible values are any_availability_zone (default), availability_zone_affinity, or partial_availability_zone_affinity. Only valid for network type load balancers. | string | true | No |
| `drop_invalid_header_fields` | Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (`true`) or routed to targets (`false`). The default is `true`. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. Only valid for Load Balancers of type `application` | bool | true | No |
| `enable_cross_zone_load_balancing` | If `true`, cross-zone load balancing of the load balancer will be enabled. For application load balancer this feature is always enabled (`true`) and cannot be disabled. Defaults to `true` | bool | true | No |
| `enable_deletion_protection` | If `true`, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to `true` | bool | true | No |
| `enable_http2` | Indicates whether HTTP/2 is enabled in application load balancers. Defaults to `true` | bool | {} | No |
| `enable_tls_version_and_cipher_suite_headers` | Indicates whether the two headers (`x-amzn-tls-version` and `x-amzn-tls-cipher-suite`), which contain information about the negotiated TLS version and cipher suite, are added to the client request before sending it to the target. Only valid for Load Balancers of type `application`. Defaults to `false` | bool | {} | No |
| `enable_waf_fail_open` | Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. Defaults to `false` | bool | {} | No |
| `enable_xff_client_port` | Indicates whether the X-Forwarded-For header should preserve the source port that the client used to connect to the load balancer in `application` load balancers. Defaults to `false` | bool | {} | No |
| `enable_zonal_shift` | Whether zonal shift is enabled | bool | {} | No |
| `enforce_security_group_inbound_rules_on_private_link_traffic` | Indicates whether inbound security group rules are enforced for traffic originating from a PrivateLink. Only valid for Load Balancers of type network. The possible values are on and off. | string | {} | No |
| `idle_timeout` | The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type `application`. Default: `60` | number | {} | No |
| `internal` | If true, the LB will be internal. Defaults to `false` | bool | {} | No |
| `ip_address_type` | The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack` | string | {} | No |
| `listeners` | Map of listener configurations to create | any | {} | No |
| `load_balancer_type` | The type of load balancer to create. Possible values are `application`, `gateway`, or `network`. The default value is `application` | string | "application" | No |
| `name` | The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen | string | [] | No |
| `name_prefix` | Creates a unique name beginning with the specified prefix. Conflicts with `name` | string | [] | No |
| `preserve_host_header` | Indicates whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change. Defaults to `false` | bool | [] | No |
| `security_groups` | A list of security group IDs to assign to the LB | list(string) | [] | No |
| `subnet_mapping` | A list of subnet mapping blocks describing subnets to attach to load balancer | list(map(string)) | [] | No |
| `subnets` | A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type `network`. Changing this value for load balancers of type `network` will force a recreation of the resource | list(string) | {} | No |
| `tags` | A map of tags to add to all resources | map(string) | {} | No |
| `target_groups` | Map of target group configurations to create | any | {} | No |
| `timeouts` | Create, update, and delete timeout configurations for the load balancer | map(string) | {} | No |
| `vpc_id` | Identifier of the VPC where the security group will be created | string | N/A | Yes |
| `xff_header_processing_mode` | Determines how the load balancer modifies the X-Forwarded-For header in the HTTP request before sending the request to the target. The possible values are `append`, `preserve`, and `remove`. Only valid for Load Balancers of type `application`. The default is `append` | string | N/A | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `id` | The ID and ARN of the load balancer we created |
| `arn` | The ID and ARN of the load balancer we created |
| `arn_suffix` | ARN suffix of our load balancer - can be used with CloudWatch |
| `dns_name` | The DNS name of the load balancer |
| `zone_id` | The zone_id of the load balancer to assist with creating DNS records |
| `listeners` | Map of listeners created and their attributes |
| `listener_rules` | Map of listeners rules created and their attributes |
| `target_groups` | Map of target groups created and their attributes |
| `lb_listener_rule_id` | The ARN of the rule (matches `arn`) * `arn` - The ARN of the rule (matches `id`) * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `lb_target_group_arn_suffix` | ARN suffix for use with CloudWatch Metrics. * `arn` - ARN of the Target Group (matches `id`). * `id` - ARN of the Target Group (matches `arn`). * `name` - Name of the Target Group. * `load_balancer_arns` - ARNs of the Load Balancers associated with the Target Group. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `lb_target_group_attachment_id` | A unique identifier for the attachment. |
| `lb_trust_store_arn_suffix` | ARN suffix for use with CloudWatch Metrics. * `arn` - ARN of the Trust Store (matches `id`). * `id` - ARN of the Trust Store (matches `arn`). * `name` - Name of the Trust Store. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `lb_trust_store_revocation_revocation_id` | AWS assigned RevocationId, (number). * `id` - |
