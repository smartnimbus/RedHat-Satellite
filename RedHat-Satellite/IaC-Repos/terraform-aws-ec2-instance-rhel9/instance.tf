#------------------------------------------------------------------------------------------------------
# Resource         : aws_instance
# description      : Provides an EC2 instance resource. This allows instances to be created, updated, and deleted. Instances also support provisioning.
# module           : EC2 (Elastic Compute Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

#---------------------------------------------------
# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonSSMManagedInstanceCore.html
# https://aws.amazon.com/blogs/mt/applying-managed-instance-policy-best-practices/
# https://docs.aws.amazon.com/service-authorization/latest/reference/list_awssystemsmanager.html#awssystemsmanager-actions-as-permissions
# https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-create-iam-instance-profile.html
#---------------------------------------------------
resource "aws_instance" "instance" {
  # Conditionally create the resource based on the 'enable_instance' variable
  count = var.enable_instance ? 1 : 0

  # Instance details, such as AMI and instance type
  ami           = var.instance_ami != "" ? var.instance_ami : lookup(var.ami, var.region)
  instance_type = var.instance_type

  # Placement configuration
  availability_zone          = var.instance_availability_zone
  placement_group            = var.instance_placement_group
  placement_partition_number = var.instance_placement_partition_number
  tenancy                    = var.instance_tenancy

  # EBS optimization and source-destination checks
  ebs_optimized     = var.instance_ebs_optimized
  source_dest_check = var.instance_source_dest_check
  monitoring        = var.instance_monitoring

  # Network configuration for VPC and private/public IPs
  subnet_id                   = var.instance_subnet_id
  associate_public_ip_address = var.instance_associate_public_ip_address
  private_ip                  = var.instance_private_ip

  ipv6_address_count = var.instance_ipv6_address_count
  ipv6_addresses     = var.instance_ipv6_addresses

  # Security groups and key pair for SSH access
  vpc_security_group_ids = var.instance_vpc_security_group_ids
  security_groups        = var.instance_security_groups
  key_name               = var.instance_key_name

  # User data configuratio
  # Define combined user data, merging the default script with user-provided script
  user_data = templatefile("${path.module}/combined_userdata.tpl", {
    default_userdata = data.template_file.default_userdata.rendered
    custom_userdata  = var.instance_user_data
  })
  # user_data                   = var.instance_user_data
  user_data_base64            = var.instance_user_data_base64
  user_data_replace_on_change = var.instance_user_data_replace_on_change
  get_password_data           = var.instance_get_password_data

  # Instance termination behavior
  disable_api_termination              = var.instance_disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  # IAM instance profile: if `instance_iam_instance_profile` is not empty, use that; otherwise, use the SSM profile
  # iam_instance_profile   = var.instance_iam_instance_profile
  # iam_instance_profile = var.instance_iam_instance_profile != "" ? "${var.instance_iam_instance_profile}" : aws_iam_instance_profile.ssm_role_profile.instance_name
  iam_instance_profile = (
    var.instance_iam_instance_profile != "" ? "${var.instance_iam_instance_profile}" : ""
    ) + (
    aws_iam_instance_profile.ssm_role_profile.instance_name != "" ? ",${aws_iam_instance_profile.ssm_role_profile.instance_name}" : ""
  )

  host_id = var.instance_host_id
  dynamic "cpu_options" {
    # If 'instance_cpu_options' is defined, create a 'cpu_options' block
    for_each = length(var.instance_cpu_options) > 0 ? [var.instance_cpu_options] : []

    content {
      core_count       = try(cpu_options.value.core_count, null)
      threads_per_core = try(cpu_options.value.threads_per_core, null)
      amd_sev_snp      = try(cpu_options.value.amd_sev_snp, null)
    }
  }

  hibernation           = var.instance_hibernation
  secondary_private_ips = var.instance_secondary_private_ips

  # Launch template configuration
  dynamic "launch_template" {
    iterator = launch_template
    # If 'instance_launch_template' is defined, create a 'launch_template' block
    for_each = length(keys(var.instance_launch_template)) > 0 ? [var.instance_launch_template] : []

    content {
      name    = lookup(launch_template.value, "name", null)
      id      = lookup(launch_template.value, "id", null)
      version = lookup(launch_template.value, "version", null)
    }
  }

  # Capacity reservation configuration
  dynamic "capacity_reservation_specification" {
    iterator = capacity_reservation_specification
    # Iterate over the 'instance_capacity_reservation_specification' variable
    for_each = var.instance_capacity_reservation_specification

    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)

      # Nested dynamic block for capacity reservation target
      dynamic "capacity_reservation_target" {
        iterator = capacity_reservation_target
        # If 'capacity_reservation_target' is defined within the current capacity reservation specification, create a 'capacity_reservation_target' block
        for_each = length(keys(lookup(capacity_reservation_specification.value, "capacity_reservation_target", {}))) > 0 ? [lookup(capacity_reservation_specification.value, "capacity_reservation_target", {})] : []

        content {
          capacity_reservation_id = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
        }
      }
    }
  }

  # Credit specification configuration
  dynamic "credit_specification" {
    iterator = credit_specification
    # Iterate over the 'instance_credit_specification' variable
    for_each = var.instance_credit_specification

    content {
      cpu_credits = lookup(credit_specification.value, "cpu_credits", null)
    }
  }

  # Enclave options configuration
  dynamic "enclave_options" {
    iterator = enclave_options
    # If 'instance_enclave_options' is defined, create an 'enclave_options' block
    for_each = length(keys(var.instance_enclave_options)) > 0 ? [var.instance_enclave_options] : []

    content {
      enabled = lookup(enclave_options.value, "enabled", null)
    }
  }

  # Metadata options configuration
  dynamic "metadata_options" {
    iterator = metadata_options
    # If 'instance_metadata_options' is defined, create a 'metadata_options' block
    for_each = length(keys(var.instance_metadata_options)) > 0 ? [var.instance_metadata_options] : []

    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", null)
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", null)
      http_tokens                 = lookup(metadata_options.value, "http_tokens", null)
    }
  }

  # EBS block device configuration
  dynamic "ebs_block_device" {
    iterator = ebs_block_device
    # Iterate over the 'instance_ebs_block_device' variable
    for_each = var.instance_ebs_block_device

    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = lookup(ebs_block_device.value, "device_name", null)
      encrypted             = true # Enforce encryption
      # encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops        = lookup(ebs_block_device.value, "iops", null)
      snapshot_id = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size = lookup(ebs_block_device.value, "volume_size", null)
      volume_type = lookup(ebs_block_device.value, "volume_type", null)
      kms_key_id  = lookup(ebs_block_device.value, "kms_key_id", null)

      throughput = lookup(ebs_block_device.value, "throughput", null)
      tags       = lookup(ebs_block_device.value, "tags", null)
    }
  }

  # Ephemeral block device configuration
  dynamic "ephemeral_block_device" {
    iterator = ephemeral_block_device
    # Iterate over the 'instance_ephemeral_block_device' variable
    for_each = var.instance_ephemeral_block_device

    content {
      device_name  = lookup(root_block_device.value, "device_name", null)
      virtual_name = lookup(root_block_device.value, "virtual_name", null)
      no_device    = lookup(root_block_device.value, "no_device", null)
    }
  }

  # Block device mappings for root and additional volumes
  dynamic "root_block_device" {
    iterator = root_block_device
    # Iterate over the 'instance_root_block_device' variable
    for_each = var.instance_root_block_device

    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      # encrypted             = lookup(root_block_device.value, "encrypted", null)
      encrypted = true # Enforce encryption

      kms_key_id = lookup(root_block_device.value, "kms_key_id", null)
      throughput = lookup(root_block_device.value, "throughput", null)

      tags = lookup(root_block_device.value, "tags", null)
    }
  }

  # Network interface configuration
  dynamic "network_interface" {
    iterator = network_interface
    # Iterate over the 'instance_network_interface' variable
    for_each = var.instance_network_interface

    content {
      device_index         = lookup(network_interface.value, "device_index", null)
      network_interface_id = lookup(network_interface.value, "network_interface_id", null)

      delete_on_termination = lookup(network_interface.value, "delete_on_termination", null)
    }
  }

  # Tags for the instance and volumes
  volume_tags = merge(
    {
      "Name" = var.instance_name
    },
    var.instance_volume_tags
  )

  # Dynamic block for timeouts configuration
  dynamic "timeouts" {
    iterator = timeouts
    for_each = length(keys(var.instance_timeouts)) > 0 ? [var.instance_timeouts] : []

    content {
      create = lookup(timeouts.value, "create", null)
      update = lookup(timeouts.value, "update", null)
      delete = lookup(timeouts.value, "delete", null)
    }
  }

  # Tags for the instanc
  tags = merge(
    {
      Name          = var.instance_name
      Environment   = var.environment
      Orchestration = "Terraform"
    },
    var.tags
  )

  # Lifecycle rules for the instance resource
  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  # Dependencies and relationships with other resources
  depends_on = []
}