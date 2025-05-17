FROM devastation/base:latest

LABEL maintainer="Devastation"
LABEL description=".NET development environment with Neovim, LSP, and debugging support"

# Build arguments
ARG USERNAME=dev

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

# Install .NET 8 SDK
RUN DOTNET8_VERSION=8.0 && \
    DOTNET8_JSON_URL="https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/${DOTNET8_VERSION}/releases.json" && \
    echo "Downloading from metadata URL: $DOTNET8_JSON_URL" && \
    curl -s $DOTNET8_JSON_URL > dotnet8-releases.json && \
    SDK8_DOWNLOAD_URL=$(jq -r '.releases[0].sdk.files[] | select(.rid=="linux-x64") | .url' dotnet8-releases.json) && \
    echo "Using .NET 8 SDK download URL: $SDK8_DOWNLOAD_URL" && \
    mkdir -p /usr/share/dotnet && \
    curl -SL "$SDK8_DOWNLOAD_URL" -o dotnet8-sdk.tar.gz && \
    tar -xzf dotnet8-sdk.tar.gz -C /usr/share/dotnet && \
    rm dotnet8-sdk.tar.gz dotnet8-releases.json && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install .NET 9 SDK
RUN DOTNET9_VERSION=9.0 && \
    DOTNET9_JSON_URL="https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/${DOTNET9_VERSION}/releases.json" && \
    echo "Downloading from metadata URL: $DOTNET9_JSON_URL" && \
    curl -s $DOTNET9_JSON_URL > dotnet9-releases.json && \
    SDK9_DOWNLOAD_URL=$(jq -r '.releases[0].sdk.files[] | select(.rid=="linux-x64") | .url' dotnet9-releases.json) && \
    echo "Using .NET 9 SDK download URL: $SDK9_DOWNLOAD_URL" && \
    curl -SL "$SDK9_DOWNLOAD_URL" -o dotnet9-sdk.tar.gz && \
    tar -xzf dotnet9-sdk.tar.gz -C /usr/share/dotnet && \
    rm dotnet9-sdk.tar.gz dotnet9-releases.json

# Add .NET specific entrypoint script
COPY ./entrypoint.sh /usr/local/bin/dotnet-entrypoint.sh
RUN chmod +x /usr/local/bin/dotnet-entrypoint.sh

###################
# USER CONFIGURATION
###################

# Switch to non-root user for all configuration
USER $USERNAME

# Copy the configuration directory 
COPY --chown=$USERNAME:$USERNAME .config /home/$USERNAME/.config

# Install Treesitter parser for C#
RUN nvim --headless "+TSInstall c_sharp" +qa

ENTRYPOINT ["/usr/local/bin/dotnet-entrypoint.sh"]
