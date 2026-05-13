# IAM Role for AWS Services or IRSA
resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = var.use_irsa ? jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider_url}:sub" = "system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account}"
            "${var.oidc_provider_url}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  }) : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = var.service_name
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.global_tags
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "managed_policies" {
  count      = length(var.managed_policies)
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/${var.managed_policies[count.index]}"
}

# Create custom policy if specified
resource "aws_iam_policy" "custom" {
  count       = var.create_policy ? 1 : 0
  name        = var.policy_name
  description = var.policy_description

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.policy_statements
  })

  tags = var.global_tags
}

# Attach custom policy
resource "aws_iam_role_policy_attachment" "custom" {
  count      = var.create_policy ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom[0].arn
}
