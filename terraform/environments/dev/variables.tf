variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance type for worker nodes"
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes"
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes"
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes"
}

variable "capacity_type" {
  type        = string
  description = "Capacity type: ON_DEMAND or SPOT"
}
