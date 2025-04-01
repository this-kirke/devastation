# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.config/zsh/ohmyzsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'
export VISUAL='nvim'

# Aliases
alias vim='nvim'
alias vi='nvim'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Fix for keys in tmux
bindkey -e
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char

# Enable history search
bindkey '^R' history-incremental-search-backward

# Set PATH
# Keep this in your .zshrc if you want specific path modifications
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/.npmrc"
export PATH="$HOME/.config/npm/global/bin:$PATH"

# Source Powerlevel10k config

[[ -f ${ZDOTDIR}/p10k.zsh ]] && source ${ZDOTDIR}/p10k.zsh
