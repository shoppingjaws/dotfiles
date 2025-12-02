#!/bin/bash

# Setup script to create symlinks for dotfiles
set +e  # Disable exit on error for these commands

DOTFILES_DIR="$HOME/ghq/github.com/shoppingjaws/dotfiles"
TARGET_DIR="$HOME"
XDG_CONFIG_HOME=$HOME/.config
mkdir -p "$XDG_CONFIG_HOME"

echo "Setting up dotfiles symlinks..."
# Function to sync directory with .dotignore support

# fish - use hard links to avoid circular reference issues
bun "$DOTFILES_DIR"/tools/hardlink-sync.ts "$DOTFILES_DIR/fish" "$TARGET_DIR/.config/fish" --force

# wezterm - use hard links
bun "$DOTFILES_DIR"/tools/hardlink-sync.ts "$DOTFILES_DIR/wezterm" "$TARGET_DIR/.config/wezterm" --force

# claude - use hard links
bun "$DOTFILES_DIR"/tools/hardlink-sync.ts "$DOTFILES_DIR/claude" "$TARGET_DIR/.claude" --force

# aqua - use hard links
bun "$DOTFILES_DIR"/tools/hardlink-sync.ts "$DOTFILES_DIR/aqua" "$TARGET_DIR/.config/aqua" --force

# mise - use hard links
bun "$DOTFILES_DIR"/tools/hardlink-sync.ts "$DOTFILES_DIR/mise" "$TARGET_DIR/.config/mise" --force

# tools - use hard links
bun "$DOTFILES_DIR"/tools/hardlink-sync.ts "$DOTFILES_DIR/tools" "$TARGET_DIR/.config/tools" --force
# nvim - use hard links
bun "$DOTFILES_DIR"/tools/hardlink-sync.ts "$DOTFILES_DIR/nvim" "$TARGET_DIR/.config/nvim" --force

bun "$DOTFILES_DIR"/tools/hardlink-sync.ts "$DOTFILES_DIR/safe-command" "$TARGET_DIR/.config/safe-command" --force

# karabiner
bun run "$DOTFILES_DIR"/karabiner/karabiner.ts

# claude code mcp
claude mcp add -s user terraform -- docker run -i --rm hashicorp/terraform-mcp-server
claude mcp add -s user aws-documentation -- awslabs.aws-documentation-mcp-server
claude mcp add -s user --transport http notion https://mcp.notion.com/mcp
claude mcp add -s user container-use -- container-use stdio

# homebrew
if [[ "$(uname)" == "Darwin" ]]; then
  brew bundle --file="brew/Brewfile"
fi

sh "$DOTFILES_DIR/npm/opencommit/setup.sh"

echo "Setup complete!"