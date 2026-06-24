terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  # Bootstrap intentionally uses local state — it creates the remote backend
  # resources (S3 + DynamoDB) used by all other Terraform configs.
  # Store the resulting terraform.tfstate securely (e.g. commit to a private
  # repo or back it up manually after first apply).
  backend "local" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
}

provider "aws" {
  region = var.region
}
