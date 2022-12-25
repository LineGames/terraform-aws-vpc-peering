terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  alias      = "jp"
  region     = "ap-northeast-1"
  }

provider "aws" {
  alias      = "kr"
  region     = "ap-northeast-2"
  }

provider "aws" {
  alias      = "sg"
  region     = "ap-southeast-1"
  }

provider "aws" {
  alias      = "de"
  region     = "ue-central-1"
  }

provider "aws" {
  alias      = "us"
  region     = "us-east-1"
  }
