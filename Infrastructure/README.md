# Infrastructure

This directory contains all infrastructure-as-code for the EKS assignment project.

## Structure

```
Infrastructure/
  bootstrap-terraform/    One-time AWS prerequisites (S3 state bucket, GitHub OIDC provider, IAM role)
  terraform/
    core/                 EKS cluster, VPC, ECR, IAM roles, IRSA
    helm/                 Helm releases (Traefik, ArgoCD, Cert-Manager, External DNS, Prometheus, Secrets Store CSI)
    modules/              Reusable Terraform child modules
  kubernetes/
    helm-values/          Helm chart value overrides
    manifests/            Kubernetes manifests synced by ArgoCD
```

## Deployment Order

### 1. Bootstrap (one-time)

Creates the S3 state bucket and the GitHub Actions OIDC IAM role used by all subsequent CI runs.

```bash
cd Infrastructure/bootstrap-terraform
terraform init
terraform apply -var-file="environments/sandbox.tfvars"
```

After apply, note the outputs and set the following GitHub Actions repository variables:

| Output | GitHub Actions Variable |
|---|---|
| `tf_state_bucket_name` | `TF_STATE_BUCKET` |
| `github_actions_role_arn` | _(used in workflow, no variable needed)_ |

The following variables should also be set:

| Variable | Value |
|---|---|
| `AWS_ACCOUNT_ID` | Your AWS account ID |
| `AWS_REGION` | `eu-west-1` |
| `ECR_REPOSITORY_NAME` | `eks-project-eu-west-1-sandbox-ecr` |
| `EKS_CLUSTER_NAME` | `eks-project-eu-west-1-sandbox-cluster` |
| `ARGOCD_SERVER` | ArgoCD server hostname |

And the following secrets:

| Secret | Description |
|---|---|
| `ARGOCD_AUTH_TOKEN` | ArgoCD API token for CLI login |
| `GH_DEPLOY_TOKEN` | GitHub PAT with repo write access for manifest updates |

---

### 2. Core Infrastructure

Provisions the EKS cluster, VPC, ECR repository, IAM roles, and IRSA configuration.

```bash
cd Infrastructure/terraform/core
terraform init \
  -backend-config="bucket=eks-project-eu-west-1-sandbox-tf-state" \
  -backend-config="key=sandbox/core.tfstate" \
  -backend-config="region=eu-west-1"

terraform apply -var-file="environments/sandbox.tfvars"
```

State is stored at `s3://eks-project-eu-west-1-sandbox-tf-state/sandbox/core.tfstate`.

---

### 3. Helm Releases

Deploys platform tooling onto the cluster. Reads EKS outputs from core state via `terraform_remote_state`.

```bash
cd Infrastructure/terraform/helm
terraform init \
  -backend-config="bucket=eks-project-eu-west-1-sandbox-tf-state" \
  -backend-config="key=sandbox/platform.tfstate" \
  -backend-config="region=eu-west-1"

terraform apply \
  -var="tf_state_bucket=eks-project-eu-west-1-sandbox-tf-state" \
  -var-file="environments/sandbox.tfvars"
```

State is stored at `s3://eks-project-eu-west-1-sandbox-tf-state/sandbox/platform.tfstate`.

---

### 4. Application Deployment (ArgoCD)

ArgoCD is configured via `kubernetes/manifests/argocd-appspec.yaml` to watch the `Infrastructure/kubernetes/manifests/` path in this repository. Once the Helm release for ArgoCD is deployed, apply the app spec manually on first setup:

```bash
kubectl apply -f Infrastructure/kubernetes/manifests/argocd-appspec.yaml
```

Subsequent deployments are handled automatically by the `argocd-deploy` GitHub Actions workflow, which updates the image tag in `kubernetes/manifests/deployment.yaml` and triggers a sync.

---

## CI/CD

The `terraform` workflow in `.github/workflows/terraform.yml` runs automatically on push/PR to `master` for changes under `Infrastructure/`:

```
lint-and-scan → plan-core → apply-core → plan-helm-releases → apply-helm-releases
```

Apply jobs only run on push to `master` (not on PRs).

## Local Development

Create a `backend.hcl` file (gitignored) for local `terraform init`:

```hcl
bucket = "eks-project-eu-west-1-sandbox-tf-state"
key    = "sandbox/core.tfstate"   # or platform.tfstate
region = "eu-west-1"
```

Then:

```bash
terraform init -backend-config=backend.hcl
```
