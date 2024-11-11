# Data lookup for existing SSM role by name (if already created in AWS account)
data "aws_iam_role" "ssm_ec2_role" {
  count = length(try([data.aws_iam_role.ssm_ec2_role.name], [])) > 0 ? 1 : 0
  name  = "${var.name}-ssm-role"
}

# SSM IAM role for EC2 instance - only created if it does not exist
resource "aws_iam_role" "ssm_ec2_role" {
  count = length(data.aws_iam_role.ssm_ec2_role) == 0 ? 1 : 0
  name  = "${var.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach SSM policy to the role if created
resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  count      = length(data.aws_iam_role.ssm_ec2_role) == 0 ? 1 : 0
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile for SSM role
resource "aws_iam_instance_profile" "ssm_role_profile" {
  name = "${var.name}-ssm-profile"
  role = coalesce(
    aws_iam_role.ssm_ec2_role[count.index].name,
    data.aws_iam_role.ssm_ec2_role.name
  )
}

# EC2 Instance Module with the core security group attached
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = var.name
  instance_type = var.instance_type
  ami           = var.ami
  subnet_id     = var.subnet_id
  monitoring    = var.enable_monitoring # if prod enable by default

  tags = merge(var.tags, {
    "Name"   = var.name,
    "Region" = var.region
  })

  root_block_device = [
    {
      volume_type = "gp3"
      encrypted   = true
      throughput  = 200
      volume_size = 20
      volume_tags = {
        Name = "root"
      }
    },
  ]

  ebs_block_device = [
    for vol in var.additional_ebs_volumes : {
      device_name = vol.device_name
      volume_type = vol.volume_type
      volume_size = vol.volume_size
      encrypted   = true
    }
  ]

  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    os_type       = var.os_type,
    custom_script = var.custom_user_data
  })

  iam_instance_profile = aws_iam_instance_profile.ssm_role_profile.name

  # Forwarding all configurable parameters to the module

  create                               = var.create
  ami_ssm_parameter                    = var.ami_ssm_parameter
  ignore_ami_changes                   = var.ignore_ami_changes
  associate_public_ip_address          = var.associate_public_ip_address
  maintenance_options                  = var.maintenance_options
  availability_zone                    = var.availability_zone
  capacity_reservation_specification   = var.capacity_reservation_specification
  cpu_credits                          = var.cpu_credits
  disable_api_termination              = var.disable_api_termination
  ebs_optimized                        = var.ebs_optimized
  enclave_options_enabled              = var.enclave_options_enabled
  ephemeral_block_device               = var.ephemeral_block_device
  get_password_data                    = var.get_password_data
  hibernation                          = var.hibernation
  host_id                              = var.host_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_tags                        = var.instance_tags
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  key_name                             = var.key_name
  launch_template                      = var.launch_template
  metadata_options                     = var.metadata_options
  network_interface                    = var.network_interface
  private_dns_name_options             = var.private_dns_name_options
  placement_group                      = var.placement_group
  private_ip                           = var.private_ip
  secondary_private_ips                = var.secondary_private_ips
  source_dest_check                    = var.source_dest_check
  tenancy                              = var.tenancy
  volume_tags                          = var.volume_tags
  enable_volume_tags                   = var.enable_volume_tags
  vpc_security_group_ids               = [aws_security_group.core_sg.id, var.vpc_security_group_ids]
  timeouts                             = var.timeouts
  cpu_options                          = var.cpu_options
  cpu_core_count                       = var.cpu_core_count
  cpu_threads_per_core                 = var.cpu_threads_per_core
  create_spot_instance                 = var.create_spot_instance
  spot_price                           = var.spot_price
  spot_wait_for_fulfillment            = var.spot_wait_for_fulfillment
  spot_type                            = var.spot_type
  spot_launch_group                    = var.spot_launch_group
  spot_block_duration_minutes          = var.spot_block_duration_minutes
  spot_instance_interruption_behavior  = var.spot_instance_interruption_behavior
  spot_valid_until                     = var.spot_valid_until
  spot_valid_from                      = var.spot_valid_from
  disable_api_stop                     = var.disable_api_stop
  create_iam_instance_profile          = var.create_iam_instance_profile
  iam_role_name                        = var.iam_role_name
  iam_role_use_name_prefix             = var.iam_role_use_name_prefix
  iam_role_path                        = var.iam_role_path
  iam_role_description                 = var.iam_role_description
  iam_role_permissions_boundary        = var.iam_role_permissions_boundary
  iam_role_policies                    = var.iam_role_policies
  iam_role_tags                        = var.iam_role_tags
  create_eip                           = var.create_eip
  eip_domain                           = var.eip_domain
  eip_tags                             = var.eip_tags

}








