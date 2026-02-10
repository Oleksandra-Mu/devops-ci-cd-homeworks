output "s3_bucket" {
  value = module.s3_backend.s3_bucket_name
}

output "dynamodb_table" {
  value = module.s3_backend.dynamodb_table_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}
