# Cluster Devastation Container

## Purpose

Extends the base devastation with cloud infrastructure and Kubernetes management tools, providing a comprehensive environment for DevOps, infrastructure as code, and container orchestration workflows.

## Cloud and Infrastructure Tools

### AWS CLI v2
- **Complete AWS Integration**: All AWS services accessible via CLI
- **Configuration**: Supports profiles, SSO, and credential management
- **Extensions**: AWS CDK, SAM CLI for advanced workflows

### Kubernetes Tools
- **kubectl**: Kubernetes command-line interface for cluster management
- **Helm**: Package manager for Kubernetes applications
- **Cluster Context Management**: Switch between multiple clusters seamlessly

### Infrastructure as Code
- **Terraform**: HashiCorp's infrastructure automation tool
- **terraform-ls**: Language server for HCL syntax support
- **Plugin Caching**: Optimized for faster provider downloads

## Neovim Extensions

### Language Server Configuration
**File**: `config/lsp-cluster.lua`

```lua
-- Multi-language LSP setup for infrastructure
local lspconfig = require('lspconfig')

-- YAML LSP with Kubernetes schema validation
lspconfig.yamlls.setup {
  settings = {
    yaml = {
      kubernetes = "1.25.0",
      schemas = {
        ["https://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["https://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
        ["https://raw.githubusercontent.com/docker/compose/master/compose/config/config_schema_v3.9.json"] = "docker-compose*.{yml,yaml}",
      },
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
    }
  }
}

-- Terraform LSP
lspconfig.terraformls.setup {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "tf" },
  root_dir = lspconfig.util.root_pattern(".terraform", ".git"),
}

-- Bash LSP for scripts
lspconfig.bashls.setup {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
}
```

### Treesitter Configuration
**File**: `config/treesitter-cluster.lua`

```lua
-- Infrastructure-focused Treesitter setup
require('nvim-treesitter.configs').setup {
  ensure_installed = { 
    "terraform", 
    "hcl", 
    "yaml", 
    "json", 
    "bash", 
    "dockerfile" 
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  fold = {
    enable = true
  }
}
```

## Dockerfile Implementation

### Extension Pattern
```dockerfile
FROM devastation/base:latest

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get install helm && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install terraform && \
    rm -rf /var/lib/apt/lists/*

# Install language servers
RUN npm install -g yaml-language-server bash-language-server && \
    terraform-ls --version

# Copy cluster-specific Neovim configurations
COPY ./.config /home/$USERNAME/.config/

# Apply cluster-specific Neovim configurations
RUN echo '\n-- Cluster-specific configurations\nrequire("config.lsp-cluster")\nrequire("config.treesitter-cluster")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua

# Install Treesitter parsers
RUN nvim --headless "+TSInstall terraform hcl yaml json bash dockerfile" +qa

ENTRYPOINT ["/usr/local/bin/cluster-entrypoint.sh"]
```

## tmux Window Layout

### Window Configuration
1. **cluster**: Main infrastructure operations shell
2. **editor**: Neovim with YAML/HCL/Bash LSP active
3. **aws**: AWS CLI operations and resource management
4. **terraform**: Infrastructure as Code development
5. **kubectl**: Kubernetes cluster management
6. **claude**: Claude Code assistant

### Entrypoint Implementation
**File**: `cluster-entrypoint.sh`

```bash
#!/bin/bash

# Validate environment (inherited from base pattern)
if [ -z "$PROJECT_NAME" ]; then
    echo "ERROR: PROJECT_NAME environment variable is not set"
    exit 1
fi

PROJECT_DIR="/src/$PROJECT_NAME"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERROR: Project directory $PROJECT_DIR does not exist"
    exit 1
fi

# Start tmux session with cluster-specific windows
tmux new-session -d -s dev -c "$PROJECT_DIR" -n "cluster"

tmux new-window -t dev:2 -c "$PROJECT_DIR" -n "editor"
tmux send-keys -t dev:2 "nvim" C-m

tmux new-window -t dev:3 -c "$PROJECT_DIR" -n "aws"
tmux send-keys -t dev:3 "aws --version" C-m

tmux new-window -t dev:4 -c "$PROJECT_DIR" -n "terraform"
tmux send-keys -t dev:4 "terraform -version" C-m

tmux new-window -t dev:5 -c "$PROJECT_DIR" -n "kubectl"
tmux send-keys -t dev:5 "kubectl version --client" C-m

tmux new-window -t dev:6 -c "$PROJECT_DIR" -n "claude"
tmux send-keys -t dev:6 "claude" C-m

tmux select-window -t dev:1
exec tmux attach-session -t dev
```

## AWS Workflow

### Configuration Management
```bash
# Configure AWS credentials
aws configure                    # Interactive setup
aws configure --profile dev      # Named profile setup
aws sso configure               # AWS SSO setup

# Environment-based configuration
export AWS_PROFILE=dev
export AWS_REGION=us-west-2
export AWS_DEFAULT_REGION=us-west-2
```

### Common AWS Operations
```bash
# EC2 operations
aws ec2 describe-instances
aws ec2 start-instances --instance-ids i-1234567890abcdef0
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# S3 operations
aws s3 ls
aws s3 cp file.txt s3://my-bucket/
aws s3 sync ./directory/ s3://my-bucket/prefix/

# EKS cluster management
aws eks list-clusters
aws eks update-kubeconfig --name my-cluster --region us-west-2
```

## Kubernetes Workflow

### Cluster Context Management
```bash
# View current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch context
kubectl config use-context my-cluster

# View cluster information
kubectl cluster-info
kubectl get nodes
```

### Resource Management
```bash
# Namespace operations
kubectl get namespaces
kubectl create namespace my-namespace
kubectl config set-context --current --namespace=my-namespace

# Pod management
kubectl get pods
kubectl describe pod my-pod
kubectl logs my-pod -f
kubectl exec -it my-pod -- /bin/bash

# Service and deployment operations
kubectl get services
kubectl get deployments
kubectl apply -f deployment.yaml
kubectl delete -f deployment.yaml
```

### Helm Package Management
```bash
# Add repositories
helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install charts
helm install my-release bitnami/wordpress
helm upgrade my-release bitnami/wordpress
helm uninstall my-release

# Chart development
helm create my-chart
helm template my-chart
helm package my-chart
```

## Terraform Workflow

### Project Initialization
```bash
# Initialize Terraform project
terraform init

# Validate configuration
terraform validate

# Plan infrastructure changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy
```

### State Management
```bash
# Show current state
terraform show

# List resources in state
terraform state list

# Import existing resources
terraform import aws_instance.example i-1234567890abcdef0

# Remote state configuration
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "infrastructure/terraform.tfstate"
    region = "us-west-2"
  }
}
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

## LSP Features for Infrastructure

### YAML Intelligence
- **Kubernetes Resource Validation**: Schema-based validation for K8s manifests
- **Helm Chart Support**: Template syntax highlighting and validation
- **Docker Compose**: Schema validation for compose files
- **GitHub Actions**: Workflow file validation

### Terraform Intelligence
- **Resource Completion**: Auto-complete for resource types and arguments
- **Provider Documentation**: Inline documentation for resources
- **Variable References**: Navigate between variable definitions and usage
- **Module Support**: IntelliSense for module inputs and outputs

### Bash Script Support
- **Syntax Checking**: Real-time validation of shell scripts
- **Command Completion**: Built-in command suggestions
- **Variable Tracking**: Track variable usage across scripts

## Container Usage Patterns

### Basic Infrastructure Development
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
  -v ~/.config/claude:/home/dev/.config/claude \
  -v ~/.config/git:/home/dev/.config/git \
  -v ~/.aws:/home/dev/.aws \
  -v ~/.kube:/home/dev/.kube \
  -v ~/.ssh:/home/dev/.ssh \
  -w /src/MyInfraProject \
  -e PROJECT_NAME=MyInfraProject \
  devastation/cluster:latest
```

## Security Considerations

### Credential Management
- **AWS Credentials**: Mount `~/.aws` for persistent configuration
- **Kubernetes Config**: Mount `~/.kube` for cluster access
- **SSH Keys**: Mount `~/.ssh` for Git operations and server access
- **Environment Variables**: Use for temporary credentials

### Best Practices
- Use IAM roles when running in cloud environments
- Rotate credentials regularly
- Use least-privilege access principles
- Store sensitive values in parameter stores or secret managers

## Project Structure Examples

### Terraform Project
```
infrastructure/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/
│   ├── vpc/
│   ├── security-groups/
│   └── ecs-cluster/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

### Kubernetes Project
```
k8s-manifests/
├── namespaces/
├── deployments/
├── services/
├── ingress/
├── configmaps/
├── secrets/
└── helm-charts/
    └── my-app/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
```

### Multi-Cloud Project
```
infrastructure/
├── aws/
│   ├── terraform/
│   └── cloudformation/
├── azure/
│   ├── terraform/
│   └── arm-templates/
├── kubernetes/
│   ├── manifests/
│   └── helm-charts/
└── scripts/
    ├── deploy.sh
    └── cleanup.sh
```