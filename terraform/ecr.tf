locals {
  ecr_repositories = toset([
    "frontend",
    "admin",
    "backend"
  ])
}

resource "aws_ecr_repository" "apps" {
  for_each = local.ecr_repositories

  name                 = "${var.project_name}/${each.value}"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "${var.project_name}-${each.value}"
  }
}

resource "aws_ecr_lifecycle_policy" "apps" {
  for_each = aws_ecr_repository.apps

  repository = each.value.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the latest 10 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}
