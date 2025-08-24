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
            # Handle both regular and hidden files
            shopt -s nullglob dotglob
            for link in "$target_dir"/$pattern "$target_dir"/.$pattern; do
                if [ -L "$link" ]; then
                    rm -f "$link"
                    echo "Removed existing symlink: $link"
                fi
            done
            shopt -u nullglob dotglob
        fi
        
        # Create new symlinks
        # Enable dotglob to include hidden files
        shopt -s nullglob dotglob
        for item in "$source_dir"/$pattern; do
            if [ -f "$item" ] || [ -d "$item" ]; then
                local itemname=$(basename "$item")
                ln -sf "$item" "$target_dir/$itemname"
                echo "Created symlink: $target_dir/$itemname -> $item"
            fi
        done
        shopt -u nullglob dotglob
    else
        echo "Source directory does not exist: $source_dir"
    fi
}

# Function to sync directory with .dotignore support
sync_with_ignore() {
    local source_dir="$1"
    local target_dir="$2"
    local dotignore_file="$source_dir/.dotignore"
    
    if [ ! -d "$source_dir" ]; then
        echo "Source directory does not exist: $source_dir"
        return 1
    fi
    
    mkdir -p "$target_dir"
    
    # Read ignore patterns if .dotignore exists
    local ignore_patterns=()
    if [ -f "$dotignore_file" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            # Skip empty lines and comments
            if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
                # Remove leading/trailing whitespace
                line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                if [ -n "$line" ]; then
                    ignore_patterns+=("$line")
                fi
            fi
        done < "$dotignore_file"
    fi
    
    # Function to check if item should be ignored
    should_ignore() {
        local item="$1"
        local item_name=$(basename "$item")
        
        for pattern in "${ignore_patterns[@]}"; do
            # Check if pattern matches the basename
            if [[ "$item_name" == $pattern ]] || [[ "$item_name/" == $pattern ]]; then
                return 0
            fi
            # Check glob patterns
            if [[ "$item_name" == $pattern ]] || [[ "$(basename "$item")/" == $pattern ]]; then
                return 0
            fi
            # Check if item matches pattern with wildcards
            case "$item_name" in
                $pattern) return 0 ;;
            esac
        done
        return 1
    }
    
    # Remove existing symlinks that might be outdated
    if [ -d "$target_dir" ]; then
        shopt -s nullglob dotglob
        for link in "$target_dir"/*; do
            if [ -L "$link" ]; then
                local link_target=$(readlink "$link")
                # Remove if it points to our source directory
                if [[ "$link_target" == "$source_dir"/* ]]; then
                    rm -f "$link"
                    echo "Removed existing symlink: $link"
                fi
            fi
        done
        shopt -u nullglob dotglob
    fi
    # Create symlinks for non-ignored items
    shopt -s nullglob dotglob
    for item in "$source_dir"/*; do
        local item_name=$(basename "$item")
        # Skip .dotignore file itself
        if [ "$item_name" = ".dotignore" ]; then
            continue
        fi
        # Check if item should be ignored
        if should_ignore "$item"; then
            echo "Ignoring: $item_name"
            continue
        fi
        
        # If item is a directory, recursively sync its contents
        if [ -d "$item" ]; then
            echo "Syncing directory contents: $item_name"
            mkdir -p "$target_dir/$item_name"
            # Recursively sync directory contents
            shopt -s nullglob dotglob
            for subitem in "$item"/*; do
                if [ -e "$subitem" ]; then
                    local subitem_name=$(basename "$subitem")
                    ln -sf "$subitem" "$target_dir/$item_name/$subitem_name"
                    echo "Created symlink: $target_dir/$item_name/$subitem_name -> $subitem"
                fi
            done
            shopt -u nullglob dotglob
        else
            # Create symlink for files
            ln -sf "$item" "$target_dir/$item_name"
            echo "Created symlink: $target_dir/$item_name -> $item"
        fi
    done
    shopt -u nullglob dotglob
}


# fish
link "$DOTFILES_DIR/fish/config.fish" "$TARGET_DIR/.config/fish/config.fish"
link_dir "$DOTFILES_DIR/fish/conf.d" "$TARGET_DIR/.config/fish/conf.d" "*.fish"
link_dir "$DOTFILES_DIR/fish/functions" "$TARGET_DIR/.config/fish/functions" "*.fish"

# wezterm
link_dir "$DOTFILES_DIR/wezterm" "$TARGET_DIR/.config/wezterm/"

# claude - sync all files with .dotignore support
sync_with_ignore "$DOTFILES_DIR/claude" "$TARGET_DIR/.claude"
# hammerspoon
link "$DOTFILES_DIR/hammerspoon/init.lua" "$TARGET_DIR/.hammerspoon/init.lua"

# aqua
link "$DOTFILES_DIR/aqua/aqua.yaml" "$TARGET_DIR/.config/aqua/aqua.yaml"

# mise
link "$DOTFILES_DIR/mise/config.toml" "$TARGET_DIR/.config/mise/config.toml"

# tools
link_dir "$DOTFILES_DIR/tools" "$TARGET_DIR/.config/tools"
# nvim
link_dir "$DOTFILES_DIR/nvim" "$TARGET_DIR/.config/nvim"

# karabiner
bun run karabiner/karabiner.ts

# claude code mcp
claude mcp add -s user terraform -- docker run -i --rm hashicorp/terraform-mcp-server
claude mcp add -s user aws-documentation -- awslabs.aws-documentation-mcp-server

echo "Setup complete!"