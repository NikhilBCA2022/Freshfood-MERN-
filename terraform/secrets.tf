resource "aws_secretsmanager_secret" "backend" {
  name                    = "${var.project_name}/${var.environment}/backend"
  description             = "Freshfood backend application secrets"
  recovery_window_in_days = 7

  tags = {
    Name      = "${var.project_name}-backend-secrets"
    Component = "Backend Secrets"
  }
}
