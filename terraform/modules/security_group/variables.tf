variable "name" {
  description = "Name prefix for security groups"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  type        = string
}