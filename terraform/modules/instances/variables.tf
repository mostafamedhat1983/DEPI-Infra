variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the instance will be launched."
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs to associate with the instance."
  type        = list(string)
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access."
  type        = string
}

variable "iam_instance_profile" {
  description = "Name of the IAM instance profile to attach to the instance."
  type        = string
  default     = null
}