FROM devastation/base:latest

LABEL maintainer="Devastation"
LABEL description="Kubernetes cluster management environment with AWS CLI, kubectl, and Terraform"

# Build arguments
ARG USERNAME=dev
ARG KUBECTL_VERSION=1.28.4
ARG TERRAFORM_VERSION=1.5.7
ARG AWS_CLI_VERSION=2.13.25

# Environment variables for AWS CLI and Terraform
ENV AWS_PAGER=""
ENV TF_PLUGIN_CACHE_DIR=/home/$USERNAME/.terraform.d/plugin-cache

###################
# ROOT OPERATIONS
###################

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    jq \
    less \
    lsb-release \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install Terraform
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add cluster-specific entrypoint script
COPY ./entrypoint.sh /usr/local/bin/cluster-entrypoint.sh
RUN chmod +x /usr/local/bin/cluster-entrypoint.sh

###################
# USER CONFIGURATION
###################

# Switch to non-root user for all configuration
USER $USERNAME

# Create directory for Terraform plugin cache
RUN mkdir -p /home/$USERNAME/.terraform.d/plugin-cache

# Copy cluster-specific configuration
COPY ./.config /home/$USERNAME/.config/

# Apply cluster-specific Neovim configurations
RUN echo '\n-- Cluster-specific configurations\nrequire("config.lsp-cluster")\nrequire("config.treesitter-cluster")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua && \
    nvim --headless "+TSInstall terraform hcl yaml json bash" +qa

ENTRYPOINT ["/usr/local/bin/cluster-entrypoint.sh"]