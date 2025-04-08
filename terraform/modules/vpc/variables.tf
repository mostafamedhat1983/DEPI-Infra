variable "name" {}
variable "cidr" {}
variable "azs" {
  type = list(string)
}
variable "region" {}
variable "cluster_name" {
  type    = string
  default = ""
}