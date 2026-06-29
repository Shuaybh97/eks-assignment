data "aws_iam_role" "github_actions" {
  name = "github-actions-oidc-${var.environment}"
}
