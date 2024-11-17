# default_network_acl Module

## Features

- **default_network_acl:** ARN of the Default Network ACL * `id` - ID of the Default Network ACL * `owner_id` - ID of the AWS account that owns the Default Network ACL * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). * `vpc_id` -  ID of the associated VPC  [aws-network-acls]: http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ACLs.html

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `default_network_acl_id` | (Required) Network ACL ID to manage. This attribute is exported from `aws_vpc`, or manually found via the AWS Console. |  |
| `egress` | (Optional) Configuration block for an egress rule. Detailed below. |  |
| `ingress` | (Optional) Configuration block for an ingress rule. Detailed below. |  |
| `subnet_ids` | (Optional) List of Subnet IDs to apply the ACL to. See the notes above on Managing Subnets in the Default Network ACL |  |
| `tags` | (Optional) Map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `action` | (Required) The action to take. |  |
| `from_port` | (Required) The from port to match. |  |
| `protocol` | (Required) The protocol to match. If using the -1 'all' protocol, you must specify a from and to port of 0. |  |
| `rule_no` | (Required) The rule number. Used for ordering. |  |
| `to_port` | (Required) The to port to match. |  |
| `cidr_block` | (Optional) The CIDR block to match. This must be a valid network mask. |  |
| `icmp_code` | (Optional) The ICMP type code to be used. Default 0. |  |
| `icmp_type` | (Optional) The ICMP type to be used. Default 0. |  |
| `ipv6_cidr_block` | (Optional) The IPv6 CIDR block. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | ARN of the Default Network ACL |
| `id` | ID of the Default Network ACL |
| `owner_id` | ID of the AWS account that owns the Default Network ACL |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `vpc_id` | ID of the associated VPC |
# default_route_table Module

## Features

- **default_route_table:** ID of the route table. * `arn` - The ARN of the route table. * `owner_id` - ID of the AWS account that owns the route table. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). * `vpc_id` - ID of the VPC.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `default_route_table_id` | (Required) ID of the default route table. |  |
| `propagating_vgws` | (Optional) List of virtual gateways for propagation. |  |
| `route` | (Optional) Configuration block of routes. Detailed below. This argument is processed in [attribute-as-blocks mode](https://www.terraform.io/docs/configuration/attr-as-blocks.html). This means that omitting this argument is interpreted as ignoring any existing routes. To remove all managed routes an empty list should be specified. See the example above. |  |
| `tags` | (Optional) Map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `cidr_block` | (Required) The CIDR block of the route. |  |
| `ipv6_cidr_block` | (Optional) The Ipv6 CIDR block of the route |  |
| `destination_prefix_list_id` | (Optional) The ID of a [managed prefix list](ec2_managed_prefix_list.html) destination of the route. |  |
| `core_network_arn` | (Optional) The Amazon Resource Name (ARN) of a core network. |  |
| `egress_only_gateway_id` | (Optional) Identifier of a VPC Egress Only Internet Gateway. |  |
| `gateway_id` | (Optional) Identifier of a VPC internet gateway or a virtual private gateway. |  |
| `instance_id` | (Optional) Identifier of an EC2 instance. |  |
| `nat_gateway_id` | (Optional) Identifier of a VPC NAT gateway. |  |
| `network_interface_id` | (Optional) Identifier of an EC2 network interface. |  |
| `transit_gateway_id` | (Optional) Identifier of an EC2 Transit Gateway. |  |
| `vpc_endpoint_id` | (Optional) Identifier of a VPC Endpoint. This route must be removed prior to VPC Endpoint deletion. |  |
| `vpc_peering_connection_id` | (Optional) Identifier of a VPC peering connection. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | ID of the route table. |
| `arn` | The ARN of the route table. |
| `owner_id` | ID of the AWS account that owns the route table. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `vpc_id` | ID of the VPC. |
# default_security_group Module

## Features

- **default_security_group:** ARN of the security group. * `description` - Description of the security group. * `id` - ID of the security group. * `name` - Name of the security group. * `owner_id` - Owner ID. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).  [aws-default-security-groups]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#default-security-group

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `egress` | (Optional, VPC only) Configuration block. Detailed below. |  |
| `ingress` | (Optional) Configuration block. Detailed below. |  |
| `tags` | (Optional) Map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `vpc_id` | (Optional, Forces new resource) VPC ID. **Note that changing the `vpc_id` will _not_ restore any default security group rules that were modified, added, or removed.** It will be left in its current state. |  |
| `cidr_blocks` | (Optional) List of CIDR blocks. |  |
| `description` | (Optional) Description of this rule. |  |
| `from_port` | (Required) Start port (or ICMP type number if protocol is `icmp`) |  |
| `ipv6_cidr_blocks` | (Optional) List of IPv6 CIDR blocks. |  |
| `prefix_list_ids` | (Optional) List of prefix list IDs (for allowing access to VPC endpoints) |  |
| `protocol` | (Required) Protocol. If you select a protocol of "-1" (semantically equivalent to `all`, which is not a valid value here), you must specify a `from_port` and `to_port` equal to `0`. If not `icmp`, `tcp`, `udp`, or `-1` use the [protocol number](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml). |  |
| `security_groups` | (Optional) List of security groups. A group name can be used relative to the default VPC. Otherwise, group ID. |  |
| `self` | (Optional) Whether the security group itself will be added as a source to this egress rule. |  |
| `to_port` | (Required) End range port (or ICMP code if protocol is `icmp`). |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | ARN of the security group. |
| `description` | Description of the security group. |
| `id` | ID of the security group. |
| `name` | Name of the security group. |
| `owner_id` | Owner ID. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# default_subnet Module

## Features

- **default_subnet:** The AZ ID of the subnet * `cidr_block` - The IPv4 CIDR block assigned to the subnet * `vpc_id` - The ID of the VPC the subnet is in

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `force_destroy` | (Optional) Whether destroying the resource deletes the default subnet. Default: `false` |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `availability_zone_id` | The AZ ID of the subnet |
| `cidr_block` | The IPv4 CIDR block assigned to the subnet |
| `vpc_id` | The ID of the VPC the subnet is in |
# default_vpc Module

## Features

- **default_vpc:** The primary IPv4 CIDR block for the VPC * `instance_tenancy` - The allowed tenancy of instances launched into the VPC

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `force_destroy` | (Optional) Whether destroying the resource deletes the default VPC. Default: `false` |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `cidr_block` | The primary IPv4 CIDR block for the VPC |
| `instance_tenancy` | The allowed tenancy of instances launched into the VPC |
# default_vpc_dhcp_options Module

## Features

- **default_vpc_dhcp_options:** The ID of the DHCP Options Set. * `arn` - The ARN of the DHCP Options Set.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `netbios_name_servers` | (Optional) List of NETBIOS name servers. |  |
| `netbios_node_type` | (Optional) The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network. For more information about these node types, see [RFC 2132](http://www.ietf.org/rfc/rfc2132.txt). |  |
| `owner_id` | The ID of the AWS account that owns the DHCP options set. |  |
| `tags` | (Optional) A map of tags to assign to the resource. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the DHCP Options Set. |
| `arn` | The ARN of the DHCP Options Set. |
# ec2_managed_prefix_list Module

## Features

- **ec2_managed_prefix_list:** ARN of the prefix list. * `id` - ID of the prefix list. * `owner_id` - ID of the AWS account that owns this prefix list. * `tags_all` - Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). * `version` - Latest version of this prefix list.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `address_family` | (Required, Forces new resource) Address family (`IPv4` or `IPv6`) of this prefix list. |  |
| `entry` | (Optional) Configuration block for prefix list entry. Detailed below. Different entries may have overlapping CIDR blocks, but a particular CIDR should not be duplicated. |  |
| `max_entries` | (Required) Maximum number of entries that this prefix list can contain. |  |
| `name` | (Required) Name of this resource. The name must not start with `com.amazonaws`. |  |
| `tags` | (Optional) Map of tags to assign to this resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `cidr` | (Required) CIDR block of this entry. |  |
| `description` | (Optional) Description of this entry. Due to API limitations, updating only the description of an existing entry requires temporarily removing and re-adding the entry. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | ARN of the prefix list. |
| `id` | ID of the prefix list. |
| `owner_id` | ID of the AWS account that owns this prefix list. |
| `tags_all` | Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `version` | Latest version of this prefix list. |
# ec2_managed_prefix_list_entry Module

## Features

- **ec2_managed_prefix_list_entry:** ID of the managed prefix list entry.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `cidr` | (Required) CIDR block of this entry. |  |
| `description` | (Optional) Description of this entry. Please note that due to API limitations, updating only the description of an entry will require recreating the entry. |  |
| `prefix_list_id` | (Required) The ID of the prefix list. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | ID of the managed prefix list entry. |
# ec2_network_insights_analysis Module

## Features

- **ec2_network_insights_analysis:** Potential intermediate components of a feasible path. Described below. * `arn` - ARN of the Network Insights Analysis. * `explanations` - Explanation codes for an unreachable path. See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Explanation.html) for details. * `forward_path_components` - The components in the path from source to destination. See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PathComponent.html) for details. * `id` - ID of the Network Insights Analysis. * `path_found` - Set to `true` if the destination was reachable. * `return_path_components` - The components in the path from destination to source. See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PathComponent.html) for details. * `start_date` - The date/time the analysis was started. * `status` - The status of the analysis. `succeeded` means the analysis was completed, not that a path was found, for that see `path_found`. * `status_message` - A message to provide more context when the `status` is `failed`. * `tags_all` - Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](/docs/providers/aws/index.html#default_tags-configuration-block). * `warning_message` - The warning message.  The `alternate_path_hints` object supports the following:  * `component_arn` - The Amazon Resource Name (ARN) of the component. * `component_id` - The ID of the component.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `network_insights_path_id` | (Required) ID of the Network Insights Path to run an analysis on. |  |
| `filter_in_arns` | (Optional) A list of ARNs for resources the path must traverse. |  |
| `wait_for_completion` | (Optional) If enabled, the resource will wait for the Network Insights Analysis status to change to `succeeded` or `failed`. Setting this to `false` will skip the process. Default: `true`. |  |
| `tags` | (Optional) Map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](/docs/providers/aws/index.html#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `alternate_path_hints` | Potential intermediate components of a feasible path. Described below. |
| `arn` | ARN of the Network Insights Analysis. |
| `explanations` | Explanation codes for an unreachable path. See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_Explanation.html) for details. |
| `forward_path_components` | The components in the path from source to destination. See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PathComponent.html) for details. |
| `id` | ID of the Network Insights Analysis. |
| `path_found` | Set to `true` if the destination was reachable. |
| `return_path_components` | The components in the path from destination to source. See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_PathComponent.html) for details. |
| `start_date` | The date/time the analysis was started. |
| `status` | The status of the analysis. `succeeded` means the analysis was completed, not that a path was found, for that see `path_found`. |
| `status_message` | A message to provide more context when the `status` is `failed`. |
| `tags_all` | Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](/docs/providers/aws/index.html#default_tags-configuration-block). |
| `warning_message` | The warning message. |
| `component_arn` | The Amazon Resource Name (ARN) of the component. |
| `component_id` | The ID of the component. |
# ec2_network_insights_path Module

## Features

- **ec2_network_insights_path:** ARN of the Network Insights Path. * `destination_arn` - ARN of the destination. * `id` - ID of the Network Insights Path. * `source_arn` - ARN of the source. * `tags_all` - Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `source` | (Required) ID or ARN of the resource which is the source of the path. Can be an Instance, Internet Gateway, Network Interface, Transit Gateway, VPC Endpoint, VPC Peering Connection or VPN Gateway. If the resource is in another account, you must specify an ARN. |  |
| `destination` | (Optional) ID or ARN of the resource which is the destination of the path. Can be an Instance, Internet Gateway, Network Interface, Transit Gateway, VPC Endpoint, VPC Peering Connection or VPN Gateway. If the resource is in another account, you must specify an ARN. |  |
| `protocol` | (Required) Protocol to use for analysis. Valid options are `tcp` or `udp`. |  |
| `source_ip` | (Optional) IP address of the source resource. |  |
| `destination_ip` | (Optional) IP address of the destination resource. |  |
| `destination_port` | (Optional) Destination port to analyze access to. |  |
| `tags` | (Optional) Map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | ARN of the Network Insights Path. |
| `destination_arn` | ARN of the destination. |
| `id` | ID of the Network Insights Path. |
| `source_arn` | ARN of the source. |
| `tags_all` | Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# ec2_subnet_cidr_reservation Module

## Features

- **ec2_subnet_cidr_reservation:** ID of the CIDR reservation. * `owner_id` - ID of the AWS account that owns this CIDR reservation.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `cidr_block` | (Required) The CIDR block for the reservation. |  |
| `reservation_type` | (Required) The type of reservation to create. Valid values: `explicit`, `prefix` |  |
| `subnet_id` | (Required) The ID of the subnet to create the reservation for. |  |
| `description` | (Optional) A brief description of the reservation. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | ID of the CIDR reservation. |
| `owner_id` | ID of the AWS account that owns this CIDR reservation. |
# ec2_traffic_mirror_filter Module

## Features

- **ec2_traffic_mirror_filter:** The ARN of the traffic mirror filter. * `id` - The name of the filter. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `description` | (Optional, Forces new resource) A description of the filter. |  |
| `network_services` | (Optional) List of amazon network services that should be mirrored. Valid values: `amazon-dns`. |  |
| `tags` | (Optional) Key-value map of resource tags. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | The ARN of the traffic mirror filter. |
| `id` | The name of the filter. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# ec2_traffic_mirror_filter_rule Module

## Features

- **ec2_traffic_mirror_filter_rule:** ARN of the traffic mirror filter rule. * `id` - Name of the traffic mirror filter rule.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `description` | (Optional) Description of the traffic mirror filter rule. |  |
| `destination_cidr_block` | (Required) Destination CIDR block to assign to the Traffic Mirror rule. |  |
| `destination_port_range` | (Optional) Destination port range. Supported only when the protocol is set to TCP(6) or UDP(17). See Traffic mirror port range documented below |  |
| `protocol` | (Optional) Protocol number, for example 17 (UDP), to assign to the Traffic Mirror rule. For information about the protocol value, see [Protocol Numbers](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml) on the Internet Assigned Numbers Authority (IANA) website. |  |
| `rule_action` | (Required) Action to take (accept | reject) on the filtered traffic. Valid values are `accept` and `reject` |  |
| `rule_number` | (Required) Number of the Traffic Mirror rule. This number must be unique for each Traffic Mirror rule in a given direction. The rules are processed in ascending order by rule number. |  |
| `source_cidr_block` | (Required) Source CIDR block to assign to the Traffic Mirror rule. |  |
| `source_port_range` | (Optional) Source port range. Supported only when the protocol is set to TCP(6) or UDP(17). See Traffic mirror port range documented below |  |
| `traffic_direction` | (Required) Direction of traffic to be captured. Valid values are `ingress` and `egress` |  |
| `from_port` | (Optional) Starting port of the range |  |
| `to_port` | (Optional) Ending port of the range |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | ARN of the traffic mirror filter rule. |
| `id` | Name of the traffic mirror filter rule. |
# ec2_traffic_mirror_session Module

## Features

- **ec2_traffic_mirror_session:** The ARN of the traffic mirror session. * `id` - The name of the session. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). * `owner_id` - The AWS account ID of the session owner.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `description` | (Optional) A description of the traffic mirror session. |  |
| `network_interface_id` | (Required, Forces new) ID of the source network interface. Not all network interfaces are eligible as mirror sources. On EC2 instances only nitro based instances support mirroring. |  |
| `traffic_mirror_target_id` | (Required) ID of the traffic mirror target to be used |  |
| `packet_length` | (Optional) The number of bytes in each packet to mirror. These are bytes after the VXLAN header. Do not specify this parameter when you want to mirror the entire packet. To mirror a subset of the packet, set this to the length (in bytes) that you want to mirror. |  |
| `session_number` | (Required) - The session number determines the order in which sessions are evaluated when an interface is used by multiple sessions. The first session with a matching filter is the one that mirrors the packets. |  |
| `virtual_network_id` | (Optional) - The VXLAN ID for the Traffic Mirror session. For more information about the VXLAN protocol, see RFC 7348. If you do not specify a VirtualNetworkId, an account-wide unique id is chosen at random. |  |
| `tags` | (Optional) Key-value map of resource tags. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | The ARN of the traffic mirror session. |
| `id` | The name of the session. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `owner_id` | The AWS account ID of the session owner. |
# ec2_traffic_mirror_target Module

## Features

- **ec2_traffic_mirror_target:** The ID of the Traffic Mirror target. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). * `arn` - The ARN of the traffic mirror target. * `owner_id` - The ID of the AWS account that owns the traffic mirror target.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `description` | (Optional, Forces new) A description of the traffic mirror session. |  |
| `network_interface_id` | (Optional, Forces new) The network interface ID that is associated with the target. |  |
| `network_load_balancer_arn` | (Optional, Forces new) The Amazon Resource Name (ARN) of the Network Load Balancer that is associated with the target. |  |
| `gateway_load_balancer_endpoint_id` | (Optional, Forces new) The VPC Endpoint Id of the Gateway Load Balancer that is associated with the target. |  |
| `tags` | (Optional) Key-value map of resource tags. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the Traffic Mirror target. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `arn` | The ARN of the traffic mirror target. |
| `owner_id` | The ID of the AWS account that owns the traffic mirror target. |
# egress_only_internet_gateway Module

## Features

- **egress_only_internet_gateway:** The ID of the egress-only Internet gateway. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_id` | (Required) The VPC ID to create in. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the egress-only Internet gateway. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# flow_log Module

## Features

- **flow_log:** The Flow Log ID * `arn` - The ARN of the Flow Log. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `traffic_type` | (Required) The type of traffic to capture. Valid values: `ACCEPT`,`REJECT`, `ALL`. |  |
| `deliver_cross_account_role` | (Optional) ARN of the IAM role that allows Amazon EC2 to publish flow logs across accounts. |  |
| `eni_id` | (Optional) Elastic Network Interface ID to attach to |  |
| `iam_role_arn` | (Optional) The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group |  |
| `log_destination_type` | (Optional) The type of the logging destination. Valid values: `cloud-watch-logs`, `s3`, `kinesis-data-firehose`. Default: `cloud-watch-logs`. |  |
| `log_destination` | (Optional) The ARN of the logging destination. Either `log_destination` or `log_group_name` must be set. |  |
| `log_group_name` | (Optional) **Deprecated:** Use `log_destination` instead. The name of the CloudWatch log group. Either `log_group_name` or `log_destination` must be set. |  |
| `subnet_id` | (Optional) Subnet ID to attach to |  |
| `transit_gateway_id` | (Optional) Transit Gateway ID to attach to |  |
| `transit_gateway_attachment_id` | (Optional) Transit Gateway Attachment ID to attach to |  |
| `vpc_id` | (Optional) VPC ID to attach to |  |
| `log_format` | (Optional) The fields to include in the flow log record. Accepted format example: `"$${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport}"`. |  |
| `max_aggregation_interval` | (Optional) The maximum interval of time |  |
| `destination_options` | (Optional) Describes the destination options for a flow log. More details below. |  |
| `tags` | (Optional) Key-value map of resource tags. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `file_format` | (Optional) The format for the flow log. Default value: `plain-text`. Valid values: `plain-text`, `parquet`. |  |
| `hive_compatible_partitions` | (Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3. Default value: `false`. |  |
| `per_hour_partition` | (Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries. Default value: `false`. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The Flow Log ID |
| `arn` | The ARN of the Flow Log. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# internet_gateway Module

## Features

- **internet_gateway:** The ID of the Internet Gateway. * `arn` - The ARN of the Internet Gateway. * `owner_id` - The ID of the AWS account that owns the internet gateway. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_id` | (Optional) The VPC ID to create in.  See the [aws_internet_gateway_attachment](internet_gateway_attachment.html) resource for an alternate way to attach an Internet Gateway to a VPC. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the Internet Gateway. |
| `arn` | The ARN of the Internet Gateway. |
| `owner_id` | The ID of the AWS account that owns the internet gateway. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# internet_gateway_attachment Module

## Features

- **internet_gateway_attachment:** The ID of the VPC and Internet Gateway separated by a colon.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `internet_gateway_id` | (Required) The ID of the internet gateway. |  |
| `vpc_id` | (Required) The ID of the VPC. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC and Internet Gateway separated by a colon. |
# main_route_table_association Module

## Features

- **main_route_table_association:** The ID of the Route Table Association * `original_route_table_id` - Used internally, see __Notes__ below

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_id` | (Required) The ID of the VPC whose main route table should be set |  |
| `route_table_id` | (Required) The ID of the Route Table to set as the new |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the Route Table Association |
| `original_route_table_id` | Used internally, see __Notes__ below |
# nat_gateway Module

## Features

- **nat_gateway:** The association ID of the Elastic IP address that's associated with the NAT Gateway. Only available when `connectivity_type` is `public`. * `id` - The ID of the NAT Gateway. * `network_interface_id` - The ID of the network interface associated with the NAT Gateway. * `public_ip` - The Elastic IP address associated with the NAT Gateway. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `allocation_id` | (Optional) The Allocation ID of the Elastic IP address for the NAT Gateway. Required for `connectivity_type` of `public`. |  |
| `connectivity_type` | (Optional) Connectivity type for the NAT Gateway. Valid values are `private` and `public`. Defaults to `public`. |  |
| `private_ip` | (Optional) The private IPv4 address to assign to the NAT Gateway. If you don't provide an address, a private IPv4 address will be automatically assigned. |  |
| `subnet_id` | (Required) The Subnet ID of the subnet in which to place the NAT Gateway. |  |
| `secondary_allocation_ids` | (Optional) A list of secondary allocation EIP IDs for this NAT Gateway. |  |
| `secondary_private_ip_address_count` | (Optional) [Private NAT Gateway only] The number of secondary private IPv4 addresses you want to assign to the NAT Gateway. |  |
| `secondary_private_ip_addresses` | (Optional) A list of secondary private IPv4 addresses to assign to the NAT Gateway. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `association_id` | The association ID of the Elastic IP address that's associated with the NAT Gateway. Only available when `connectivity_type` is `public`. |
| `id` | The ID of the NAT Gateway. |
| `network_interface_id` | The ID of the network interface associated with the NAT Gateway. |
| `public_ip` | The Elastic IP address associated with the NAT Gateway. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# network_acl Module

## Features

- **network_acl:** The ID of the network ACL * `arn` - The ARN of the network ACL * `owner_id` - The ID of the AWS account that owns the network ACL. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_id` | (Required) The ID of the associated VPC. |  |
| `subnet_ids` | (Optional) A list of Subnet IDs to apply the ACL to |  |
| `ingress` | (Optional) Specifies an ingress rule. Parameters defined below. |  |
| `egress` | (Optional) Specifies an egress rule. Parameters defined below. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `from_port` | (Required) The from port to match. |  |
| `to_port` | (Required) The to port to match. |  |
| `rule_no` | (Required) The rule number. Used for ordering. |  |
| `action` | (Required) The action to take. |  |
| `protocol` | (Required) The protocol to match. If using the -1 'all' |  |
| `cidr_block` | (Optional) The CIDR block to match. This must be a |  |
| `ipv6_cidr_block` | (Optional) The IPv6 CIDR block. |  |
| `icmp_type` | (Optional) The ICMP type to be used. Default 0. |  |
| `icmp_code` | (Optional) The ICMP type code to be used. Default 0. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the network ACL |
| `arn` | The ARN of the network ACL |
| `owner_id` | The ID of the AWS account that owns the network ACL. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# network_acl_association Module

## Features

- **network_acl_association:** The ID of the network ACL association

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `network_acl_id` | (Required) The ID of the network ACL. |  |
| `subnet_id` | (Required) The ID of the associated Subnet. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the network ACL association |
# network_acl_rule Module

## Features

- **network_acl_rule:** The ID of the network ACL Rule

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `network_acl_id` | (Required) The ID of the network ACL. |  |
| `rule_number` | (Required) The rule number for the entry (for example, 100). ACL entries are processed in ascending order by rule number. |  |
| `egress` | (Optional, bool) Indicates whether this is an egress rule (rule is applied to traffic leaving the subnet). Default `false`. |  |
| `protocol` | (Required) The protocol. A value of -1 means all protocols. |  |
| `rule_action` | (Required) Indicates whether to allow or deny the traffic that matches the rule. Accepted values: `allow` | `deny` |  |
| `cidr_block` | (Optional) The network range to allow or deny, in CIDR notation (for example 172.16.0.0/24 ). |  |
| `ipv6_cidr_block` | (Optional) The IPv6 CIDR block to allow or deny. |  |
| `from_port` | (Optional) The from port to match. |  |
| `to_port` | (Optional) The to port to match. |  |
| `icmp_type` | (Optional) ICMP protocol: The ICMP type. Required if specifying ICMP for the protocolE.g., -1 |  |
| `icmp_code` | (Optional) ICMP protocol: The ICMP code. Required if specifying ICMP for the protocolE.g., -1 |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the network ACL Rule |
# network_interface Module

## Features

- **network_interface:** ARN of the network interface. * `id` - ID of the network interface. * `mac_address` - MAC address of the network interface. * `owner_id` - AWS account ID of the owner of the network interface. * `private_dns_name` - Private DNS name of the network interface (IPv4). * `tags_all` - Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `subnet_id` | (Required) Subnet ID to create the ENI in. |  |
| `attachment` | (Optional) Configuration block to define the attachment of the ENI. See [Attachment](#attachment) below for more details! |  |
| `description` | (Optional) Description for the network interface. |  |
| `interface_type` | (Optional) Type of network interface to create. Set to `efa` for Elastic Fabric Adapter. Changing `interface_type` will cause the resource to be destroyed and re-created. |  |
| `ipv4_prefix_count` | (Optional) Number of IPv4 prefixes that AWS automatically assigns to the network interface. |  |
| `ipv4_prefixes` | (Optional) One or more IPv4 prefixes assigned to the network interface. |  |
| `ipv6_address_count` | (Optional) Number of IPv6 addresses to assign to a network interface. You can't use this option if specifying specific `ipv6_addresses`. If your subnet has the AssignIpv6AddressOnCreation attribute set to `true`, you can specify `0` to override this setting. |  |
| `ipv6_address_list_enabled` | (Optional) Whether `ipv6_address_list` is allowed and controls the IPs to assign to the ENI and `ipv6_addresses` and `ipv6_address_count` become read-only. Default false. |  |
| `ipv6_address_list` | (Optional) List of private IPs to assign to the ENI in sequential order. |  |
| `ipv6_addresses` | (Optional) One or more specific IPv6 addresses from the IPv6 CIDR block range of your subnet. Addresses are assigned without regard to order. You can't use this option if you're specifying `ipv6_address_count`. |  |
| `ipv6_prefix_count` | (Optional) Number of IPv6 prefixes that AWS automatically assigns to the network interface. |  |
| `ipv6_prefixes` | (Optional) One or more IPv6 prefixes assigned to the network interface. |  |
| `private_ip_list` | (Optional) List of private IPs to assign to the ENI in sequential order. Requires setting `private_ip_list_enabled` to `true`. |  |
| `private_ip_list_enabled` | (Optional) Whether `private_ip_list` is allowed and controls the IPs to assign to the ENI and `private_ips` and `private_ips_count` become read-only. Default false. |  |
| `private_ips` | (Optional) List of private IPs to assign to the ENI without regard to order. |  |
| `private_ips_count` | (Optional) Number of secondary private IPs to assign to the ENI. The total number of private IPs will be 1 + `private_ips_count`, as a primary private IP will be assiged to an ENI by default. |  |
| `security_groups` | (Optional) List of security group IDs to assign to the ENI. |  |
| `source_dest_check` | (Optional) Whether to enable source destination checking for the ENI. Default true. |  |
| `tags` | (Optional) Map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `instance` | (Required) ID of the instance to attach to. |  |
| `device_index` | (Required) Integer to define the devices index. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | ARN of the network interface. |
| `id` | ID of the network interface. |
| `mac_address` | MAC address of the network interface. |
| `owner_id` | AWS account ID of the owner of the network interface. |
| `private_dns_name` | Private DNS name of the network interface (IPv4). |
| `tags_all` | Map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# network_interface_attachment Module

## Features

- **network_interface_attachment:** Instance ID. * `network_interface_id` - Network interface ID. * `attachment_id` - The ENI Attachment ID. * `status` - The status of the Network Interface Attachment.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `instance_id` | (Required) Instance ID to attach. |  |
| `network_interface_id` | (Required) ENI ID to attach. |  |
| `device_index` | (Required) Network interface index (int). |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `instance_id` | Instance ID. |
| `network_interface_id` | Network interface ID. |
| `attachment_id` | The ENI Attachment ID. |
| `status` | The status of the Network Interface Attachment. |
# network_interface_sg_attachment Module

## Features

- **network_interface_sg_attachment:** (Required) The ID of the security group. * `network_interface_id` - (Required) The ID of the network interface to attach to.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `security_group_id` | (Required) The ID of the security group. |  |
| `network_interface_id` | (Required) The ID of the network interface to attach to. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
# route Module

## Features

- **route:** Route identifier computed from the routing table identifier and route destination. * `instance_id` - Identifier of an EC2 instance. * `instance_owner_id` - The AWS account ID of the owner of the EC2 instance. * `origin` - How the route was created - `CreateRouteTable`, `CreateRoute` or `EnableVgwRoutePropagation`. * `state` - The state of the route - `active` or `blackhole`.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `route_table_id` | (Required) The ID of the routing table. |  |
| `destination_cidr_block` | (Optional) The destination CIDR block. |  |
| `destination_ipv6_cidr_block` | (Optional) The destination IPv6 CIDR block. |  |
| `destination_prefix_list_id` | (Optional) The ID of a [managed prefix list](ec2_managed_prefix_list.html) destination. |  |
| `carrier_gateway_id` | (Optional) Identifier of a carrier gateway. This attribute can only be used when the VPC contains a subnet which is associated with a Wavelength Zone. |  |
| `core_network_arn` | (Optional) The Amazon Resource Name (ARN) of a core network. |  |
| `egress_only_gateway_id` | (Optional) Identifier of a VPC Egress Only Internet Gateway. |  |
| `gateway_id` | (Optional) Identifier of a VPC internet gateway or a virtual private gateway. Specify `local` when updating a previously [imported](#import) local route. |  |
| `nat_gateway_id` | (Optional) Identifier of a VPC NAT gateway. |  |
| `local_gateway_id` | (Optional) Identifier of a Outpost local gateway. |  |
| `network_interface_id` | (Optional) Identifier of an EC2 network interface. |  |
| `transit_gateway_id` | (Optional) Identifier of an EC2 Transit Gateway. |  |
| `vpc_endpoint_id` | (Optional) Identifier of a VPC Endpoint. |  |
| `vpc_peering_connection_id` | (Optional) Identifier of a VPC peering connection. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | Route identifier computed from the routing table identifier and route destination. |
| `instance_id` | Identifier of an EC2 instance. |
| `instance_owner_id` | The AWS account ID of the owner of the EC2 instance. |
| `origin` | How the route was created - `CreateRouteTable`, `CreateRoute` or `EnableVgwRoutePropagation`. |
| `state` | The state of the route - `active` or `blackhole`. |
# route_table Module

## Features

- **route_table:** The ID of the routing table. * `arn` - The ARN of the route table. * `owner_id` - The ID of the AWS account that owns the route table. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_id` | (Required) The VPC ID. |  |
| `route` | (Optional) A list of route objects. Their keys are documented below. This argument is processed in [attribute-as-blocks mode](https://www.terraform.io/docs/configuration/attr-as-blocks.html). |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `propagating_vgws` | (Optional) A list of virtual gateways for propagation. |  |
| `cidr_block` | (Required) The CIDR block of the route. |  |
| `ipv6_cidr_block` | (Optional) The Ipv6 CIDR block of the route. |  |
| `destination_prefix_list_id` | (Optional) The ID of a [managed prefix list](ec2_managed_prefix_list.html) destination of the route. |  |
| `carrier_gateway_id` | (Optional) Identifier of a carrier gateway. This attribute can only be used when the VPC contains a subnet which is associated with a Wavelength Zone. |  |
| `core_network_arn` | (Optional) The Amazon Resource Name (ARN) of a core network. |  |
| `egress_only_gateway_id` | (Optional) Identifier of a VPC Egress Only Internet Gateway. |  |
| `gateway_id` | (Optional) Identifier of a VPC internet gateway, virtual private gateway, or `local`. `local` routes cannot be created but can be adopted or imported. See the [example](#adopting-an-existing-local-route) above. |  |
| `local_gateway_id` | (Optional) Identifier of a Outpost local gateway. |  |
| `nat_gateway_id` | (Optional) Identifier of a VPC NAT gateway. |  |
| `network_interface_id` | (Optional) Identifier of an EC2 network interface. |  |
| `transit_gateway_id` | (Optional) Identifier of an EC2 Transit Gateway. |  |
| `vpc_endpoint_id` | (Optional) Identifier of a VPC Endpoint. |  |
| `vpc_peering_connection_id` | (Optional) Identifier of a VPC peering connection. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the routing table. |
| `arn` | The ARN of the route table. |
| `owner_id` | The ID of the AWS account that owns the route table. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# route_table_association Module

## Features

- **route_table_association:** The ID of the association

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `subnet_id` | (Optional) The subnet ID to create an association. Conflicts with `gateway_id`. |  |
| `gateway_id` | (Optional) The gateway ID to create an association. Conflicts with `subnet_id`. |  |
| `route_table_id` | (Required) The ID of the routing table to associate with. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the association |
# security_group Module

## Features

- **security_group:** ARN of the security group. * `id` - ID of the security group. * `owner_id` - Owner ID. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `description` | (Optional, Forces new resource) Security group description. Defaults to `Managed by Terraform`. Cannot be `""`. **NOTE**: This field maps to the AWS `GroupDescription` attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use `tags`. |  |
| `egress` | (Optional, VPC only) Configuration block for egress rules. Can be specified multiple times for each egress rule. Each egress block supports fields documented below. This argument is processed in [attribute-as-blocks mode](https://www.terraform.io/docs/configuration/attr-as-blocks.html). |  |
| `ingress` | (Optional) Configuration block for ingress rules. Can be specified multiple times for each ingress rule. Each ingress block supports fields documented below. This argument is processed in [attribute-as-blocks mode](https://www.terraform.io/docs/configuration/attr-as-blocks.html). |  |
| `name_prefix` | (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with `name`. |  |
| `name` | (Optional, Forces new resource) Name of the security group. If omitted, Terraform will assign a random, unique name. |  |
| `revoke_rules_on_delete` | (Optional) Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. Default `false`. |  |
| `tags` | (Optional) Map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `vpc_id` | (Optional, Forces new resource) VPC ID. Defaults to the region's default VPC. |  |
| `from_port` | (Required) Start port (or ICMP type number if protocol is `icmp` or `icmpv6`). |  |
| `to_port` | (Required) End range port (or ICMP code if protocol is `icmp`). |  |
| `protocol` | (Required) Protocol. If you select a protocol of `-1` (semantically equivalent to `all`, which is not a valid value here), you must specify a `from_port` and `to_port` equal to 0. The supported values are defined in the `IpProtocol` argument on the [IpPermission](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_IpPermission.html) API reference. This argument is normalized to a lowercase value to match the AWS API requirement when using with Terraform 0.12.x and above, please make sure that the value of the protocol is specified as lowercase when using with older version of Terraform to avoid an issue during upgrade. |  |
| `cidr_blocks` | (Optional) List of CIDR blocks. |  |
| `description` | (Optional) Description of this ingress rule. |  |
| `ipv6_cidr_blocks` | (Optional) List of IPv6 CIDR blocks. |  |
| `prefix_list_ids` | (Optional) List of Prefix List IDs. |  |
| `security_groups` | (Optional) List of security groups. A group name can be used relative to the default VPC. Otherwise, group ID. |  |
| `self` | (Optional) Whether the security group itself will be added as a source to this ingress rule. |  |
| `from_port` | (Required) Start port (or ICMP type number if protocol is `icmp`) |  |
| `to_port` | (Required) End range port (or ICMP code if protocol is `icmp`). |  |
| `cidr_blocks` | (Optional) List of CIDR blocks. |  |
| `description` | (Optional) Description of this egress rule. |  |
| `ipv6_cidr_blocks` | (Optional) List of IPv6 CIDR blocks. |  |
| `prefix_list_ids` | (Optional) List of Prefix List IDs. |  |
| `protocol` | (Required) Protocol. If you select a protocol of `-1` (semantically equivalent to `all`, which is not a valid value here), you must specify a `from_port` and `to_port` equal to 0. The supported values are defined in the `IpProtocol` argument in the [IpPermission](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_IpPermission.html) API reference. This argument is normalized to a lowercase value to match the AWS API requirement when using Terraform 0.12.x and above. Please make sure that the value of the protocol is specified as lowercase when used with older version of Terraform to avoid issues during upgrade. |  |
| `security_groups` | (Optional) List of security groups. A group name can be used relative to the default VPC. Otherwise, group ID. |  |
| `self` | (Optional) Whether the security group itself will be added as a source to this egress rule. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | ARN of the security group. |
| `id` | ID of the security group. |
| `owner_id` | Owner ID. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# security_group_rule Module

## Features

- **security_group_rule:** ID of the security group rule. * `security_group_rule_id` - If the `aws_security_group_rule` resource has a single source or destination then this is the AWS Security Group Rule resource ID. Otherwise it is empty.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `from_port` | (Required) Start port (or ICMP type number if protocol is "icmp" or "icmpv6"). |  |
| `protocol` | (Required) Protocol. If not icmp, icmpv6, tcp, udp, or all use the [protocol number](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml) |  |
| `security_group_id` | (Required) Security group to apply this rule to. |  |
| `to_port` | (Required) End port (or ICMP code if protocol is "icmp"). |  |
| `type` | (Required) Type of rule being created. Valid options are `ingress` (inbound) |  |
| `cidr_blocks` | (Optional) List of CIDR blocks. Cannot be specified with `source_security_group_id` or `self`. |  |
| `description` | (Optional) Description of the rule. |  |
| `ipv6_cidr_blocks` | (Optional) List of IPv6 CIDR blocks. Cannot be specified with `source_security_group_id` or `self`. |  |
| `prefix_list_ids` | (Optional) List of Prefix List IDs. |  |
| `self` | (Optional) Whether the security group itself will be added as a source to this ingress rule. Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks`, or `source_security_group_id`. |  |
| `source_security_group_id` | (Optional) Security group id to allow access to/from, depending on the `type`. Cannot be specified with `cidr_blocks`, `ipv6_cidr_blocks`, or `self`. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | ID of the security group rule. |
| `security_group_rule_id` | If the `aws_security_group_rule` resource has a single source or destination then this is the AWS Security Group Rule resource ID. Otherwise it is empty. |
# subnet Module

## Features

- **subnet:** The ID of the subnet * `arn` - The ARN of the subnet. * `ipv6_cidr_block_association_id` - The association ID for the IPv6 CIDR block. * `owner_id` - The ID of the AWS account that owns the subnet. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `assign_ipv6_address_on_creation` | (Optional) Specify true to indicate |  |
| `availability_zone` | (Optional) AZ for the subnet. |  |
| `availability_zone_id` | (Optional) AZ ID of the subnet. This argument is not supported in all regions or partitions. If necessary, use `availability_zone` instead. |  |
| `cidr_block` | (Optional) The IPv4 CIDR block for the subnet. |  |
| `customer_owned_ipv4_pool` | (Optional) The customer owned IPv4 address pool. Typically used with the `map_customer_owned_ip_on_launch` argument. The `outpost_arn` argument must be specified when configured. |  |
| `enable_dns64` | (Optional) Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations. Default: `false`. |  |
| `enable_lni_at_device_index` | (Optional) Indicates the device position for local network interfaces in this subnet. For example, 1 indicates local network interfaces in this subnet are the secondary network interface (eth1). A local network interface cannot be the primary network interface (eth0). |  |
| `enable_resource_name_dns_aaaa_record_on_launch` | (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records. Default: `false`. |  |
| `enable_resource_name_dns_a_record_on_launch` | (Optional) Indicates whether to respond to DNS queries for instance hostnames with DNS A records. Default: `false`. |  |
| `ipv6_cidr_block` | (Optional) The IPv6 network range for the subnet, |  |
| `ipv6_native` | (Optional) Indicates whether to create an IPv6-only subnet. Default: `false`. |  |
| `map_customer_owned_ip_on_launch` | (Optional) Specify `true` to indicate that network interfaces created in the subnet should be assigned a customer owned IP address. The `customer_owned_ipv4_pool` and `outpost_arn` arguments must be specified when set to `true`. Default is `false`. |  |
| `map_public_ip_on_launch` | (Optional) Specify true to indicate |  |
| `outpost_arn` | (Optional) The Amazon Resource Name (ARN) of the Outpost. |  |
| `private_dns_hostname_type_on_launch` | (Optional) The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: `ip-name`, `resource-name`. |  |
| `vpc_id` | (Required) The VPC ID. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the subnet |
| `arn` | The ARN of the subnet. |
| `ipv6_cidr_block_association_id` | The association ID for the IPv6 CIDR block. |
| `owner_id` | The ID of the AWS account that owns the subnet. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# vpc Module

## Features

- **vpc:** Amazon Resource Name (ARN) of VPC * `id` - The ID of the VPC * `instance_tenancy` - Tenancy of instances spin up within VPC * `dhcp_options_id` - DHCP options id of the desired VPC. * `enable_dns_support` - Whether or not the VPC has DNS support * `enable_network_address_usage_metrics` - Whether Network Address Usage metrics are enabled for the VPC * `enable_dns_hostnames` - Whether or not the VPC has DNS hostname support * `main_route_table_id` - The ID of the main route table associated with      this VPC. Note that you can change a VPC's main route table by using an      [`aws_main_route_table_association`](/docs/providers/aws/r/main_route_table_association.html). * `default_network_acl_id` - The ID of the network ACL created by default on VPC creation * `default_security_group_id` - The ID of the security group created by default on VPC creation * `default_route_table_id` - The ID of the route table created by default on VPC creation * `ipv6_association_id` - The association ID for the IPv6 CIDR block. * `ipv6_cidr_block_network_border_group` - The Network Border Group Zone name * `owner_id` - The ID of the AWS account that owns the VPC. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `cidr_block` | (Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length`. |  |
| `instance_tenancy` | (Optional) A tenancy option for instances launched into the VPC. Default is `default`, which ensures that EC2 instances launched in this VPC use the EC2 instance tenancy attribute specified when the EC2 instance is launched. The only other option is `dedicated`, which ensures that EC2 instances launched in this VPC are run on dedicated tenancy instances regardless of the tenancy attribute specified at launch. This has a dedicated per region fee of $2 per hour, plus an hourly per instance usage fee. |  |
| `ipv4_ipam_pool_id` | (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. IPAM is a VPC feature that you can use to automate your IP address management workflows including assigning, tracking, troubleshooting, and auditing IP addresses across AWS Regions and accounts. Using IPAM you can monitor IP address usage throughout your AWS Organization. |  |
| `ipv4_netmask_length` | (Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a `ipv4_ipam_pool_id`. |  |
| `ipv6_cidr_block` | (Optional) IPv6 CIDR block to request from an IPAM Pool. Can be set explicitly or derived from IPAM using `ipv6_netmask_length`. |  |
| `ipv6_ipam_pool_id` | (Optional) IPAM Pool ID for a IPv6 pool. Conflicts with `assign_generated_ipv6_cidr_block`. |  |
| `ipv6_netmask_length` | (Optional) Netmask length to request from IPAM Pool. Conflicts with `ipv6_cidr_block`. This can be omitted if IPAM pool as a `allocation_default_netmask_length` set. Valid values are from `44` to `60` in increments of 4. |  |
| `ipv6_cidr_block_network_border_group` | (Optional) By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC. This can be changed to restrict advertisement of public addresses to specific Network Border Groups such as LocalZones. |  |
| `enable_dns_support` | (Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults to true. |  |
| `enable_network_address_usage_metrics` | (Optional) Indicates whether Network Address Usage metrics are enabled for your VPC. Defaults to false. |  |
| `enable_dns_hostnames` | (Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false. |  |
| `assign_generated_ipv6_cidr_block` | (Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is `false`. Conflicts with `ipv6_ipam_pool_id` |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | Amazon Resource Name (ARN) of VPC |
| `id` | The ID of the VPC |
| `instance_tenancy` | Tenancy of instances spin up within VPC |
| `dhcp_options_id` | DHCP options id of the desired VPC. |
| `enable_dns_support` | Whether or not the VPC has DNS support |
| `enable_network_address_usage_metrics` | Whether Network Address Usage metrics are enabled for the VPC |
| `enable_dns_hostnames` | Whether or not the VPC has DNS hostname support |
| `main_route_table_id` | The ID of the main route table associated with |
| `default_network_acl_id` | The ID of the network ACL created by default on VPC creation |
| `default_security_group_id` | The ID of the security group created by default on VPC creation |
| `default_route_table_id` | The ID of the route table created by default on VPC creation |
| `ipv6_association_id` | The association ID for the IPv6 CIDR block. |
| `ipv6_cidr_block_network_border_group` | The Network Border Group Zone name |
| `owner_id` | The ID of the AWS account that owns the VPC. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# vpc_dhcp_options Module

## Features

- **vpc_dhcp_options:** The ID of the DHCP Options Set. * `arn` - The ARN of the DHCP Options Set. * `owner_id` - The ID of the AWS account that owns the DHCP options set. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).  You can find more technical documentation about DHCP Options Set in the official [AWS User Guide](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_DHCP_Options.html).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `domain_name` | (Optional) the suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the `search` value in the `/etc/resolv.conf` file. |  |
| `domain_name_servers` | (Optional) List of name servers to configure in `/etc/resolv.conf`. If you want to use the default AWS nameservers you should set this to `AmazonProvidedDNS`. |  |
| `ipv6_address_preferred_lease_time` | (Optional) How frequently, in seconds, a running instance with an IPv6 assigned to it goes through DHCPv6 lease renewal. Acceptable values are between 140 and 2147483647 (approximately 68 years). If no value is entered, the default lease time is 140 seconds. If you use long-term addressing for EC2 instances, you can increase the lease time and avoid frequent lease renewal requests. Lease renewal typically occurs when half of the lease time has elapsed. |  |
| `ntp_servers` | (Optional) List of NTP servers to configure. |  |
| `netbios_name_servers` | (Optional) List of NETBIOS name servers. |  |
| `netbios_node_type` | (Optional) The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network. For more information about these node types, see [RFC 2132](http://www.ietf.org/rfc/rfc2132.txt). |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the DHCP Options Set. |
| `arn` | The ARN of the DHCP Options Set. |
| `owner_id` | The ID of the AWS account that owns the DHCP options set. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# vpc_dhcp_options_association Module

## Features

- **vpc_dhcp_options_association:** The ID of the DHCP Options Set Association.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_id` | (Required) The ID of the VPC to which we would like to associate a DHCP Options Set. |  |
| `dhcp_options_id` | (Required) The ID of the DHCP Options Set to associate to the VPC. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the DHCP Options Set Association. |
# vpc_endpoint Module

## Features

- **vpc_endpoint:** The ID of the VPC endpoint. * `arn` - The Amazon Resource Name (ARN) of the VPC endpoint. * `cidr_blocks` - The list of CIDR blocks for the exposed AWS service. Applicable for endpoints of type `Gateway`. * `dns_entry` - The DNS entries for the VPC Endpoint. Applicable for endpoints of type `Interface`. DNS blocks are documented below. * `network_interface_ids` - One or more network interfaces for the VPC Endpoint. Applicable for endpoints of type `Interface`. * `owner_id` - The ID of the AWS account that owns the VPC endpoint. * `prefix_list_id` - The prefix list ID of the exposed AWS service. Applicable for endpoints of type `Gateway`. * `requester_managed` -  Whether or not the VPC Endpoint is being managed by its service - `true` or `false`. * `state` - The state of the VPC endpoint. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).  DNS blocks (for `dns_entry`) support the following attributes:  * `dns_name` - The DNS name. * `hosted_zone_id` - The ID of the private hosted zone.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `service_name` | (Required) The service name. For AWS services the service name is usually in the form `com.amazonaws.<region>.<service>` (the SageMaker Notebook service is an exception to this rule, the service name is in the form `aws.sagemaker.<region>.notebook`). |  |
| `vpc_id` | (Required) The ID of the VPC in which the endpoint will be used. |  |
| `auto_accept` | (Optional) Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account). |  |
| `policy` | (Optional) A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access. All `Gateway` and some `Interface` endpoints support policies - see the [relevant AWS documentation](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints-access.html) for more details. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy). |  |
| `private_dns_enabled` | (Optional; AWS services and AWS Marketplace partner services only) Whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type `Interface`. Most users will want this enabled to allow services within the VPC to automatically use the endpoint. |  |
| `dns_options` | (Optional) The DNS options for the endpoint. See dns_options below. |  |
| `ip_address_type` | (Optional) The IP address type for the endpoint. Valid values are `ipv4`, `dualstack`, and `ipv6`. |  |
| `route_table_ids` | (Optional) One or more route table IDs. Applicable for endpoints of type `Gateway`. |  |
| `subnet_configuration` | (Optional) Subnet configuration for the endpoint, used to select specific IPv4 and/or IPv6 addresses to the endpoint. See subnet_configuration below. |  |
| `subnet_ids` | (Optional) The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type `GatewayLoadBalancer` and `Interface`. Interface type endpoints cannot function without being assigned to a subnet. |  |
| `security_group_ids` | (Optional) The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type `Interface`. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `vpc_endpoint_type` | (Optional) The VPC endpoint type, `Gateway`, `GatewayLoadBalancer`, or `Interface`. Defaults to `Gateway`. |  |
| `dns_record_ip_type` | (Optional) The DNS records created for the endpoint. Valid values are `ipv4`, `dualstack`, `service-defined`, and `ipv6`. |  |
| `private_dns_only_for_inbound_resolver_endpoint` | (Optional) Indicates whether to enable private DNS only for inbound endpoints. This option is available only for services that support both gateway and interface endpoints. It routes traffic that originates from the VPC to the gateway endpoint and traffic that originates from on-premises to the interface endpoint. Default is `false`. Can only be specified if private_dns_enabled is `true`. |  |
| `ipv4` | (Optional) The IPv4 address to assign to the endpoint network interface in the subnet. You must provide an IPv4 address if the VPC endpoint supports IPv4. |  |
| `ipv6` | (Optional) The IPv6 address to assign to the endpoint network interface in the subnet. You must provide an IPv6 address if the VPC endpoint supports IPv6. |  |
| `subnet` | (Optional) The ID of the subnet. Must have a corresponding subnet in the `subnet_ids` argument. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC endpoint. |
| `arn` | The Amazon Resource Name (ARN) of the VPC endpoint. |
| `cidr_blocks` | The list of CIDR blocks for the exposed AWS service. Applicable for endpoints of type `Gateway`. |
| `dns_entry` | The DNS entries for the VPC Endpoint. Applicable for endpoints of type `Interface`. DNS blocks are documented below. |
| `network_interface_ids` | One or more network interfaces for the VPC Endpoint. Applicable for endpoints of type `Interface`. |
| `owner_id` | The ID of the AWS account that owns the VPC endpoint. |
| `prefix_list_id` | The prefix list ID of the exposed AWS service. Applicable for endpoints of type `Gateway`. |
| `requester_managed` | Whether or not the VPC Endpoint is being managed by its service - `true` or `false`. |
| `state` | The state of the VPC endpoint. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
| `dns_name` | The DNS name. |
| `hosted_zone_id` | The ID of the private hosted zone. |
# vpc_endpoint_connection_accepter Module

## Features

- **vpc_endpoint_connection_accepter:** The ID of the VPC Endpoint Connection. * `vpc_endpoint_state` - State of the VPC Endpoint.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_endpoint_id` | (Required) AWS VPC Endpoint ID. |  |
| `vpc_endpoint_service_id` | (Required) AWS VPC Endpoint Service ID. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC Endpoint Connection. |
| `vpc_endpoint_state` | State of the VPC Endpoint. |
# vpc_endpoint_connection_notification Module

## Features

- **vpc_endpoint_connection_notification:** The ID of the VPC connection notification. * `state` - The state of the notification. * `notification_type` - The type of notification.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_endpoint_service_id` | (Optional) The ID of the VPC Endpoint Service to receive notifications for. |  |
| `vpc_endpoint_id` | (Optional) The ID of the VPC Endpoint to receive notifications for. |  |
| `connection_notification_arn` | (Required) The ARN of the SNS topic for the notifications. |  |
| `connection_events` | (Required) One or more endpoint [events](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpcEndpointConnectionNotification.html#API_CreateVpcEndpointConnectionNotification_RequestParameters) for which to receive notifications. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC connection notification. |
| `state` | The state of the notification. |
| `notification_type` | The type of notification. |
# vpc_endpoint_policy Module

## Features

- **vpc_endpoint_policy:** The ID of the VPC endpoint.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_endpoint_id` | (Required) The VPC Endpoint ID. |  |
| `policy` | (Optional) A policy to attach to the endpoint that controls access to the service. Defaults to full access. All `Gateway` and some `Interface` endpoints support policies - see the [relevant AWS documentation](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints-access.html) for more details. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy). |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC endpoint. |
# vpc_endpoint_private_dns Module

## Features

- **vpc_endpoint_private_dns:** (Required) Indicates whether a private hosted zone is associated with the VPC. Only applicable for `Interface` endpoints. * `vpc_endpoint_id` - (Required) VPC endpoint identifier.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `private_dns_enabled` | (Required) Indicates whether a private hosted zone is associated with the VPC. Only applicable for `Interface` endpoints. |  |
| `vpc_endpoint_id` | (Required) VPC endpoint identifier. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
# vpc_endpoint_route_table_association Module

## Features

- **vpc_endpoint_route_table_association:** A hash of the EC2 Route Table and VPC Endpoint identifiers.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `route_table_id` | (Required) Identifier of the EC2 Route Table to be associated with the VPC Endpoint. |  |
| `vpc_endpoint_id` | (Required) Identifier of the VPC Endpoint with which the EC2 Route Table will be associated. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | A hash of the EC2 Route Table and VPC Endpoint identifiers. |
# vpc_endpoint_security_group_association Module

## Features

- **vpc_endpoint_security_group_association:** The ID of the association.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `security_group_id` | (Required) The ID of the security group to be associated with the VPC endpoint. |  |
| `vpc_endpoint_id` | (Required) The ID of the VPC endpoint with which the security group will be associated. |  |
| `replace_default_association` | (Optional) Whether this association should replace the association with the VPC's default security group that is created when no security groups are specified during VPC endpoint creation. At most 1 association per-VPC endpoint should be configured with `replace_default_association = true`. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the association. |
# vpc_endpoint_service Module

## Features

- **vpc_endpoint_service:** The ID of the VPC endpoint service. * `availability_zones` - A set of Availability Zones in which the service is available. * `arn` - The Amazon Resource Name (ARN) of the VPC endpoint service. * `base_endpoint_dns_names` - A set of DNS names for the service. * `manages_vpc_endpoints` - Whether or not the service manages its VPC endpoints - `true` or `false`. * `service_name` - The service name. * `service_type` - The service type, `Gateway` or `Interface`. * `state` - The state of the VPC endpoint service. * `private_dns_name_configuration` - List of objects containing information about the endpoint service private DNS name configuration.     * `name` - Name of the record subdomain the service provider needs to create.     * `state` - Verification state of the VPC endpoint service. Consumers of the endpoint service can use the private name only when the state is `verified`.     * `type` - Endpoint service verification type, for example `TXT`.     * `value` - Value the service provider adds to the private DNS name domain record before verification. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `acceptance_required` | (Required) Whether or not VPC endpoint connection requests to the service must be accepted by the service owner - `true` or `false`. |  |
| `allowed_principals` | (Optional) The ARNs of one or more principals allowed to discover the endpoint service. |  |
| `gateway_load_balancer_arns` | (Optional) Amazon Resource Names (ARNs) of one or more Gateway Load Balancers for the endpoint service. |  |
| `network_load_balancer_arns` | (Optional) Amazon Resource Names (ARNs) of one or more Network Load Balancers for the endpoint service. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `private_dns_name` | (Optional) The private DNS name for the service. |  |
| `supported_ip_address_types` | (Optional) The supported IP address types. The possible values are `ipv4` and `ipv6`. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC endpoint service. |
| `availability_zones` | A set of Availability Zones in which the service is available. |
| `arn` | The Amazon Resource Name (ARN) of the VPC endpoint service. |
| `base_endpoint_dns_names` | A set of DNS names for the service. |
| `manages_vpc_endpoints` | Whether or not the service manages its VPC endpoints - `true` or `false`. |
| `service_name` | The service name. |
| `service_type` | The service type, `Gateway` or `Interface`. |
| `state` | The state of the VPC endpoint service. |
| `private_dns_name_configuration` | List of objects containing information about the endpoint service private DNS name configuration. |
| `name` | Name of the record subdomain the service provider needs to create. |
| `state` | Verification state of the VPC endpoint service. Consumers of the endpoint service can use the private name only when the state is `verified`. |
| `type` | Endpoint service verification type, for example `TXT`. |
| `value` | Value the service provider adds to the private DNS name domain record before verification. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# vpc_endpoint_service_allowed_principal Module

## Features

- **vpc_endpoint_service_allowed_principal:** The ID of the association.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_endpoint_service_id` | (Required) The ID of the VPC endpoint service to allow permission. |  |
| `principal_arn` | (Required) The ARN of the principal to allow permissions. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the association. |
# vpc_endpoint_service_private_dns_verification Module

## Features

- **vpc_endpoint_service_private_dns_verification:** (Required) ID of the endpoint service.  The following arguments are optional:  * `wait_for_verification` - (Optional) Whether to wait until the endpoint service returns a `Verified` status for the configured private DNS name.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `service_id` | (Required) ID of the endpoint service. |  |
| `wait_for_verification` | (Optional) Whether to wait until the endpoint service returns a `Verified` status for the configured private DNS name. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
# vpc_endpoint_subnet_association Module

## Features

- **vpc_endpoint_subnet_association:** The ID of the association.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_endpoint_id` | (Required) The ID of the VPC endpoint with which the subnet will be associated. |  |
| `subnet_id` | (Required) The ID of the subnet to be associated with the VPC endpoint. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the association. |
# vpc_ipv4_cidr_block_association Module

## Features

- **vpc_ipv4_cidr_block_association:** The ID of the VPC CIDR association

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `cidr_block` | (Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length`. |  |
| `ipv4_ipam_pool_id` | (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. IPAM is a VPC feature that you can use to automate your IP address management workflows including assigning, tracking, troubleshooting, and auditing IP addresses across AWS Regions and accounts. Using IPAM you can monitor IP address usage throughout your AWS Organization. |  |
| `ipv4_netmask_length` | (Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a `ipv4_ipam_pool_id`. |  |
| `vpc_id` | (Required) The ID of the VPC to make the association with. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC CIDR association |
# vpc_ipv6_cidr_block_association Module

## Features

- **vpc_ipv6_cidr_block_association:** The ID of the VPC CIDR association. * `ip_source` - The source that allocated the IP address space. Values: `amazon`, `byoip`, `none`. * `ipv6_address_attribute` - Public IPv6 addresses are those advertised on the internet from AWS. Private IP addresses are not and cannot be advertised on the internet from AWS. Values: `public`, `private`.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `assign_generated_ipv6_cidr_block` | (Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IPv6 addresses, or the size of the CIDR block. Default is `false`. Conflicts with `ipv6_pam_pool_id`, `ipv6_pool`, `ipv6_cidr_block` and `ipv6_netmask_length`. |  |
| `ipv6_cidr_block` | (Optional) The IPv6 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv6_netmask_length`. This parameter is required if `ipv6_netmask_length` is not set and the IPAM pool does not have `allocation_default_netmask` set. Conflicts with `assign_generated_ipv6_cidr_block`. |  |
| `ipv6_ipam_pool_id` | - (Optional) The ID of an IPv6 IPAM pool you want to use for allocating this VPC's CIDR. IPAM is a VPC feature that you can use to automate your IP address management workflows including assigning, tracking, troubleshooting, and auditing IP addresses across AWS Regions and accounts. Conflict with `assign_generated_ipv6_cidr_block` and `ipv6_ipam_pool_id`. |  |
| `ipv6_netmask_length` | (Optional) The netmask length of the IPv6 CIDR you want to allocate to this VPC. Requires specifying a `ipv6_ipam_pool_id`. This parameter is optional if the IPAM pool has `allocation_default_netmask` set, otherwise it or `ipv6_cidr_block` are required. Conflicts with `assign_generated_ipv6_cidr_block` and `ipv6_ipam_pool_id`. |  |
| `ipv6_pool` | (Optional) The  ID of an IPv6 address pool from which to allocate the IPv6 CIDR block. Conflicts with `ipv6_pam_pool_id`, `ipv6_pool`. |  |
| `vpc_id` | (Required) The ID of the VPC to make the association with. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC CIDR association. |
| `ip_source` | The source that allocated the IP address space. Values: `amazon`, `byoip`, `none`. |
| `ipv6_address_attribute` | Public IPv6 addresses are those advertised on the internet from AWS. Private IP addresses are not and cannot be advertised on the internet from AWS. Values: `public`, `private`. |
# vpc_network_performance_metric_subscription Module

## Features

- **vpc_network_performance_metric_subscription:** The data aggregation time for the subscription.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `destination` | (Required) The target Region or Availability Zone that the metric subscription is enabled for. For example, `eu-west-1`. |  |
| `metric` | (Optional) The metric used for the enabled subscription. Valid values: `aggregate-latency`. Default: `aggregate-latency`. |  |
| `source` | (Required) The source Region or Availability Zone that the metric subscription is enabled for. For example, `us-east-1`. |  |
| `statistic` | (Optional) The statistic used for the enabled subscription. Valid values: `p50`. Default: `p50`. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `period` | The data aggregation time for the subscription. |
# vpc_peering_connection Module

## Features

- **vpc_peering_connection:** The ID of the VPC Peering Connection. * `accept_status` - The status of the VPC Peering Connection request. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `peer_owner_id` | (Optional) The AWS account ID of the target peer VPC. |  |
| `peer_vpc_id` | (Required) The ID of the target VPC with which you are creating the VPC Peering Connection. |  |
| `vpc_id` | (Required) The ID of the requester VPC. |  |
| `auto_accept` | (Optional) Accept the peering (both VPCs need to be in the same AWS account and region). |  |
| `peer_region` | (Optional) The region of the accepter VPC of the VPC Peering Connection. `auto_accept` must be `false`, |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `allow_remote_vpc_dns_resolution` | (Optional) Allow a local VPC to resolve public DNS hostnames to |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC Peering Connection. |
| `accept_status` | The status of the VPC Peering Connection request. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# vpc_peering_connection_accepter Module

## Features

- **vpc_peering_connection_accepter:** The ID of the VPC Peering Connection. * `accept_status` - The status of the VPC Peering Connection request. * `vpc_id` - The ID of the accepter VPC. * `peer_vpc_id` - The ID of the requester VPC. * `peer_owner_id` - The AWS account ID of the owner of the requester VPC. * `peer_region` - The region of the accepter VPC. * `accepter` - A configuration block that describes [VPC Peering Connection] (https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) options set for the accepter VPC. * `requester` - A configuration block that describes [VPC Peering Connection] (https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) options set for the requester VPC. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_peering_connection_id` | (Required) The VPC Peering Connection ID to manage. |  |
| `auto_accept` | (Optional) Whether or not to accept the peering request. Defaults to `false`. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC Peering Connection. |
| `accept_status` | The status of the VPC Peering Connection request. |
| `vpc_id` | The ID of the accepter VPC. |
| `peer_vpc_id` | The ID of the requester VPC. |
| `peer_owner_id` | The AWS account ID of the owner of the requester VPC. |
| `peer_region` | The region of the accepter VPC. |
| `accepter` | A configuration block that describes [VPC Peering Connection] |
| `requester` | A configuration block that describes [VPC Peering Connection] |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# vpc_peering_connection_options Module

## Features

- **vpc_peering_connection_options:** The ID of the VPC Peering Connection Options.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `vpc_peering_connection_id` | (Required) The ID of the requester VPC peering connection. |  |
| `allow_remote_vpc_dns_resolution` | (Optional) Allow a local VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the peer VPC. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `id` | The ID of the VPC Peering Connection Options. |
# vpc_security_group_egress_rule Module

## Features

- **vpc_security_group_egress_rule:** The Amazon Resource Name (ARN) of the security group rule. * `security_group_rule_id` - The ID of the security group rule. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `cidr_ipv4` | (Optional) The destination IPv4 CIDR range. |  |
| `cidr_ipv6` | (Optional) The destination IPv6 CIDR range. |  |
| `description` | (Optional) The security group rule description. |  |
| `from_port` | (Optional) The start of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 type. |  |
| `ip_protocol` | (Optional) The IP protocol name or number. Use `-1` to specify all protocols. Note that if `ip_protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined. |  |
| `prefix_list_id` | (Optional) The ID of the destination prefix list. |  |
| `referenced_security_group_id` | (Optional) The destination security group that is referenced in the rule. |  |
| `security_group_id` | (Required) The ID of the security group. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `to_port` | (Optional) The end of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 code. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | The Amazon Resource Name (ARN) of the security group rule. |
| `security_group_rule_id` | The ID of the security group rule. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# vpc_security_group_ingress_rule Module

## Features

- **vpc_security_group_ingress_rule:** The Amazon Resource Name (ARN) of the security group rule. * `security_group_rule_id` - The ID of the security group rule. * `tags_all` - A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block).

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `cidr_ipv4` | (Optional) The source IPv4 CIDR range. |  |
| `cidr_ipv6` | (Optional) The source IPv6 CIDR range. |  |
| `description` | (Optional) The security group rule description. |  |
| `from_port` | (Optional) The start of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 type. |  |
| `ip_protocol` | (Required) The IP protocol name or number. Use `-1` to specify all protocols. Note that if `ip_protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined. |  |
| `prefix_list_id` | (Optional) The ID of the source prefix list. |  |
| `referenced_security_group_id` | (Optional) The source security group that is referenced in the rule. |  |
| `security_group_id` | (Required) The ID of the security group. |  |
| `tags` | (Optional) A map of tags to assign to the resource. If configured with a provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block) present, tags with matching keys will overwrite those defined at the provider-level. |  |
| `to_port` | (Optional) The end of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 code. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `arn` | The Amazon Resource Name (ARN) of the security group rule. |
| `security_group_rule_id` | The ID of the security group rule. |
| `tags_all` | A map of tags assigned to the resource, including those inherited from the provider [`default_tags` configuration block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block). |
# vpc_security_group_vpc_association Module

## Features

- **vpc_security_group_vpc_association:** State of the VPC association. See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SecurityGroupVpcAssociation.html) for possible values.

## Variables
The module accepts a wide range of variables to customize the RDS resources. Refer to the `variables.tf` file in the module directory for a complete list of variables and their descriptions.
----------------------

| Variable | Description | Default |
|---|---|---|
| `security_group_id` | (Required) The ID of the security group. |  |
| `vpc_id` | (Required) The ID of the VPC to make the association with. |  |

## Output
The module outputs various attributes of the created resources, such as:
----------------------

| Output | Description |
|---|---| 
| `state` | State of the VPC association. See the [AWS documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SecurityGroupVpcAssociation.html) for possible values. |
