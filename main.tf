terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# AWS Provider - Authentication via environment variables
provider "aws" {
  region = "us-west-1"
}

# Docker provider will use default socket
provider "docker" {}

# Kubernetes provider (for local Minikube)
provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

# ECR Repository
resource "aws_ecr_repository" "app" {
  name                 = "my-app"
  image_tag_mutability = "MUTABLE" # For development

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Kubernetes Deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.ecr_creds.metadata[0].name
        }
        container {
          image = "${aws_ecr_repository.app.repository_url}:latest"
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# ECR Authentication
data "aws_ecr_authorization_token" "token" {}

# Kubernetes Secret for ECR credentials
resource "kubernetes_secret" "ecr_creds" {
  metadata {
    name = "ecr-credentials"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${aws_ecr_repository.app.repository_url}" = {
          auth = base64encode("AWS:${data.aws_ecr_authorization_token.token.password}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}
