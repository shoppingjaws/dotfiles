set -gx XDG_CONFIG_HOME "$HOME/.config"


# default command overlay
alias ls "eza -alhg"
alias p8 "ping 8.8.8.8"
# alias cat "bat --style=plain"
# alias tree "eza -T"

# git
alias gc "git checkout"
alias gw "git worktree"
alias gui "lazygit"
alias gp "git push --set-upstream origin (git branch --show-current)"
alias ga "git add --all; git diff --staged --stat;"
alias gac 'cd (git rev-parse --show-toplevel); and git add .; and git commit -m (gh commit); and cd -'
# Git Auto Commit Settings
set -gx FINE_TUNE_PARAMS '{"temperature": 0.7}'
set -gx PROMPT_OVERRIDE "与えられたコード変更を調査・説明し、Conventional Commitsフォーマットでコミットメッセージを作成します。1行で簡潔に記述してください。日本語で記述してください。"
alias gwj "git worktree_jump"
alias ghpr "gh pr view --web"


# cloud native tools
alias kb "kubectl"
alias tf "terraform"
alias tg "terragrunt"
alias dc "docker compose"
alias dps "docker ps"
alias kz "kustomize"

# claude
alias c "claude"
alias cpr "claude -p '変更差分を確認してPRの内容を更新してください。必ず日本語で作成してください。必ずDraftで作成すること。必ず @.github/PULL_REQUEST_TEMPLATE フォーマットに沿わせてください。作成完了後に確認するのでReadyにしないでください。作成したPRのURLを最後に出力してください。'"
