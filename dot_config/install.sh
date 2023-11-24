# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# setup git
git config --global user.email "25874783+nakamuloud@users.noreply.github.com"

sudo softwareupdate --install-rosetta
brew install ghq gh starship zplug awscli chezmoi
brew install --cask iterm2 google-japanese-ime google-cloud-sdk slack arc raycast alt-tab 1password

# install font
curl -o ~/Downloads/font.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf
open ~/Downloads/font.ttf
