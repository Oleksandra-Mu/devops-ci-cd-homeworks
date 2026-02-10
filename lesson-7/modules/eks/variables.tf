variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "EKS cluster name"
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS"
  type        = list(string)
}

variable "instance_type" {
  default = "t3.medium"
}

variable "desired_size" {
  default = 1
}

variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 1
}
