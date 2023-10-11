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

############## 작업순서 : ALB -> ASG ############## 

module "stage_alb" {
  source           = "../../modules/aws-alb" # local module의 경로
  name             = "stage"                 # variables 설정
  vpc_id           = data.terraform_remote_state.vpc_remote_data.outputs.vpc_id
  HTTP_HTTPS_SG_id = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG_id
  public_subnets   = data.terraform_remote_state.vpc_remote_data.outputs.public_subnets
}

############## 작업순서 : ALB -> ASG ############## 

module "stage_asg" {
  source           = "../../modules/aws-asg" # local module의 경로
  name             = "stage"                 # variables 설정
  instance_type    = "t2.micro"
  SSH_SG_id        = data.terraform_remote_state.vpc_remote_data.outputs.SSH_SG_id
  HTTP_HTTPS_SG_id = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG_id
  min_size         = "1"
  max_size         = "1"
  private_subnets  = data.terraform_remote_state.vpc_remote_data.outputs.private_subnets
}