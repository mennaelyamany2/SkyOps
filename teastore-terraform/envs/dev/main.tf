module "vpc" {
  source = "../../modules/vpc"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name   = "teastore-eks"
  region         = "us-east-1"

  vpc_id = module.vpc.vpc_id

  public_subnets = module.vpc.public_subnets
}
