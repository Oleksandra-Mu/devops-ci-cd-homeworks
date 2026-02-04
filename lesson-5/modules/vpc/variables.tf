variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to place subnets in"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name tag for VPC and related resources"
  type        = string
  default     = "lesson-5-vpc"
}

variable "tags" {
  description = "Additional tags to add to resources"
  type        = map(string)
  default     = {}
}

/* Ensure matching counts */
locals {
  valid_counts = length(var.availability_zones) == length(var.public_subnets) && length(var.availability_zones) == length(var.private_subnets)
}

// Basic validation
// Note: older Terraform versions may ignore the block; keep variables simple.