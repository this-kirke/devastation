FROM ubuntu:22.04

LABEL maintainer="Devastation"
LABEL description="Base development environment with Neovim, tmux, and zsh"

###################
# ENV VARS & ARGS
###################

# Build arguments
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TERM=xterm-256color
# Set zsh to look for dotfiles in ~/.config/zsh instead of home directory
ENV ZDOTDIR=/home/$USERNAME/.config/zsh

ENV CLAUDE_CONFIG_DIR=/home/$USERNAME/.config/claude

###################
# SYSTEM SETUP
###################

# Install essential packages only
RUN apt-get update && apt-get install -y \
    curl \
    fd-find \
    fontconfig \
    gcc \
    git \
    locales \
    make \
    ripgrep \
    sudo \
    tree \
    tmux \
    unzip \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install Meslo Nerd Font
RUN mkdir -p /usr/share/fonts/truetype/meslo-nerd-font \
    && curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip -o /tmp/Meslo.zip \
    && unzip -o /tmp/Meslo.zip -d /usr/share/fonts/truetype/meslo-nerd-font \
    && rm /tmp/Meslo.zip \
    && fc-cache -fv

# Install Neovim
RUN curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz \
    && tar -xzf /tmp/nvim.tar.gz -C /opt \
    && ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
    && rm /tmp/nvim.tar.gz

# Add entrypoint script
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

###################
# USER CREATION
###################

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chsh -s $(which zsh) $USERNAME

###################
# USER CONFIGURATION
###################

# Switch to non-root user for all configuration
USER $USERNAME

# Install Oh My Zsh and plugins to XDG location
RUN mkdir -p $ZDOTDIR

# Configure npm to use XDG directories
ENV NPM_CONFIG_USERCONFIG=/home/$USERNAME/.config/npm/npmrc
ENV NPM_CONFIG_CACHE=/home/$USERNAME/.config/npm/cache
ENV NPM_CONFIG_PREFIX=/home/$USERNAME/.config/npm/global
ENV NPM_CONFIG_INIT_MODULE=/home/$USERNAME/.config/npm/config/npm-init.js

RUN npm install -g "@anthropic-ai/claude-code"

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \ 
	&& git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZDOTDIR/ohmyzsh/custom/themes/powerlevel10k \
	&& git clone https://github.com/zsh-users/zsh-autosuggestions $ZDOTDIR/ohmyzsh/custom/plugins/zsh-autosuggestions \
	&& git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZDOTDIR/ohmyzsh/custom/plugins/zsh-syntax-highlighting


###################
# COPY CONFIG FILES
###################

# Copy all configuration files at once
COPY --chown=$USERNAME:$USERNAME ./.config /home/$USERNAME/.config/

# Initialize Neovim plugins headlessly
RUN nvim --headless "+Lazy! sync" +qa && \
    nvim --headless "+TSUpdateSync" +qa

WORKDIR /home/$USERNAME/project
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

