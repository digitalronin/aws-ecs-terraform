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

variable "rails_master_key" {
  type    = string
}

# TODO: This should come from the attributes of an RDS and Elasticache Redis
# instance we create via terraform
variable "database_url" {
  type    = string
}

# TODO: This should come from the attributes of an RDS and Elasticache Redis
# instance we create via terraform
variable "redis_url" {
  type    = string
}
