function docker-safe-sandbox --description 'Run commands in Docker with YAML-based configuration'
    bun run $DOTFILES_DIR/tools/docker-sandbox-configs/docker-safe-sandbox.ts $argv
end
