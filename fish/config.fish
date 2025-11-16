#==================
# Fish Shell Configuration
#==================
#==================
# History Settings
#==================
set -g fish_history_size 1000000
# History search with fzf
function history_search
    set -l cmd (history | fzf --no-sort +m --query "$argv" --prompt="History > ")
    if test -n "$cmd"
        commandline -r $cmd
    end
end
bind \cr history_search


#==================
# Configuration
#==================
# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

set -gx EDITOR "code"
# WezTerm
fish_add_path /Applications/WezTerm.app/Contents/MacOS
# fisher
fish_add_path $__fish_config_dir/fisher
# if fisher is not installed, install it
if not type -q fisher
    echo "Installing fisher..."
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

# mise
mise activate fish | source

set -xg GIT_BRANCH_PREFIX "develop/"
fish_add_path (npm prefix --location=global)/bin
fish_add_path $XDG_CONFIG_HOME/tools
fish_add_path /Library/Application\ Support/org.pqrs/Karabiner-Elements/bin


# claude code
set -gx CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR "1"

# aqua
set -gx AQUA_CONFIG_DIR "$HOME/aquaproj-config/aqua.yaml"

#==================
# Extra configuration
#==================
# Credentials
if test -f "$HOME/.config/fish/config_secret.fish"
    source "$HOME/.config/fish/config_secret.fish"
end
# Unsynced configuration
if test -f "$HOME/.private.fish"
    source "$HOME/.private.fish"
end
