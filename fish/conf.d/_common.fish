# _common.fish　は一番最初に読み込まれるので、ここに共通の設定を記述する
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx DOTFILES_DIR "$HOME/ghq/github.com/shoppingjaws/dotfiles"
# brew
eval (/opt/homebrew/bin/brew shellenv)
