#!/bin/bash

# Setup script to create symlinks for dotfiles

set -ex

DOTFILES_DIR="$HOME/ghq/github.com/shoppingjaws/dotfiles"
TARGET_DIR="$HOME"
XDG_CONFIG_HOME=$HOME/.config
mkdir -p "$XDG_CONFIG_HOME"

echo "Setting up dotfiles symlinks..."

# Function to create symlinks for all files in a directory
create_symlinks() {
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
ln -sf "$DOTFILES_DIR/fish/config.fish" "$TARGET_DIR/.config/fish/config.fish"
create_symlinks "$DOTFILES_DIR/fish/conf.d" "$TARGET_DIR/.config/fish/conf.d"

# wezterm
ln -sf "$DOTFILES_DIR/wezterm/.wezterm.lua" "$TARGET_DIR/.wezterm.lua"
ln -sf "$DOTFILES_DIR/wezterm/keybinds.lua" "$TARGET_DIR/.config/wezterm/keybinds.lua"

# claude
create_symlinks "$DOTFILES_DIR/claude" "$TARGET_DIR/.claude"

# aqua
ln -sf "$DOTFILES_DIR/aqua/aqua.yaml" "$TARGET_DIR/.config/aquaproj-aqua/aqua.yaml"

# hammerspoon
ln -sf "$DOTFILES_DIR/hammerspoon/init.lua" "$TARGET_DIR/.hammerspoon/init.lua"

echo "Setup complete!"