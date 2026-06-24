terraform {
  # Partial S3 backend configuration — remaining values (bucket, key, region)
  # are supplied via -backend-config in CI/CD or a local backend.hcl file for
  # local development. Requires Terraform >= 1.10 for S3 native state locking.
  backend "s3" {
    use_lockfile = true
    
  }
}