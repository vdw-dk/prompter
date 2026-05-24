terraform {
  required_version = ">= 1.10.0"

  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.25"
    }
  }

  backend "s3" {
    bucket = "terraform-state"
    key    = "homelab/3/prompter-db/terraform.tfstate"
    region = "us-east-1"
    endpoints = {
      s3 = "https://minio.vdw.dk"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
}
