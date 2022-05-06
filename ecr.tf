resource "aws_ecr_repository" "aws-ecr" {
  name = "${var.app_name}-${var.app_environment}-ecr"
  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = var.app_environment
  }
}

output "ecr-uri" {
  value = aws_ecr_repository.aws-ecr.repository_url
}
