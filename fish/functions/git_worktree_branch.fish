# リモートに同名のブランチが存在していたら、ローカルにworktreeを作成する
# 存在していなかったら、現在のブランチから新しいworktreeを作成する
# worktreeは $HOME/worktrees/以下に作成する
# ディレクトリは$HOME/worktrees/github.com/<owner>/<repo>/<branch>　のように

function git_worktree_branch
    set -l branch_name $argv[1]
    
    if test -z "$branch_name"
        echo "Usage: git_worktree_branch <branch_name>"
        return 1
    end
    
    # Get repository info
    set -l repo_url (git remote get-url origin)
    set -l repo_path (echo $repo_url | awk -F'github.com[:/]' '{print $2}' | awk -F'.git' '{print $1}')
    
    if test -z "$repo_path"
        echo "Error: Could not determine repository path from origin URL"
        return 1
    end
    
    # Create worktree directory path
    set -l worktree_dir "$HOME/worktrees/github.com/$repo_path/$branch_name"
    
    # Check if remote branch exists
    if git ls-remote --heads origin $branch_name | grep -q $branch_name
        echo "Remote branch '$branch_name' exists. Creating worktree from remote..."
        git worktree add $worktree_dir $branch_name
    else
        echo "Remote branch '$branch_name' does not exist. Creating new worktree from current branch..."
        git worktree add -b $branch_name $worktree_dir
    end
    
    if test $status -eq 0
        echo "Worktree created at: $worktree_dir"
        cd $worktree_dir
    else
        echo "Failed to create worktree"
        return 1
    end
end