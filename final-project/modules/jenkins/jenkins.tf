resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version    = "5.7.2"
  create_namespace = true
  wait    = false

  values = [
    file("${path.module}/values.yaml")
  ]
}
