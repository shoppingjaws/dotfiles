# default command overlay
alias ls "eza -alhg"
alias p8 "ping 8.8.8.8"
# alias cat "bat --style=plain"
# alias tree "eza -T"

# git
alias gc "git checkout"
alias gw "git worktree"
alias gwb "git_worktree_branch"
alias gwe "git_worktree_exit"
alias gcb "git_checkout_branch"
alias gcm "git_checkout_main"
alias gui "lazygit"
alias gp "git push --set-upstream origin (git branch --show-current)"
alias ga "git add --all; git diff --staged --stat;"
alias gac 'git -C (git rev-parse --show-toplevel) add .;oco --yes'
# Git Auto Commit Settings
set -gx FINE_TUNE_PARAMS '{"temperature": 0.7}'
set -gx PROMPT_OVERRIDE "与えられたコード変更を調査・説明し、Conventional Commitsフォーマットでコミットメッセージを作成します。1行で簡潔に記述してください。日本語で記述してください。"
alias gwj "git worktree_jump"
alias ghpr "gh pr view --web"
alias cr "git_root"


# cloud native tools
alias kb "kubectl"
alias tf "terraform"
alias tg "terragrunt"
alias dc "docker compose"
alias dps "docker ps"
alias kz "kustomize"

# claude
alias c "env SHELL=/bin/bash claude"
alias cpr "claude -p  'ghコマンドを使って変更差分を確認してPRの内容を更新してください。必ず日本語で作成してください。必ずDraftで作成すること。必ず @.github/PULL_REQUEST_TEMPLATE フォーマットに沿わせてください。作成完了後に確認するのでReadyにしないでください。作成したPRのURLを最後に出力してください。'"

# nix
alias nix-rebuild "sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin/master#darwin-rebuild -- switch --impure --flake $(ghq root)/github.com/shoppingjaws/dotfiles/flake#darwin"

# etc
alias z "z -r" # zは最も頻繁にアクセスするディレクトリに飛ぶ
alias sl "ls"
alias ls "eza --icons=always -alhg"