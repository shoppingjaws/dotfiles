function git_checkout_default -d "Checkout to the default branch (main or master)"
    set -l default_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if test -z "$default_branch"
        set default_branch (git branch -r | grep -E 'origin/(main|master)$' | head -1 | sed 's/.*origin\///')
    end
    if test -z "$default_branch"
        echo "Could not determine default branch"
        return 1
    end
    git checkout $default_branch
end
