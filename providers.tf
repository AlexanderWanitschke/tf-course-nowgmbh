provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Owner     = "Terraform"
      ProjectID = "666"
    }
  }
}
