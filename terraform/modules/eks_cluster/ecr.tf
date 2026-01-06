# ECR Repository for application Docker images
resource "aws_ecr_repository" "app" {
  name                 = "${var.cluster_name}-ecr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.cluster_name}-ecr"
  }
}

# Output ECR repository details
output "ecr_repository_url" {
  value       = aws_ecr_repository.app.repository_url
  description = "ECR repository URL for pushing images"
}

output "ecr_repository_name" {
  value       = aws_ecr_repository.app.name
  description = "ECR repository name"
}
