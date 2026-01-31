terraform {
  backend "s3" {
    bucket  = ""
    key     = ""
    region  = "eu-west-2"
    encrypt = true
    # use_lockfile = true
  }
}