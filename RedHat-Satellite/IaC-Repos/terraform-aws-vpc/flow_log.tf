#------------------------------------------------------------------------------------------------------
# Resource         : aws_flow_log
# description      : Provides a VPC/Subnet/ENI Flow Log
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
# Provider Version : 5.76.0 (v5.76.0), Published at: 2024-11-14T17:36:21Z
#------------------------------------------------------------------------------------------------------

data "aws_region" "current" {
  # Conditionally fetch region data: Only if both `create_vpc` AND `enable_flow_log` are true.  Uses logical AND (`&&`) and the ternary operator.
  count = var.create_vpc && var.enable_flow_log ? 1 : 0
}
# Data source to get the current caller's identity.  Used for constructing ARNs.
data "aws_caller_identity" "current" {
  # Conditional execution: Only if VPC creation and flow logs are enabled.
  count = var.create_vpc && var.enable_flow_log ? 1 : 0
}

# Data source to retrieve information about the current AWS partition (e.g., "aws", "aws-cn", "aws-gov").  Used for constructing ARNs.
data "aws_partition" "current" {
  # Call this API only if create_vpc and enable_flow_log are true
  count = var.create_vpc && var.enable_flow_log ? 1 : 0
}

# Local values to simplify logic and manage resource creation.
locals {
  # Whether to enable flow logs.  Determined by `create_vpc` and `enable_flow_log` variables.
  enable_flow_log = var.create_vpc && var.enable_flow_log

  # Whether to create an IAM role for CloudWatch flow logs.  Several conditions are checked using logical AND (`&&`).
  create_flow_log_cloudwatch_iam_role = local.enable_flow_log && var.flow_log_destination_type != "s3" && var.create_flow_log_cloudwatch_iam_role
  # Whether to create a CloudWatch log group for flow logs.
  create_flow_log_cloudwatch_log_group = local.enable_flow_log && var.flow_log_destination_type != "s3" && var.create_flow_log_cloudwatch_log_group

  # The ARN where flow logs will be sent. Uses the `try` function to handle potential errors if the log group resource hasn't been created yet, defaulting to null. The ternary operator (`condition ? true_val : false_val`) is used here.
  flow_log_destination_arn = local.create_flow_log_cloudwatch_log_group ? try(aws_cloudwatch_log_group.flow_log[0].arn, null) : var.flow_log_destination_arn
  # The ARN of the IAM role for VPC flow logs.
  flow_log_iam_role_arn = var.flow_log_destination_type != "s3" && local.create_flow_log_cloudwatch_iam_role ? try(aws_iam_role.vpc_flow_log_cloudwatch[0].arn, null) : var.flow_log_cloudwatch_iam_role_arn
  # The suffix for the CloudWatch log group name.  Defaults to the VPC ID if not provided.  The ternary operator is used.
  flow_log_cloudwatch_log_group_name_suffix = var.flow_log_cloudwatch_log_group_name_suffix == "" ? local.vpc_id : var.flow_log_cloudwatch_log_group_name_suffix
  # A list of ARNs for the CloudWatch log groups. Uses a `for` expression to iterate over the log groups and construct their ARNs. String templating is used with the `${}` syntax.
  flow_log_group_arns = [
    for log_group in aws_cloudwatch_log_group.flow_log :
    "arn:${data.aws_partition.current[0].partition}:logs:${data.aws_region.current[0].name}:${data.aws_caller_identity.current[0].account_id}:log-group:${log_group.name}:*"
  ]
}

#------------------------------------------------------------------------------------------------------
# Resource         : aws_flow_log
# description      : Provides a VPC/Subnet/ENI Flow Log
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log # Removed "https://" for consistency.  URLs are not typically included in these headers.
# Provider Version : 5.76.0 (v5.76.0) # Removed publish date (generally not necessary)
#------------------------------------------------------------------------------------------------------
resource "aws_flow_log" "this" {
  # Creates the flow log resource only if `enable_flow_log` is true.
  count = local.enable_flow_log ? 1 : 0

  log_destination_type       = var.flow_log_destination_type
  log_destination            = local.flow_log_destination_arn
  log_format                 = var.flow_log_log_format
  iam_role_arn               = local.flow_log_iam_role_arn
  deliver_cross_account_role = var.flow_log_deliver_cross_account_role
  traffic_type               = var.flow_log_traffic_type
  vpc_id                     = local.vpc_id
  max_aggregation_interval   = var.flow_log_max_aggregation_interval

  # Dynamically configure destination options (only for S3 destinations).
  dynamic "destination_options" {
    for_each = var.flow_log_destination_type == "s3" ? [true] : []

    content {
      file_format                = var.flow_log_file_format
      hive_compatible_partitions = var.flow_log_hive_compatible_partitions
      per_hour_partition         = var.flow_log_per_hour_partition
    }
  }

  # Tags for the flow log resource. The `merge` function is used.
  tags = merge(
    var.default_tags, # Include default tags
    var.tags,
    var.vpc_flow_log_tags
  )
}


#------------------------------------------------------------------------------------------------------
# Resource         : aws_cloudwatch_log_group
# description      : Provides a CloudWatch Log Group for VPC Flow Logs
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
# Provider Version : 5.76.0 (v5.76.0)
#------------------------------------------------------------------------------------------------------
# Creates a CloudWatch Log Group for VPC Flow Logs.
resource "aws_cloudwatch_log_group" "flow_log" {
  # Conditional creation: Only create if CloudWatch is chosen as the destination and the user has opted to create the log group.  Uses the ternary operator (`condition ? true_val : false_val`).
  count = local.create_flow_log_cloudwatch_log_group ? 1 : 0
  # The name of the log group.  String concatenation combines the prefix and suffix variables/local values.
  name              = "${var.flow_log_cloudwatch_log_group_name_prefix}${local.flow_log_cloudwatch_log_group_name_suffix}"
  retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_id
  skip_destroy      = var.flow_log_cloudwatch_log_group_skip_destroy
  log_group_class   = var.flow_log_cloudwatch_log_group_class

  # Tags for the log group. Uses the `merge` function to combine maps.
  tags = merge(
    var.default_tags, # Include default tags
    var.tags,
    var.vpc_flow_log_tags
  )
}

#------------------------------------------------------------------------------------------------------
# Resource         : aws_iam_role
# description      : Provides an IAM Role for VPC Flow Logs
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# Provider Version : 5.76.0 (v5.76.0)
#------------------------------------------------------------------------------------------------------
# Create an IAM Role for VPC Flow Logs to CloudWatch
resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  # Conditional creation:  Only create the role if CloudWatch logging is enabled and the user opted to manage the role creation.
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  # Sets the name of the role, or uses a prefix based on 'var.vpc_flow_log_iam_role_use_name_prefix'.  The ternary operator (`condition ? true_val : false_val`) is used. 
  name        = var.vpc_flow_log_iam_role_use_name_prefix ? null : var.vpc_flow_log_iam_role_name
  name_prefix = var.vpc_flow_log_iam_role_use_name_prefix ? "${var.vpc_flow_log_iam_role_name}-" : null

  assume_role_policy   = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role[0].json
  permissions_boundary = var.vpc_flow_log_permissions_boundary

  # Tags for the IAM role. Uses the `merge` function.
  tags = merge(
    var.default_tags, # Include default tags
    var.tags,
    var.vpc_flow_log_tags
  )
}

#------------------------------------------------------------------------------------------------------
# Data Source      : aws_iam_policy_document # Changed to "Data Source"
# description      : Generates an IAM Policy Document for Assume Role
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# Provider Version : 5.76.0 (v5.76.0)
#------------------------------------------------------------------------------------------------------
# Data source for generating the assume role policy document.
data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  # Conditional execution: Only if the role is being created.
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsAssumeRole"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]
  }
}

#------------------------------------------------------------------------------------------------------
# Resource         : aws_iam_role_policy_attachment
# description      : Attaches a Policy to an IAM Role
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
# Provider Version : 5.76.0 (v5.76.0)
#------------------------------------------------------------------------------------------------------
# Attaches a policy to the IAM role.
resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  # Conditional execution: Only if role creation is managed by this module.
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  role       = aws_iam_role.vpc_flow_log_cloudwatch[0].name
  policy_arn = aws_iam_policy.vpc_flow_log_cloudwatch[0].arn
}

#------------------------------------------------------------------------------------------------------
# Resource         : aws_iam_policy
# description      : Defines an IAM Policy
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
# Provider Version : 5.76.0 (v5.76.0)
#------------------------------------------------------------------------------------------------------
# Create the IAM Policy for VPC Flow Logs.
resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  # Only create the policy if role creation is managed here.
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  # Policy name configuration based on 'var.vpc_flow_log_iam_policy_use_name_prefix'.  The ternary operator is used.
  name        = var.vpc_flow_log_iam_policy_use_name_prefix ? null : var.vpc_flow_log_iam_policy_name
  name_prefix = var.vpc_flow_log_iam_policy_use_name_prefix ? "${var.vpc_flow_log_iam_policy_name}-" : null
  policy      = data.aws_iam_policy_document.vpc_flow_log_cloudwatch[0].json
  tags        = merge(var.tags, var.vpc_flow_log_tags)
}

#------------------------------------------------------------------------------------------------------
# Data Source      : aws_iam_policy_document  # Changed to "Data Source"
# description      : Generates an IAM Policy Document
# module           : VPC (Virtual Private Cloud)
# provider         : terraform-provider-aws
# reference        : registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# Provider Version : 5.76.0 (v5.76.0)
#------------------------------------------------------------------------------------------------------
# Data source for generating the IAM policy document.
data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  # Conditional execution based on role creation.
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = local.flow_log_group_arns
  }
}
