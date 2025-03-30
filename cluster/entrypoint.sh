#!/bin/bash

# Get the current username using whoami
USERNAME=$(whoami)
echo "Running as user: $USERNAME"

# Check if the project directory exists
PROJECT_DIR="/home/$USERNAME/project"
if [ -d "/project" ]; then
    # If /project is mounted, use that
    PROJECT_DIR="/project"
fi
echo "Using project directory: $PROJECT_DIR"

# Start tmux session with one window
tmux new-session -d -s dev -c "$PROJECT_DIR" -n "cluster"

# Create a second window with nvim
tmux new-window -t dev:2 -c "$PROJECT_DIR" -n "editor"
tmux send-keys -t dev:2 "nvim" C-m

# Create a third window for AWS CLI
tmux new-window -t dev:3 -c "$PROJECT_DIR" -n "aws"
tmux send-keys -t dev:3 "aws --version" C-m

# Create a fourth window for Terraform
tmux new-window -t dev:4 -c "$PROJECT_DIR" -n "terraform"
tmux send-keys -t dev:4 "terraform -version" C-m

# Create a fifth window for kubectl
tmux new-window -t dev:5 -c "$PROJECT_DIR" -n "kubectl"
tmux send-keys -t dev:5 "kubectl version --client" C-m

# Select first window
tmux select-window -t dev:1

# Attach to the session
exec tmux attach-session -t dev