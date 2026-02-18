variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider (from EKS)"
  type        = string
  default     = ""
}

variable "oidc_provider_url" {
  description = "Issuer URL of the OIDC provider (from EKS)"
  type        = string
  default     = ""
}

variable "github_username" {
  description = "GitHub username (optional)"
  type        = string
  default     = ""
}

variable "github_token" {
  description = "GitHub token (optional)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "github_repo_url" {
  description = "Git repository URL for Jenkins/Argo interactions"
  type        = string
  default     = ""
}
