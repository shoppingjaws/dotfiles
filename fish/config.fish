#==================
# Fish Shell Configuration
#==================
echo "loading config.fish"
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
set -gx EDITOR "code"
# WezTerm
fish_add_path /Applications/WezTerm.app/Contents/MacOS
# brew
eval (/opt/homebrew/bin/brew shellenv)
# direnv
direnv hook fish | source

set -xg GIT_BRANCH_PREFFIX "develop/"

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
echo "config.fish loaded"