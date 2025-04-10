variable "name" {
  description = "Prefix for naming security groups (e.g., app name)."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the security groups will be created."
  type        = string
}