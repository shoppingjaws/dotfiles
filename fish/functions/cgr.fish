function cgr -d "Change to git repository root directory"
    run_with_auto_cd bun $DOTFILES_DIR/tools/cd_git_root.ts $argv
end
