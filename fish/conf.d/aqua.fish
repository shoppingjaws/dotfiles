# aqua
set -gx AQUA_GLOBAL_CONFIG $XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
fish_add_path (aqua root-dir)/bin
# node via aqua
set -gx NPM_CONFIG_PREFIX (set -q XDG_DATA_HOME; and echo $XDG_DATA_HOME; or echo $HOME/.local/share)/npm-global
fish_add_path $NPM_CONFIG_PREFIX/bin