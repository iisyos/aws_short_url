locals {
  backend-config = yamldecode(file("backend-config.yaml"))
}

remote_state {
  backend = "s3"
  config = {
    bucket  = local.backend-config.bucket
    key     = "${path_relative_to_include()}.tfstate"
    region  = local.backend-config.region
    encrypt = local.backend-config.encrypt
  }
}

terraform {
  source = "./modules/short-url"
}

inputs =  {
  bucket_name            = "short-url-bucket-20231230"
  cf_distribution_name   = "short-url-distribution"
  oac_name               = "short-url-oac"
}