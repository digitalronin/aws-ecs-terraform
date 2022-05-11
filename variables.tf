variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "app_count" {
  type    = number
  default = 1
}

variable "app_name" {
  type    = string
  default = "hello-world"
}

variable "app_environment" {
  type    = string
  default = "dev"
}

variable "rails_app_port" {
  type = string
  default = "3000"
}

variable "rails_master_key" {
  type = string
}

variable "dbpassword" {
  type = string
}
