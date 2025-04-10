variable "region" {
  default = "us-west-2"
}

variable "azs" {
  type    = list(string)
  default = ["a", "b", "c"]
}

variable "ami" {
  default = "ami-00c257e12d6828491"
}

variable "key_name" {
  default = "jenkins-key"
}

variable "app_name" {
  default = "python-app"
}

variable "app_port" {
  default = 5000
}

variable "db_name" {
  default = "todo_db"
}

variable "db_username" {
  sensitive = true
}

variable "db_password" {
  sensitive = true
}