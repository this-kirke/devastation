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
tmux new-session -d -s dev -c "$PROJECT_DIR" -n "dotnet"

# Create a second window with nvim
tmux new-window -t dev:2 -c "$PROJECT_DIR" -n "editor"
tmux send-keys -t dev:2 "nvim" C-m

# Create a third window for testing
tmux new-window -t dev:3 -c "$PROJECT_DIR" -n "test"
tmux send-keys -t dev:3 "echo 'Ready for dotnet test'" C-m

# Create a fourth window for claude
tmux new-window -t dev:4 -c "$PROJECT_DIR" -n "claude"
tmux send-keys -t dev:4 "claude" C-m

# Select first window
tmux select-window -t dev:1

# Attach to the session
exec tmux attach-session -t dev
