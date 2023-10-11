data "terraform_remote_state" "vpc_remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-hwang-t"
    key     = "${var.name}/vpc/terraform.tfstate" # var.name = stage or prod
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}

data "terraform_remote_state" "rds_remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-hwang-t"
    key     = "${var.name}/rds/terraform.tfstate" # var.name = stage or prod
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}

data "terraform_remote_state" "alb_remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-hwang-t"
    key     = "${var.name}/app1/terraform.tfstate" # var.name = stage or prod
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}
