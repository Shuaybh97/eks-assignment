terraform {
  backend "s3" {
    bucket       = "eks-terraform-project-sh-bucket"
    key          = "eks-project/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}