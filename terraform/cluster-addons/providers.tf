provider "aws" {
  region  = "ap-south-1"
  profile = "PowerUserAccess-774609032429"
}

data "aws_eks_cluster" "main" {
  name = "freshfood-eks"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name", "freshfood-eks",
        "--region", "ap-south-1",
        "--profile", "PowerUserAccess-774609032429"
      ]
    }
  }
}