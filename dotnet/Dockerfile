FROM devastation/base:latest

LABEL maintainer="Devastation"
LABEL description=".NET development environment with Neovim, LSP, and debugging support"

# Build arguments
ARG USERNAME=dev
ARG DOTNET_VERSION=9.0
ARG DOTNET_SDK_VERSION=${DOTNET_VERSION}.3

# Environment variables
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_NOLOGO=true
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
ENV NUGET_XMLDOC_MODE=skip

###################
# ROOT OPERATIONS
###################

USER root

# Install .NET SDK dependencies and tools
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    libicu-dev \
    libssl-dev \
    zlib1g \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN DOTNET_JSON_URL="https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/${DOTNET_VERSION}/releases.json" && \
    echo "Downloading from metadata URL: $DOTNET_JSON_URL" && \
    curl -s $DOTNET_JSON_URL > dotnet-releases.json && \
    SDK_DOWNLOAD_URL=$(jq -r '.releases[0].sdk.files[] | select(.rid=="linux-x64") | .url' dotnet-releases.json) && \
    echo "Using SDK download URL: $SDK_DOWNLOAD_URL" && \
    mkdir -p /usr/share/dotnet && \
    curl -SL "$SDK_DOWNLOAD_URL" -o dotnet-sdk.tar.gz && \
    tar -xzf dotnet-sdk.tar.gz -C /usr/share/dotnet && \
    rm dotnet-sdk.tar.gz dotnet-releases.json && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

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

# Install global .NET tools
RUN dotnet tool install --global Reqnroll.Tools.CLI

WORKDIR /home/$USERNAME/project
ENTRYPOINT ["/usr/local/bin/dotnet-entrypoint.sh"]