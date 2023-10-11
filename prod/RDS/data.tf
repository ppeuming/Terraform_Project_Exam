data "terraform_remote_state" "remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-hwang-t"
    key     = "prod/vpc/terraform.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}