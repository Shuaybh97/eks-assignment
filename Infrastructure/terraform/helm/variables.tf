variable "environment" {
  type        = string
  description = "Environment name (e.g., sandbox, dev, prod)"
}

variable "region" {
  type        = string
  description = "AWS region for resource deployment"
}

variable "tf_state_bucket" {
  type        = string
  description = "S3 bucket name used for Terraform remote state (used to read core state)"
}
