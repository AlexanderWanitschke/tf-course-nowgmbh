provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner     = "Terraform"
      ProjectID = "666"
    }
  }
}
