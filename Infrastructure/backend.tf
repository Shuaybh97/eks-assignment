terraform {
  backend "s3" {
    bucket       = "eks-assignment-tf-state-bucket"
    key          = "eks-project/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}