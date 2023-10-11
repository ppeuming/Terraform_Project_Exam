terraform {
  backend "s3" {
    key            = "prod/rds/terraform.tfstate" // 상태파일 저장 경로
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

module "app1_db" {
  source     = "github.com/ppeuming/Terraform_Project_RDS" # github
  identifier = "prod-app1-database"                        # 알파벳 소문자, 숫자, 하이픈(-) 조합

  // db spec
  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = "mysql"
  engine_version       = "8.0.31"
  major_engine_version = "8.0" # DB option group (example 그대로) # required option
  instance_class       = "db.t2.small"
  allocated_storage    = 5

  // db 접속
  db_name                             = "webDB"
  username                            = "admin"    # username for the master DB user
  password                            = "password" # password for the master DB user
  iam_database_authentication_enabled = true       # defalt : false # iam 계정 인증 
  manage_master_user_password         = false      # allow RDS to manage the master user password in Secret Manager # default : true

  // db network
  port                   = "3306"
  multi_az               = false
  db_subnet_group_name   = data.terraform_remote_state.remote_data.outputs.database_subnet_group
  subnet_ids             = data.terraform_remote_state.remote_data.outputs.database_subnets # A list of VPC subnet IDs
  vpc_security_group_ids = [data.terraform_remote_state.remote_data.outputs.RDS_SG_id]

  // parameters
  family = "mysql8.0" # The family of the DB parameter group (example 그대로) # required option
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  // 삭제 옵션 
  skip_final_snapshot = true  # RDS instance 삭제 시, 스냅샷 생성 X (true값으로 설정 시, terraform destroy 정상 수행 가능)
  deletion_protection = false # default : flase # The database can't be deleted when this value is set to true
}
