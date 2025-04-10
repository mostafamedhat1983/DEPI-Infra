variable "instance_name" {}
variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_groups" {
  type = list(string)
}
variable "key_name" {}