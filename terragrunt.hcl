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
