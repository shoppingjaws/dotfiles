# 現在いるディレクトリがworktreeであれば、このworktreeを削除する。
# 削除する際に、remoteへ未pushの変更がある場合は、確認を行う。

function git_worktree_exit
    set -l current_dir (pwd)
    
    # Check if current directory is a worktree
    if not git worktree list | grep -q $current_dir
        echo "Not in a worktree"
        return 1
    end
    
    # Check for unpushed changes and uncommitted changes
    set -l branch (git branch --show-current)
    set -l unpushed_commits (git rev-list --count HEAD ^origin/$branch 2>/dev/null || echo "0")
    set -l has_changes (git status --porcelain | wc -l | tr -d ' ')
    
    if test "$unpushed_commits" != "0" -o "$has_changes" != "0"
        if test "$unpushed_commits" != "0"
            echo "Unpushed changes detected ($unpushed_commits commits)."
        end
        if test "$has_changes" != "0"
            echo "Uncommitted changes detected."
        end
        echo "Continue? (y/N)"
        read -l confirm
        if test "$confirm" != "y"
            echo "Cancelled"
            return 1
        end
    end
    
    # Get main worktree path
    set -l main_worktree (git worktree list | head -1 | awk '{print $1}')
    
    # Move to main worktree before removing current worktree
    cd $main_worktree
    
    # Remove worktree
    git worktree remove $current_dir --force
    
    if test $status -eq 0
        echo "Worktree removed"
    else
        echo "Failed to remove worktree"
        return 1
    end
end