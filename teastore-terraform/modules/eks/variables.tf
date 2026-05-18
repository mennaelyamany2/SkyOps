variable "cluster_name" {
  default = "teastore-eks"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {}

variable "public_subnets" {
  type = list(string)
}
