# CI/CD Standards

## General
- Use GitHub Actions for CI/CD pipelines
- Store pipeline definitions in `.github/workflows/`
- Pin all action versions to a specific SHA or tag
- Use environment-specific secrets and variables, never hardcode credentials

## Build
- Run linting and tests before building
- Use Docker multi-stage builds to produce lean images
- Tag images with the Git commit SHA and a semantic version where applicable
- Push images to ECR after a successful build

## Testing
- Run unit tests on every pull request
- Block merges if tests fail
- Validate Terraform plans (`terraform plan`) on pull requests targeting infrastructure changes
- Use `kubectl dry-run` to validate Kubernetes manifests before apply

## Deployment
- Follow GitOps principles — deployments triggered by Git changes via ArgoCD
- Use separate workflows for staging and production environments
- Require manual approval for production deployments
- Roll back automatically on failed health checks

## Security
- Scan Docker images for vulnerabilities before pushing (e.g. Trivy)
- Use IRSA or OIDC-based authentication to AWS — never use long-lived IAM keys in CI
- Audit and rotate secrets regularly
- Use Checkov for Terraform infrastructure scanning
- Restrict workflow permissions using `permissions` blocks in GitHub Actions
