variable "vpc_id" {
  description = "ID of the VPC where the Aurora cluster will be deployed."
  type        = string
}

variable "subnets" {
  description = "List of private subnet IDs for the DB subnet group (should be in at least 2 AZs)."
  type        = list(string)
}

variable "db_name" {
  description = "Name for the initial database created in the cluster."
  type        = string
}

variable "username" {
  description = "Master username for the database."
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Master password for the database."
  type        = string
  sensitive   = true
}

variable "allowed_security_group_id" {
  description = "Security Group ID allowed to access the database on port 3306."
  type        = string
  default     = ""
}