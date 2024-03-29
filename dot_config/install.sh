# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# setup git
git config --global user.email "25874783+shoppingjaws@users.noreply.github.com"

sudo softwareupdate --install-rosetta

# install font
curl -o ~/Downloads/font.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf
open ~/Downloads/font.ttf

# setup zsh completion
# works on Apple sillicon
chmod go-w '/opt/homebrew/share'
chmod -R go-w '/opt/homebrew/share/zsh'
