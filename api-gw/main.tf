terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.74"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">=2.2"
    }
  }
  required_version = ">=1.0"
}
