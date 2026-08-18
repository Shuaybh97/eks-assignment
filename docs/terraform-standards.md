# Terraform Standards

- Use Terraform 1.x compatible syntax
- Follow AWS provider best practices
- Use variables for all configurable values
- Tag all AWS resources with `Environment`, `Project`, and `ManagedBy` tags
- Prefer modular design - keep modules focused and reusable
- Use `locals.tf` for computed values and transformations
- Document outputs clearly
