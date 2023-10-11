terraform {
  backend "s3" {
    key            = "stage/app1/terraform.tfstate" // 상태파일 저장 경로
    bucket         = "myterraform-bucket-state-hwang-t"
    region         = "ap-northeast-2"
    profile        = "terraform_user"
    dynamodb_table = "myTerraform-bucket-lock-hwang-t"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "terraform_user"
}
