resource "aws_iam_role" "jenkins_irsa_role" {
  name = "${var.cluster_name}-jenkins-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          # ТУТ ЗМІНЕНО: на кінці має бути саме ім'я вашого SA (jenkins-sa)
          "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:jenkins:jenkins-sa"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.jenkins_irsa_role.name
}

resource "kubernetes_service_account" "jenkins_sa" {
  metadata {
    name      = "jenkins-sa"
    namespace = "jenkins"
    annotations = {
      # ТУТ ВИПРАВЛЕНО: назва ресурсу тепер збігається (jenkins_irsa_role)
      "eks.amazonaws.com/role-arn" = aws_iam_role.jenkins_irsa_role.arn
    }
  }
}