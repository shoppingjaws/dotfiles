function safe_find
    # Check if -exec is present in the arguments
    for arg in $argv
        if test "$arg" = "-exec"
            echo "Error: do not allowed to use -exec" >&2
            return 1
        end
    end
    
    # If no -exec found, run the original find command
    command find $argv
end