variable "service_name" {}
variable "environment" { default = "hml" }

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "The AWS account ID."
  type        = string
  optional    = true
}
