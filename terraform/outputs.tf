output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "ecr_repository_urls" {
  value = {
    for name, repository in aws_ecr_repository.apps :
    name => repository.repository_url
  }
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_nodes.arn
}

output "food_images_bucket_name" {
  value = aws_s3_bucket.food_images.bucket
}

output "food_images_bucket_arn" {
  value = aws_s3_bucket.food_images.arn
}

output "eks_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "eks_oidc_issuer" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "backend_iam_role_arn" {
  value = aws_iam_role.backend.arn
}

output "backend_namespace" {
  value = var.backend_namespace
}

output "backend_service_account_name" {
  value = var.backend_service_account_name
}


output "backend_secret_arn" {
  value = aws_secretsmanager_secret.backend.arn
}

output "backend_secret_name" {
  value = aws_secretsmanager_secret.backend.name
}


output "github_deploy_user_arn" {
  description = "IAM user ARN used by GitHub Actions deployment."
  value       = aws_iam_user.github_deploy.arn
}
