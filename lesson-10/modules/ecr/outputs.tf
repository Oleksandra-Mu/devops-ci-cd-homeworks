output "repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_id" {
  description = "ECR repository id"
  value       = aws_ecr_repository.this.id
}