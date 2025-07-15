#!/bin/bash

# Setup script to create symlinks for dotfiles

set -ex

DOTFILES_DIR="$HOME/ghq/github.com/shoppingjaws/dotfiles"
TARGET_DIR="$HOME"
XDG_CONFIG_HOME=$HOME/.config
mkdir -p "$XDG_CONFIG_HOME"

echo "Setting up dotfiles symlinks..."

# Function to create symlink with directory creation
link() {
    local source="$1"
    local target="$2"
    local target_dir=$(dirname "$target")
    mkdir -p "$target_dir"
    ln -sf "$source" "$target"
    echo "Created symlink: $target -> $source"
}

# Function to create symlinks for all files in a directory
link_dir() {
    local source_dir="$1"
    local target_dir="$2"
    local pattern="${3:-*}"  # Default to all files if no pattern specified
    if [ -d "$source_dir" ]; then
        mkdir -p "$target_dir"
        
        # Remove existing symlinks that match the pattern
        if [ -d "$target_dir" ]; then
            for link in "$target_dir"/$pattern; do
                if [ -L "$link" ]; then
                    rm -f "$link"
                    echo "Removed existing symlink: $link"
                fi
            done
        fi
        
        # Create new symlinks
        for file in "$source_dir"/$pattern; do
            if [ -f "$file" ]; then
                local filename=$(basename "$file")
                ln -sf "$file" "$target_dir/$filename"
                echo "Created symlink: $target_dir/$filename -> $file"
            fi
        done
    else
        echo "Source directory does not exist: $source_dir"
    fi
}


# fish
link "$DOTFILES_DIR/fish/config.fish" "$TARGET_DIR/.config/fish/config.fish"
link_dir "$DOTFILES_DIR/fish/conf.d" "$TARGET_DIR/.config/fish/conf.d" "*.fish"
link_dir "$DOTFILES_DIR/fish/functions" "$TARGET_DIR/.config/fish/functions" "*.fish"

# wezterm
link_dir "$DOTFILES_DIR/wezterm" "$TARGET_DIR/.config/wezterm/"

# claude
link_dir "$DOTFILES_DIR/claude" "$TARGET_DIR/.claude"
link_dir "$DOTFILES_DIR/claude/commands" "$TARGET_DIR/.claude/commands" "*.md"

# hammerspoon
link "$DOTFILES_DIR/hammerspoon/init.lua" "$TARGET_DIR/.hammerspoon/init.lua"

# mise
link "$DOTFILES_DIR/mise/config.toml" "$TARGET_DIR/.config/mise/config.toml"


echo "Setup complete!"