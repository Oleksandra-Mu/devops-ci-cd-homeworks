output "namespace" {
  description = "ArgoCD namespace"
  value       = var.namespace
}

output "argo_cd_server_service" {
  description = "ArgoCD server service"
  value       = "${var.name}-argocd-server.${var.namespace}.svc.cluster.local"
}

output "admin_password" {
  description = "Command to get initial admin password"
  value       = "kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d"
}