output "tf_state_bucket_name" {
  value       = aws_s3_bucket.tf_state.id
  description = "Name of the S3 bucket used for Terraform remote state. Set as TF_STATE_BUCKET in GitHub Actions variables."
}

output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "ARN of the GitHub Actions IAM role assumed via OIDC in CI workflows."
}

output "github_oidc_provider_arn" {
  value       = local.github_oidc_provider_arn
  description = "ARN of the GitHub Actions OIDC provider."
}
