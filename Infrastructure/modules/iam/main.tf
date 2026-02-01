resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = var.service_name },
      Action    = "sts:AssumeRole"
    }]
  })
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.managed_policies)
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam:aws:policy/${each.value}"
}