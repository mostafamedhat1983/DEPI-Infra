variable "name" {
  description = "Name prefix for security groups"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cluster_security_group_id" {
  description = "The security group ID of the EKS cluster"
  type        = string
}