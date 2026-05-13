output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "ARN of the IAM role"
}

output "role_name" {
  value       = aws_iam_role.this.name
  description = "Name of the IAM role"
}

output "policy_arn" {
  value       = var.create_policy ? aws_iam_policy.custom[0].arn : ""
  description = "ARN of the custom IAM policy"
}
