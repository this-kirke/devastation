# Cluster Devastation

Complete infrastructure and DevOps environment with AWS CLI, kubectl, Terraform, and Helm. Built on the base devastation foundation for cloud-native development and operations.

## Purpose

Provides everything needed for infrastructure as code, Kubernetes management, and cloud operations. Includes comprehensive tooling for AWS, Kubernetes, and infrastructure automation workflows.

## What's Included

### Cloud & Infrastructure Tools
- **AWS CLI v2**: Complete AWS service integration and management
- **kubectl**: Kubernetes command-line interface for cluster operations
- **Helm**: Kubernetes package manager for application deployment
- **Terraform**: Infrastructure as Code with HashiCorp Configuration Language

### Development Tools
- **YAML LSP**: Language server with Kubernetes schema validation
- **Terraform LSP**: HCL syntax support and autocompletion
- **Bash LSP**: Shell script linting and completion
- **All base tools**: Neovim, tmux, Zsh, Git, Claude Code, etc.

### Neovim Integration
- **Multi-Language LSP**: YAML, HCL, Bash, JSON, Dockerfile support
- **Schema Validation**: Kubernetes manifests, Docker Compose, GitHub Actions
- **Syntax Highlighting**: Advanced parsing for infrastructure languages
- **File Management**: Organized navigation for infrastructure projects

## Building

```bash
# Build cluster container
make cluster

# Build with custom username
make USERNAME=$(whoami) cluster

# Direct Docker build
docker buildx build -t devastation/cluster:latest ./cluster
```

## Usage

### Basic Infrastructure Development
```bash
docker run -it --rm \
  -v $(pwd):/src/MyInfraProject \
  -w /src/MyInfraProject \
  -e PROJECT_NAME=MyInfraProject \
  devastation/cluster:latest
```

### With AWS and Kubernetes Access
```bash
docker run -it --rm \
  -v $(pwd):/src/MyInfraProject \
  -v ~/.aws:/home/dev/.aws \
  -v ~/.kube:/home/dev/.kube \
  -w /src/MyInfraProject \
  -e PROJECT_NAME=MyInfraProject \
  devastation/cluster:latest
```

### With Full Configuration Persistence
```bash
docker run -it --rm \
  -v $(pwd):/src/MyInfraProject \
  -v ~/.config/git:/home/dev/.config/git \
  -v ~/.config/claude:/home/dev/.config/claude \
  -v ~/.aws:/home/dev/.aws \
  -v ~/.kube:/home/dev/.kube \
  -v ~/.ssh:/home/dev/.ssh \
  -w /src/MyInfraProject \
  -e PROJECT_NAME=MyInfraProject \
  devastation/cluster:latest
```

## tmux Windows

The container starts with six specialized windows:

1. **cluster**: Main infrastructure operations shell
2. **editor**: Neovim with infrastructure LSP active
3. **aws**: AWS CLI operations and resource management
4. **terraform**: Infrastructure as Code development
5. **kubectl**: Kubernetes cluster management
6. **claude**: Claude Code assistant

## AWS Workflow

### Configuration
```bash
# Interactive setup
aws configure

# Named profiles
aws configure --profile production
aws configure --profile development

# SSO setup
aws sso configure

# Environment variables
export AWS_PROFILE=development
export AWS_DEFAULT_REGION=us-west-2
```

### Common Operations
```bash
# EC2 management
aws ec2 describe-instances
aws ec2 start-instances --instance-ids i-1234567890abcdef0
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# S3 operations
aws s3 ls
aws s3 cp file.txt s3://my-bucket/
aws s3 sync ./directory/ s3://my-bucket/prefix/

# EKS cluster access
aws eks list-clusters
aws eks update-kubeconfig --name my-cluster --region us-west-2

# IAM management
aws iam list-users
aws iam list-roles
aws sts get-caller-identity
```

## Kubernetes Workflow

### Cluster Management
```bash
# Context management
kubectl config current-context
kubectl config get-contexts
kubectl config use-context my-cluster

# Cluster information
kubectl cluster-info
kubectl get nodes
kubectl get namespaces
```

### Resource Operations
```bash
# Pods and services
kubectl get pods
kubectl get services
kubectl get deployments
kubectl describe pod my-pod
kubectl logs my-pod -f
kubectl exec -it my-pod -- /bin/bash

# Apply configurations
kubectl apply -f deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/user/repo/main/manifest.yaml
kubectl delete -f deployment.yaml

# Namespace operations
kubectl create namespace my-namespace
kubectl config set-context --current --namespace=my-namespace
```

### Helm Package Management
```bash
# Repository management
helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo wordpress

# Chart operations
helm install my-release bitnami/wordpress
helm upgrade my-release bitnami/wordpress
helm rollback my-release 1
helm uninstall my-release

# Chart development
helm create my-chart
helm template my-chart
helm package my-chart
helm dependency update
```

## Terraform Workflow

### Project Management
```bash
# Initialize project
terraform init

# Planning and validation
terraform validate
terraform plan
terraform plan -out=tfplan

# Apply changes
terraform apply
terraform apply tfplan
terraform apply -auto-approve

# State management
terraform show
terraform state list
terraform state show aws_instance.example
terraform import aws_instance.example i-1234567890abcdef0

# Cleanup
terraform destroy
```

### Module Development
```bash
# Module structure
modules/
├── vpc/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
└── security-group/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf

# Using modules
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2b"]
}
```

## Neovim Features

### LSP Capabilities
- **YAML Intelligence**: Kubernetes resource validation with schemas
- **Terraform Support**: HCL autocompletion and resource documentation
- **Bash Integration**: Script linting and command completion
- **JSON/YAML**: Schema validation for various config files
- **Error Detection**: Real-time validation for infrastructure files

### Schema Support
- **Kubernetes**: Pod, Service, Deployment, ConfigMap validation
- **Helm**: Chart.yaml and values.yaml validation
- **Docker Compose**: docker-compose.yml schema checking
- **GitHub Actions**: Workflow file validation
- **Dependabot**: dependabot.yml configuration validation

## Project Structure Examples

### Terraform Infrastructure
```
infrastructure/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── staging/
│   └── prod/
├── modules/
│   ├── vpc/
│   ├── security-groups/
│   └── ecs-cluster/
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

### Kubernetes Manifests
```
k8s-manifests/
├── namespaces/
│   ├── development.yaml
│   └── production.yaml
├── deployments/
│   ├── api-deployment.yaml
│   └── web-deployment.yaml
├── services/
│   ├── api-service.yaml
│   └── web-service.yaml
├── ingress/
│   └── app-ingress.yaml
└── configmaps/
    ├── app-config.yaml
    └── env-config.yaml
```

### Helm Charts
```
charts/
└── my-app/
    ├── Chart.yaml
    ├── values.yaml
    ├── values-dev.yaml
    ├── values-prod.yaml
    └── templates/
        ├── deployment.yaml
        ├── service.yaml
        ├── ingress.yaml
        └── configmap.yaml
```

## Customization

### Add Infrastructure Tools
```dockerfile
FROM devastation/cluster:latest

# Add additional tools
RUN curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_x86_64.tar.gz && \
    tar -xzf k9s_Linux_x86_64.tar.gz && \
    mv k9s /usr/local/bin/ && \
    rm k9s_Linux_x86_64.tar.gz

# Install additional Helm plugins
RUN helm plugin install https://github.com/databus23/helm-diff
```

### Custom AWS Configuration
```bash
# Mount AWS SSO configuration
docker run -it --rm \
  -v $(pwd):/src/MyProject \
  -v ~/.aws:/home/dev/.aws \
  -w /src/MyProject \
  -e PROJECT_NAME=MyProject \
  devastation/cluster:latest
```

### Custom Kubernetes Tools
```bash
# Add kubectl plugins
mkdir -p ~/.local/bin
curl -LO "https://github.com/ahmetb/kubectx/releases/latest/download/kubectx"
chmod +x kubectx
mv kubectx ~/.local/bin/

# Mount in container
-v ~/.local/bin:/home/dev/.local/bin
```

## Security Considerations

### Credential Management
- **AWS Credentials**: Use IAM roles when possible, mount `~/.aws` for local dev
- **Kubernetes Config**: Mount `~/.kube` for cluster access
- **SSH Keys**: Mount `~/.ssh` for Git operations and server access
- **Environment Variables**: Use for temporary credentials

### Best Practices
- Use least-privilege access principles
- Rotate credentials regularly
- Use parameter stores for sensitive values
- Enable CloudTrail for AWS audit logging
- Use Kubernetes RBAC for cluster access

## Common Commands

```bash
# AWS operations
aws sts get-caller-identity    # Check current AWS identity
aws ec2 describe-regions       # List available AWS regions
aws s3 ls                      # List S3 buckets
aws eks list-clusters          # List EKS clusters

# Kubernetes operations
kubectl get all                # List all resources
kubectl top nodes              # Node resource usage
kubectl top pods               # Pod resource usage
kubectl describe node <name>   # Node details

# Terraform operations
terraform fmt                  # Format code
terraform graph               # Generate dependency graph
terraform output              # Show output values
terraform workspace list     # List workspaces

# Helm operations
helm list                     # List installed releases
helm status <release>         # Show release status
helm history <release>        # Show release history
helm get values <release>     # Show release values
```

## Requirements

- `PROJECT_NAME` environment variable must be set
- Project must be mounted to `/src/$PROJECT_NAME`
- AWS credentials required for AWS operations
- Kubernetes config required for cluster operations

The container validates the PROJECT_NAME requirement and provides clear error messages if not met. AWS and Kubernetes access are optional but required for cloud operations.