#Cloud-Optimized Kubernetes Infrastructure

**Automated, self-healing cloud pipeline cutting costs by 50%**  
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes)](https://kubernetes.io/)

##  Features
- **Self-healing** pods with liveness/readiness probes
- **AWS ECR** vulnerability scanning
- **Terraform**-managed infrastructure
- **Prometheus** monitoring

##  Quick Start
```bash
terraform -chdir=infra init
terraform -chdir=infra apply
kubectl apply -f infra/kubernetes/
```


![📊 Architecture](https://github.com/user-attachments/assets/cadcb937-4313-4d92-88ab-7f0576205ede)
