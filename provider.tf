terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4"
      configuration_aliases = [aws.this, aws.peer]
    }
  }
}
provider "aws" {
  alias      = "jp"
  region     = "ap-northeast-1"

  tags {
      tags = {
      Create-by = "Terraform"
      }
    }
  }

provider "aws" {
  alias      = "kr"
  region     = "ap-northeast-2"
  
  tags {
      tags = {
      Create-by = "Terraform"
      }
    }
  }

provider "aws" {
  alias      = "sg"
  region     = "ap-southeast-1"
  
  tags {
      tags = {
      Create-by = "Terraform"
      }
    }
  }

provider "aws" {
  alias      = "de"
  region     = "ue-central-1"
  
  tags {
      tags = {
      Create-by = "Terraform"
      }
    }
  }

provider "aws" {
  alias      = "us"
  region     = "us-east-1"
  
  tags {
      tags = {
      Create-by = "Terraform"
      }
    }
  }
