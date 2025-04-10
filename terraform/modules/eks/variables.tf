variable "cluster_name" {
  description = "Name for the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed."
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the EKS cluster and node groups."
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs to associate with the EKS cluster control plane ENIs."
  type        = list(string)
  default     = []
}

variable "node_group_name" {
  description = "Name for the EKS managed node group."
  type        = string
}

variable "node_type" {
  description = "EC2 instance type for the EKS worker nodes."
  type        = string
}

variable "region" {
  description = "AWS region where the cluster is deployed (used for configuring kubectl output)."
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access to worker nodes."
  type        = string
}

variable "min_size" {
  description = "Minimum number of worker nodes in the node group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes in the node group."
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of worker nodes in the node group."
  type        = number
  default     = 1
}