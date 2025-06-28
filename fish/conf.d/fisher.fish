set -gx XDG_CONFIG_HOME "$HOME/.config"


if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/4.4.5/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    fisher install fish-ghq@cafaaabe63c124bf0714f89ec715cfe9ece87fa2
    fisher install yuys13/fish-autols@74c52a3f66b5b9f589871c4383e7d7c2e543032c
    fisher install yuys13/fish-ghq-fzf@9798eadadda71c3cb43502f88cfce1f9521ee185
    fisher install yuys13/fish-gcd@e42ccc3c48ecaf2a8efb8a12d7426a8a7fd077e3
end

fish_add_path $__fish_config_dir/fisher
