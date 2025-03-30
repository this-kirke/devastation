# Cluster Devastation

This devastation extends the base Devastation environment with Kubernetes cluster management tools, providing a powerful environment for managing infrastructure as code with Terraform, AWS, and Kubernetes.

## Features

- AWS CLI v2 for AWS resource management
- kubectl for Kubernetes cluster management
- Terraform for infrastructure as code
- Helm for Kubernetes package management
- Neovim with specific configurations:
  - YAML LSP with Kubernetes schema validation
  - Terraform LSP for HCL files
  - Bash LSP for scripting
  - Treesitter for syntax highlighting and code navigation

## Usage

### Building the Devastation

From the project root directory:

```bash
# Build with default settings
docker buildx build -t devastation/cluster:latest ./cluster

# Or build with your current username
docker buildx build --build-arg USERNAME=$(whoami) -t devastation/cluster:latest ./cluster
```

### Running the Devastation

```bash
docker run -it --rm \
  -v ~/.aws:/home/dev/.aws \
  -v ~/.kube:/home/dev/.kube \
  -v $(pwd):/project \
  devastation/cluster:latest
```

## Neovim Configuration

### LSP Features

- YAML validation with Kubernetes schemas
- Terraform HCL syntax checking and autocompletion
- Bash script linting

### Environment Structure

The devastation includes multiple tmux windows for different aspects of cluster management:

1. Main shell
2. Editor (Neovim)
3. AWS CLI
4. Terraform
5. kubectl

## AWS Configuration

The container expects AWS credentials to be mounted from the host system. You can configure AWS credentials by:

1. Mounting your local ~/.aws directory
2. Setting AWS environment variables in the docker run command
3. Using AWS IAM roles when running in cloud environments

## Terraform Usage

Terraform is configured with a plugin cache directory to improve performance. 

The container includes:
- Terraform CLI
- terraform-ls language server

## Kubectl and Kubernetes

For connecting to Kubernetes clusters:

1. Mount your kube config from ~/.kube
2. Use aws eks update-kubeconfig to generate configs for EKS clusters
3. Use kubectl contexts to switch between clusters

## Customization

To further customize this devastation:

1. Add additional tools to the Dockerfile
2. Modify the LSP configuration in `config/nvim/lua/config/lsp.lua`
3. Extend Treesitter functionality in `config/nvim/lua/config/treesitter.lua`