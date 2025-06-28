# リモートに同名のブランチが存在していたら、ローカルにチェックアウトする
# 存在していなかったら、現在のブランチからチェックアウトする

function git_checkout_branch
    set -l branch_name $argv[1]
    
    # Apply prefix if set
    if test -n "$GIT_BRANCH_PREFIX"
        set branch_name "$GIT_BRANCH_PREFIX$branch_name"
    end
    
    if test -z "$branch_name"
        echo "Usage: git_checkout_branch <branch_name>"
        return 1
    end
    
    # Check if remote branch exists
    if git ls-remote --heads origin $branch_name | grep -q $branch_name
        echo "Checking out remote branch"
        git checkout $branch_name
    else
        echo "Creating new branch"
        git checkout -b $branch_name
    end
    
    if test $status -eq 0
        echo "Done: $branch_name"
    else
        echo "Failed"
        return 1
    end
end