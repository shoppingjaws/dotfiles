#!/bin/bash

# Setup script to create symlinks for dotfiles

set -ex

DOTFILES_DIR="$HOME/ghq/github.com/shoppingjaws/dotfiles"
TARGET_DIR="$HOME"
XDG_CONFIG_HOME=$HOME/.config
mkdir -p "$XDG_CONFIG_HOME"

echo "Setting up dotfiles symlinks..."
# Function to sync directory with .dotignore support


# fish
sync_with_ignore "$DOTFILES_DIR/fish" "$TARGET_DIR/.config/fish"

# wezterm
sync_with_ignore "$DOTFILES_DIR/wezterm" "$TARGET_DIR/.config/wezterm"

# claude - sync all files with .dotignore support
sync_with_ignore "$DOTFILES_DIR/claude" "$TARGET_DIR/.claude"

# aqua
sync_with_ignore "$DOTFILES_DIR/aqua" "$TARGET_DIR/.config/aqua"

# mise
sync_with_ignore "$DOTFILES_DIR/mise" "$TARGET_DIR/.config/mise"

# tools
sync_with_ignore "$DOTFILES_DIR/tools" "$TARGET_DIR/.config/tools"
# nvim
sync_with_ignore "$DOTFILES_DIR/nvim" "$TARGET_DIR/.config/nvim"

# karabiner
bun run karabiner/karabiner.ts

# claude code mcp
claude mcp add -s user terraform -- docker run -i --rm hashicorp/terraform-mcp-server
claude mcp add -s user aws-documentation -- awslabs.aws-documentation-mcp-server

echo "Setup complete!"