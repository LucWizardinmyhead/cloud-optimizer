output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "kubernetes_deployment_name" {
  value = kubernetes_deployment.app.metadata[0].name
}
