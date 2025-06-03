FROM devastation/base:latest

LABEL maintainer="Devastation"
LABEL description="Python development environment with Neovim, LSP, and debugging support"

# Build arguments
ARG USERNAME=dev
ARG PYTHON_VERSION=3.11

# Environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

###################
# ROOT OPERATIONS
###################

USER root

# Install Python development tools
RUN apt-get update && apt-get install -y \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python${PYTHON_VERSION}-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create symbolic links to make python3 point to the specified version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1

# Install Python tools
RUN pip3 install --no-cache-dir \
    debugpy \
    poetry \
    pytest \
    python-lsp-server[all]

# Add Python-specific entrypoint script
COPY ./entrypoint.sh /usr/local/bin/python-entrypoint.sh
RUN chmod +x /usr/local/bin/python-entrypoint.sh

###################
# USER CONFIGURATION
###################

# Switch to non-root user for all configuration
USER $USERNAME

# Copy Python-specific configuration
COPY ./.config /home/$USERNAME/.config/

# Apply Python-specific Neovim configurations
RUN echo '\n-- Python-specific configurations\nrequire("config.lsp-python")\nrequire("config.dap-python")\nrequire("config.treesitter-python")' >> /home/$USERNAME/.config/nvim/lua/plugins.lua && \
    nvim --headless "+TSInstall python" +qa

ENTRYPOINT ["/usr/local/bin/python-entrypoint.sh"]