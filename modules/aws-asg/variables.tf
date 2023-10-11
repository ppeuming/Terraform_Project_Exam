variable "name" {
  description = "ENV Name (Stage or Prod)"
  type = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
}

variable "SSH_SG_id" {
  description = "SSH_SG_ID"
  type = string
}

variable "HTTP_HTTPS_SG_id" {
  description = "HTTP_HTTPS_SG_ID"
  type = string
}

variable "min_size" {
  description = "Min_size of ASG"
  type = string
}

variable "max_size" {
  description = "Max_size of ASG"
  type = string
}

variable "private_subnets" {
  description = "Private_Subnets"
  type = list(string)
}