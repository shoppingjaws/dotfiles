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
    if [ -d "$source_dir" ]; then
        mkdir -p "$target_dir"
        for file in "$source_dir"/*; do
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
link "$DOTFILES_DIR/fish/common.fish" "$TARGET_DIR/.config/fish/common.fish"
link_dir "$DOTFILES_DIR/fish/conf.d" "$TARGET_DIR/.config/fish/conf.d"
link_dir "$DOTFILES_DIR/fish/functions" "$TARGET_DIR/.config/fish/functions"

# wezterm
link "$DOTFILES_DIR/wezterm/.wezterm.lua" "$TARGET_DIR/.wezterm.lua"
link "$DOTFILES_DIR/wezterm/keybinds.lua" "$TARGET_DIR/.config/wezterm/keybinds.lua"
link "$DOTFILES_DIR/wezterm/Brogrammer.toml" "$TARGET_DIR/.config/wezterm/colors/Brogrammer.toml"

# claude
link_dir "$DOTFILES_DIR/claude" "$TARGET_DIR/.claude"

# aqua
link "$DOTFILES_DIR/aqua/aqua.yaml" "$TARGET_DIR/.config/aquaproj-aqua/aqua.yaml"

# hammerspoon
link "$DOTFILES_DIR/hammerspoon/init.lua" "$TARGET_DIR/.hammerspoon/init.lua"

echo "Setup complete!"