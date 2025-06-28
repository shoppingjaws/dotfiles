# リモートに同名のブランチが存在していたら、ローカルにworktreeを作成する
# 存在していなかったら、現在のブランチから新しいworktreeを作成する
# worktreeは $HOME/worktrees/以下に作成する
# ディレクトリは$HOME/worktrees/github.com/<owner>/<repo>/<branch>　のように

function git_worktree_branch
    set -l branch_name $argv[1]
    
    # Apply prefix if set
    if test -n "$GIT_BRANCH_PREFIX"
        set branch_name "$GIT_BRANCH_PREFIX$branch_name"
    end
    
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
    
    # Check if worktree already exists
    if git worktree list | grep -q $worktree_dir
        echo "Switching to existing worktree"
        cd $worktree_dir
        return 0
    end
    
    # Check if remote branch exists
    if git ls-remote --heads origin $branch_name | grep -q $branch_name
        echo "Creating worktree from remote branch"
        git worktree add $worktree_dir $branch_name
    else if git branch --list $branch_name | grep -q $branch_name
        echo "Creating worktree from local branch"
        git worktree add $worktree_dir $branch_name
    else
        echo "Creating new worktree"
        git worktree add -b $branch_name $worktree_dir
    end
    
    if test $status -eq 0
        echo "Done: $worktree_dir"
        cd $worktree_dir
    else
        echo "Failed"
        return 1
    end
end