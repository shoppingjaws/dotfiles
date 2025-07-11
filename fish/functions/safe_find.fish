function safe_find
    # Convert all arguments to a single string to check for -exec patterns
    set -l args_string (string join " " $argv)
    
    # Check for various -exec patterns including potential bypasses
    if string match -q "*-exec*" $args_string
        echo "Error: do not allowed to use -exec" >&2
        return 1
    end
    
    # Also check each individual argument for safety
    for arg in $argv
        # Check for -exec, --exec, or any variation
        if string match -r "^-+exec" $arg
            echo "Error: do not allowed to use -exec" >&2
            return 1
        end
        # Check if argument contains -exec anywhere
        if string match -q "*-exec*" $arg
            echo "Error: do not allowed to use -exec" >&2
            return 1
        end
    end
    
    # If no -exec found, run the original find command
    command find $argv
end