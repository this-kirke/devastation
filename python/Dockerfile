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
    python3-poetry \
    python3-pytest \
    && rm -rf /var/lib/apt/lists/*

# Install Python tools not available via apt
RUN pip3 install --no-cache-dir --no-input \
    debugpy \
    python-lsp-server[all]

# Create symbolic links to make python3 point to the specified version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
# Ensure poetry is on PATH by creating a symlink to the apt-installed version
RUN ln -sf /usr/bin/poetry /usr/local/bin/poetry

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
# (Using wrapper modules to load both base and Python-specific configs)
RUN nvim --headless "+TSInstall python" +qa

ENTRYPOINT ["/usr/local/bin/python-entrypoint.sh"]

