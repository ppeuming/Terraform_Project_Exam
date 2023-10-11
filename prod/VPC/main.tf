terraform {
  backend "s3" {
    key            = "prod/vpc/terraform.tfstate" // 상태파일 저장 경로
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

// VPC
module "prod_vpc" {
  source = "github.com/ppeuming/Terraform_Project_VPC" # github
  name   = "prod_vpc"
  cidr   = local.cidr

  azs              = local.azs
  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  database_subnets = local.database_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  create_database_subnet_group = true # defalt : true

  tags = {
    "TerraformManaged" = "true"
  }
}

// SG
module "SSH_SG" {
  source          = "github.com/ppeuming/Terraform_Project_SG" # github
  name            = "SSH_SG"
  description     = "SSH Port Open"
  vpc_id          = module.prod_vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "SSH Traffic Allow"
      cidr_blocks = local.all_network
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = local.any_port
      to_port     = local.any_port
      protocol    = local.any_protocol
      cidr_blocks = local.all_network
    }
  ]
}

module "HTTP_HTTPS_SG" {
  source          = "github.com/ppeuming/Terraform_Project_SG" # github
  name            = "HTTP_HTTPS_SG"
  description     = "HTTP, HTTPS Port Open"
  vpc_id          = module.prod_vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "HTTP Traffic Allow"
      cidr_blocks = local.all_network
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "HTTPS Traffic Allow"
      cidr_blocks = local.all_network
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = local.any_port
      to_port     = local.any_port
      protocol    = local.any_protocol
      cidr_blocks = local.all_network
    }
  ]
}

module "RDS_SG" {
  source          = "github.com/ppeuming/Terraform_Project_SG" # github
  name            = "RDS_SG"
  description     = "RDS Port Open"
  vpc_id          = module.prod_vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = local.db_port
      to_port     = local.db_port
      protocol    = local.tcp_protocol
      description = "RDS Traffic Allow"
      cidr_blocks = local.private_subnets[0] # App에서만 접근 가능
    },
    {
      from_port   = local.db_port
      to_port     = local.db_port
      protocol    = local.tcp_protocol
      description = "RDS Traffic Allow"
      cidr_blocks = local.private_subnets[1] # App에서만 접근 가능
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = local.any_port
      to_port     = local.any_port
      protocol    = local.any_protocol
      cidr_blocks = local.all_network
    }
  ]
}

// Key Pair Data Source
data "aws_key_pair" "EC2-Key" {
  key_name = "EC2-key"
}

// BastionHost_EIP
resource "aws_eip" "BastionHost_eip" {
  instance = aws_instance.BastionHost.id
  tags = {
    Name = "BastionHost_EIP"
  }
}

// BastionHost
resource "aws_instance" "BastionHost" {
  ami                         = "ami-0ea4d4b8dc1e46212"
  instance_type               = "t2.micro"
  key_name                    = data.aws_key_pair.EC2-Key.key_name
  availability_zone           = local.azs[1]
  subnet_id                   = module.prod_vpc.public_subnets[1]
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.SSH_SG.security_group_id]

  tags = {
    Name = "BastionHost_Instance"
  }
}


