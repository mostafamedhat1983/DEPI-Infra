variable "name" {
  description = "Name prefix for VPC resources (e.g., 'main', 'prod')."
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "List of Availability Zone suffixes (e.g., ['a', 'b', 'c']) within the specified region."
  type        = list(string)
}

variable "region" {
  description = "AWS region where the VPC is created (used for constructing AZ names)."
  type        = string
}

variable "cluster_name" {
  description = "Optional: Name of the EKS cluster, used for tagging subnets appropriately ('kubernetes.io/cluster/...')."
  type        = string
  default     = ""
}