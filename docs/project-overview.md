# Project Overview

This is an EKS (Elastic Kubernetes Service) assignment project that deploys a Next.js portfolio application to AWS using Terraform for infrastructure and Kubernetes for orchestration.

## Tech Stack
- **Frontend**: Next.js (TypeScript, React, Tailwind CSS)
- **Infrastructure**: Terraform (AWS EKS, VPC, IAM, ECR)
- **Orchestration**: Kubernetes (ArgoCD, Traefik, Cert-Manager, External DNS)
- **Containerization**: Docker
- **Cloud Provider**: AWS

## Project Structure
- `app/` - Next.js portfolio application
- `Infrastructure/` - Terraform modules and configurations
  - `modules/` - Reusable Terraform modules (eks, ecr, iam, networking)
  - `manifests/` - Kubernetes manifests
  - `helm-values/` - Helm chart value files
  - `environments/` - Environment-specific tfvars

## Infrastructure Patterns
- EKS cluster with managed node groups
- IRSA (IAM Roles for Service Accounts) for pod-level permissions
- Private subnets for worker nodes, public subnets for load balancers
- External DNS for automatic DNS management
- Cert-Manager for TLS certificate automation
- Traefik as ingress controller
- ArgoCD for GitOps deployments

## Security Best Practices
- Never commit credentials or secrets
- Use AWS Secrets Manager or Kubernetes Secrets for sensitive data
- Enable encryption at rest and in transit
- Follow principle of least privilege for IAM roles
- Use security groups and NACLs appropriately

## Conventions
- Use kebab-case for file names and resource names
- Use camelCase for TypeScript/JavaScript variables and functions
- Use snake_case for Terraform variables and locals
- Prefix AWS resources with project or environment identifiers
- Comment complex logic and non-obvious decisions

## Dependencies
- Keep dependencies up to date but version-pinned
- Review security advisories regularly
- Document any version constraints or compatibility requirements

## Testing
- Test infrastructure changes in non-production environments first
- Validate Terraform plans before applying
- Test application locally before containerizing
- Verify Kubernetes manifests with kubectl dry-run

## When Generating Code
- Prioritize security and best practices
- Include error handling and validation
- Add comments for complex sections
- Follow existing patterns in the codebase
- Consider observability (logging, metrics, tracing)
