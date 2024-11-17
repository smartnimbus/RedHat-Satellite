variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type        = string
  description = "The CIDR block for the subnet."
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  type        = string
  description = "The availability zone for the subnet."
  default     = "us-west-2a"
}

variable "instance_ami" {
  type        = string
  description = "The AMI ID for the EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "The instance type for the EC2 instance."
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "The name of the key pair to use for the EC2 instance."
}


variable "instance_user_data" {
  type        = string
  description = "Custom user data script to be run on instance launch."
  default     = ""
}


variable "instance_name" {
  type        = string
  description = "The name to be used on the instance"
  default     = "default"
}

