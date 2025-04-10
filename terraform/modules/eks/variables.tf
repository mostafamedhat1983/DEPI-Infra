variable "cluster_name" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "node_group_name" {}
variable "node_type" {}
variable "region" {
  description = "AWS region"
  type        = string
}
variable "key_name" {
  type = string
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "worker_sg_id" {
  description = "Security group ID for worker node SSH access"
  type        = string
  default     = ""
}