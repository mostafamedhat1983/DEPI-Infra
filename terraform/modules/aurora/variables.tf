variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
}