variable "region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-west-2"
}

variable "azs" {
  description = "List of Availability Zone suffixes (e.g., ['a', 'b', 'c']) within the region."
  type        = list(string)
  default     = ["a", "b", "c"]
}

variable "ami" {
  description = "AMI ID for the Jenkins EC2 instance (ensure it's compatible with the region and instance type)."
  type        = string
  default     = "ami-075686beab831bb7f"
}

variable "key_name" {
  description = "Desired name for the EC2 key pair."
  type        = string
  default     = "jenkins-key"
}

variable "db_name" {
  description = "Name for the Aurora database."
  type        = string
  default     = "todo_db"
}

variable "db_username" {
  description = "Master username for the Aurora database."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the Aurora database."
  type        = string
  sensitive   = true
}