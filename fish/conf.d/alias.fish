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
alias gac 'git -C (git rev-parse --show-toplevel) add .;npx opencommit --yes'
alias gwj "git worktree_jump"
alias ghpr "gh pr view --web"
alias vim "nvim"
alias cr "cd (git rev-parse --show-toplevel)"

# cloud native tools
alias kb "kubectl"
alias tf "terraform"
alias tg "terragrunt"
alias dc "docker compose"
alias dps "docker ps"
alias kz "kustomize"

# claude
alias c "env claude"
alias cc "env claude --add-dir (git rev-parse --show-toplevel)"

# nix
alias nix-rebuild "sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin/master#darwin-rebuild -- switch --impure --flake $(ghq root)/github.com/shoppingjaws/dotfiles/flake#darwin"

# etc
alias z "z -r" # zは最も頻繁にアクセスするディレクトリに飛ぶ
alias sl "ls"
alias ls "eza --icons=always -alhg"
alias krbn "karabiner_cli"
alias co "code ."