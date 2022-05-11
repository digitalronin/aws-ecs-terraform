resource "aws_ecr_repository" "aws-ecr" {
  name = "${var.app_name}-${var.app_environment}-ecr"
  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = var.app_environment
  }
}

locals {
  rails_app_image = "${aws_ecr_repository.aws-ecr.repository_url}:${var.rails_app_image}"
}

output "ecr-uri" {
  value = aws_ecr_repository.aws-ecr.repository_url
}

