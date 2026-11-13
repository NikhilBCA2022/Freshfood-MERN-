data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

locals {
  eks_oidc_issuer = replace(
    aws_eks_cluster.main.identity[0].oidc[0].issuer,
    "https://",
    ""
  )
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]

  tags = {
    Name = "${var.cluster_name}-oidc-provider"
  }
}

resource "aws_iam_role" "backend" {
  name = "${var.project_name}-${var.environment}-backend-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "${local.eks_oidc_issuer}:aud" = "sts.amazonaws.com"

          "${local.eks_oidc_issuer}:sub" = "system:serviceaccount:${var.backend_namespace}:${var.backend_service_account_name}"
        }
      }
    }]
  })

  tags = {
    Name      = "${var.project_name}-backend-irsa"
    Component = "Backend S3 Access"
  }
}

resource "aws_iam_role_policy" "backend_s3" {
  name = "${var.project_name}-backend-s3-policy"
  role = aws_iam_role.backend.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]

        Resource = aws_s3_bucket.food_images.arn
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.food_images.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "backend_secretsmanager" {
  name = "${var.project_name}-backend-secretsmanager-policy"
  role = aws_iam_role.backend.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]

      Resource = aws_secretsmanager_secret.backend.arn
    }]
  })
}
