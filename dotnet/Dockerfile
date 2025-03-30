FROM devastation/base:latest

LABEL maintainer="Devastation"
LABEL description=".NET development environment with Neovim, LSP, and debugging support"

# Build arguments
ARG USERNAME=dev
ARG DOTNET_VERSION=8.0
ARG DOTNET_SDK_VERSION=${DOTNET_VERSION}.100

# Environment variables
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_NOLOGO=true
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
ENV NUGET_XMLDOC_MODE=skip

###################
# ROOT OPERATIONS
###################

USER root

# Install .NET SDK dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    libicu-dev \
    libssl-dev \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN curl -sSL https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh | bash -s -- --version ${DOTNET_SDK_VERSION} --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install Azure Artifacts Credential Provider
RUN curl -sSL https://aka.ms/install-artifacts-credprovider.sh | bash

# Add .NET specific entrypoint script
COPY ./entrypoint.sh /usr/local/bin/dotnet-entrypoint.sh
RUN chmod +x /usr/local/bin/dotnet-entrypoint.sh

###################
# USER CONFIGURATION
###################

# Switch to non-root user for all configuration
USER $USERNAME

# Copy .NET-specific Neovim configuration
COPY --chown=$USERNAME:$USERNAME ./config/nvim /home/$USERNAME/.config/nvim/

# Install Treesitter parser for C#
RUN nvim --headless "+TSInstall c_sharp" +qa

WORKDIR /home/$USERNAME/project
ENTRYPOINT ["/usr/local/bin/dotnet-entrypoint.sh"]