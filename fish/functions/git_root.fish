function git_root
    # Check if current directory is in a git repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        # Move to git root directory
        cd (git rev-parse --show-toplevel)
    else
        echo "Error: Not in a git repository"
        return 1
    end
end