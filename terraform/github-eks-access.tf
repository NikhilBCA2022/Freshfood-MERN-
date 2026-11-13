# ==========================================================
# IAM USER FOR GITHUB-HOSTED ACTIONS RUNNERS
# ==========================================================

resource "aws_iam_user" "github_deploy" {
  name = "${var.project_name}-${var.environment}-github-deploy-user"
  path = "/ci-cd/"

  tags = {
    Name      = "${var.project_name}-github-deploy-user"
    Project   = var.project_name
    Component = "CI/CD"
  }
}

# ==========================================================
# ECR PUSH AND EKS CONNECTION PERMISSIONS
# ==========================================================

resource "aws_iam_user_policy" "github_deploy" {
  name = "${var.project_name}-github-deploy-policy"
  user = aws_iam_user.github_deploy.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ECRAuthentication"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Sid    = "ECRImagePush"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage"
        ]

        Resource = [
          for repo in aws_ecr_repository.apps : repo.arn
        ]
      },
      {
        Sid    = "EKSClusterConnection"
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = aws_eks_cluster.main.arn
      }
    ]
  })
}

# ==========================================================
# REGISTER IAM USER WITH EKS
# ==========================================================

resource "aws_eks_access_entry" "github_deploy" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_iam_user.github_deploy.arn
  type          = "STANDARD"
}

# ==========================================================
# RESTRICT KUBERNETES ACCESS TO FRESHFOOD NAMESPACE
# ==========================================================

resource "aws_eks_access_policy_association" "github_deploy" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_iam_user.github_deploy.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"

  access_scope {
    type = "namespace"

    namespaces = [
      var.backend_namespace
    ]
  }

  depends_on = [
    aws_eks_access_entry.github_deploy
  ]
}
