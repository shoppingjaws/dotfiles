#==================
# Fish Shell Configuration
#==================
if status is-interactive
    echo "loading Fish..."
    #==================
    # Fish Plugins (via Fisher)
    #==================
    # Install Fisher if not already installed:
    # curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    # Autosuggestions (built-in to Fish)
    # Syntax highlighting: fisher install jorgebucaran/autopair.fish
    # FZF integration: fisher install PatrickF1/fzf.fish
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
    # Aliases
    #==================
    echo "loading Alias..."
    alias cza "chezmoi apply; exec fish"
    alias cze "chezmoi edit"
    alias p8 "ping 8.8.8.8"
    alias tf "terraform"
    alias tg "terragrunt"
    alias gc "git checkout"
    alias gw "git worktree"
    alias z "z -r"
    alias kb "kubectl"
    alias kbe "kubectl exec"
    alias dc "docker compose"
    alias lg "lazygit"
    alias ls "eza -alhg"
    alias cat "bat --style=plain"
    alias tree "eza -T"
    alias dps "docker ps"
    alias ava "aws-vault"
    alias cw 'cd (ghq list -p | fzf)'
    alias icode "code-insiders"
    # jump to default branch
    alias gcm 'git checkout (git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'
    alias gr 'git pull --rebase origin (git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'
    alias gp 'git push --set-upstream origin (git branch --show-current)'
    alias ghp "gh pr view --web"
    alias gac 'cd (git rev-parse --show-toplevel); and git add .; and git commit -m (gh commit); and cd -'
    alias ga "git add --all; git diff --staged --stat;"
    alias kz "kustomize"
    alias cpr "claude -p '変更差分を確認してPRの内容を更新してください。必ず日本語で作成してください。必ずDraftで作成すること。必ず @.github/PULL_REQUEST_TEMPLATE フォーマットに沿わせてください。作成完了後に確認するのでReadyにしないでください。作成したPRのURLを最後に出力してください。'"
    alias c "claude"
    #==================
    # Functions
    #==================
    function gcb
        git checkout -b develop/$argv[1]
    end
    function gwb
        set -l gwb_name (git rev-parse --show-toplevel | sed 's|.*/github.com/||')
        # リモートブランチの存在確認
        if git ls-remote --heads origin develop/$argv[1] | grep -q develop/$argv[1]
            # リモートブランチが存在する場合は、それをチェックアウト
            echo "🔄 リモートブランチ 'origin/develop/$argv[1]' が見つかりました。既存のブランチをチェックアウトします..."
            git worktree add --track -b develop/$argv[1] ~/worktree/develop/$gwb_name/$argv[1] origin/develop/$argv[1]; and cd ~/worktree/develop/$gwb_name/$argv[1]
        else
            # リモートブランチが存在しない場合は、新規作成
            echo "✨ リモートブランチが見つかりません。新規ブランチ 'develop/$argv[1]' を作成します..."
            git worktree add --checkout -b develop/$argv[1] ~/worktree/develop/$gwb_name/$argv[1]; and cd ~/worktree/develop/$gwb_name/$argv[1]
        end
    end
    
    function zc
        z -r $argv[1]
        code .
    end
    
    #==================
    # Environment Variables
    #==================
    set -gx EDITOR "code"
    
    # Git Auto Commit Settings
    set -gx FINE_TUNE_PARAMS '{"temperature": 0.7}'
    set -gx PROMPT_OVERRIDE "与えられたコード変更を調査・説明し、Conventional Commitsフォーマットでコミットメッセージを作成します。1行で簡潔に記述してください。日本語で記述してください。
"
    
    # Go
    set -gx GOPATH $HOME/go
    fish_add_path $GOPATH/bin
    
    # AWS-vault
    set -gx AWS_VAULT_KEYCHAIN_NAME "login"
    set -gx AWS_ASSUME_ROLE_TTL "1h"
    
    # Generative AI Settings
    set -gx OPENAI_URL "https://models.inference.ai.azure.com"
    set -gx OPENAI_MODEL gpt-4o
    set -gx OPENAI_API_KEY (gh auth token)
    
    # WezTerm
    fish_add_path /Applications/WezTerm.app/Contents/MacOS
    
    #==================
    # Path Configuration
    #==================
    # brew
    eval (/opt/homebrew/bin/brew shellenv)
    
    # aqua
    set -gx AQUA_GLOBAL_CONFIG $AQUA_GLOBAL_CONFIG:(set -q XDG_CONFIG_HOME; and echo $XDG_CONFIG_HOME; or echo $HOME/.config)/aquaproj-aqua/aqua.yaml
    set -l aqua_root_dir (set -q AQUA_ROOT_DIR; and echo $AQUA_ROOT_DIR; or echo (set -q XDG_DATA_HOME; and echo $XDG_DATA_HOME; or echo $HOME/.local/share)/aquaproj-aqua)
    fish_add_path $aqua_root_dir/bin
    # node via aqua
    set -gx NPM_CONFIG_PREFIX (set -q XDG_DATA_HOME; and echo $XDG_DATA_HOME; or echo $HOME/.local/share)/npm-global
    fish_add_path $NPM_CONFIG_PREFIX/bin
    # Flutter
    fish_add_path $HOME/flutter/bin
    #==================
    # Shell Integrations
    #==================
    # z - Install with: fisher install jethrokuan/z
    # z is a Fish plugin, not a shell script

    # Starship
    starship init fish | source

    # direnv
    direnv hook fish | source

    # Completions
    if type -q aqua
        aqua completion fish | source
    end

    if type -q kustomize
        kustomize completion fish | source
    end
    
    if type -q wezterm
        wezterm shell-completion --shell fish | source
    end
    
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
end