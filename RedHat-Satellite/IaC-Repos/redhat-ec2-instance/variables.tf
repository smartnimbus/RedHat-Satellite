variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to deploy the instance"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs to attach to the instance"
  type        = list(string)
}

variable "kms_key_id" {
  description = "KMS key to encrypt volumes"
  type        = string
}

variable "user_data_file" {
  description = "Path to user data script"
  type        = string
}

variable "instance_name" {
  description = "Instance name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
