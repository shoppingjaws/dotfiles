function git_worktree_jump
        set -l gwb_name (git rev-parse --show-toplevel | sed 's|.*/github.com/||')
        # リモートブランチの存在確認
        if git ls-remote --heads origin develop/$argv[1] | grep -q develop/$argv[1]
            # リモートブランチが存在する場合は、それをチェックアウト
            echo "🔄 リモートブランチ 'origin/develop/$argv[1]' が見つかりました。既存のブランチをチェックアウトします..."
            git worktree add --track -b develop/$argv[1] ~/worktree/develop/$gwb_name/$argv[1] origin/develop/$argv[1]; and cd ~/worktree/develop/$gwb_name/$argv[1]
        else
            # リモートブランチが存在しない場合は、新規作成
            echo "✨ リモートブランチが見つかりません。新規ブランチ 'develop/$argv[1]' を作成します..."
            git worktree add --checkout -b develop/$argv[1] ~/worktree/develop/$gwb_name/$argv[1]; and cd ~/worktree/develop/$gwb_name/$argv[1]
        end
    end