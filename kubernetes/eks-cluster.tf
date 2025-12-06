module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.name_of_eks_cluster
  kubernetes_version = var.cluster_vs

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  subnet_ids = module.myAppp-vpc.private_subnets
  vpc_id = module.myAppp-vpc.vpc_id
  control_plane_subnet_ids = module.myAppp-vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.small"]

      min_size     = 1
      max_size     = 6
      desired_size = 3
    }
  }

  tags = {
    environment = var.env_name
    application = "myAppp"
  }
}
