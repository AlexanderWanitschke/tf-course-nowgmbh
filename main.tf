terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.71"
    }
  }
  required_version = ">=1.0"
}

provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Owner     = "Terraform"
      ProjectID = "666"
    }
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-04c921614424b07cd" # Das Ist ein Kommentar
  instance_type = "t2.micro"
  tags = {
    Name = "mro-test"
  }
}
