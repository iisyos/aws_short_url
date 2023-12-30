locals {
  env = yamldecode(file("env.yaml"))
}

remote_state {
  backend = "s3"
  config = {
    bucket  = local.env.bucket
    key     = "${path_relative_to_include()}.tfstate"
    region  = local.env.region
    encrypt = local.env.encrypt
  }
}

terraform {
  source = "./modules/short-url"
}

inputs =  {
  bucket_name            = "short-url-bucket-20231230"
  cf_distribution_name   = "short-url-distribution"
  oac_name               = "short-url-oac"
  kvs_id                 = local.env.kvs_id
}