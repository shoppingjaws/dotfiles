function __user_host
  # User/host display removed
end

function __current_path
  set -l current_path (pwd)
  
  # Path abbreviations (original:abbreviation)
  set -l path_abbreviations \
    "github.com" "g" \
    "/Users/$USER" "~" \
    "shoppingjaws" "sj"
  
  # Apply abbreviations with bold formatting
  for i in (seq 1 2 (count $path_abbreviations))
    set -l original $path_abbreviations[$i]
    set -l abbrev $path_abbreviations[(math $i + 1)]
    set -l bold_abbrev (set_color --bold white)$abbrev(set_color --bold blue)
    set current_path (string replace $original $bold_abbrev $current_path)
  end
  
  echo -n (set_color --bold blue) $current_path (set_color normal) 
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function __git_status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '<'$git_branch"*"'>'
    else
      set git_info '<'$git_branch'>'
    end

    echo -n (set_color yellow) $git_info (set_color normal) 
  end
end


function __env_vars
  # Check if in worktrees directory and set IN_WORKTREE
  if string match -q "$HOME/worktrees*" (pwd)
    set -gx IN_WORKTREE true
  else
    set -e IN_WORKTREE
  end

  # Environment variables to display (var_name:display_name:color:replacement)
  set -l env_vars_to_show \
    "AWS_PROFILE" "󰸏" "yellow" "" \
    "IN_WORKTREE" "󰐆" "green" ""

  for i in (seq 1 4 (count $env_vars_to_show))
    set -l var_name $env_vars_to_show[$i]
    set -l display_name $env_vars_to_show[(math $i + 1)]
    set -l color $env_vars_to_show[(math $i + 2)]
    set -l replacement $env_vars_to_show[(math $i + 3)]
    if set -q $var_name
      if test "$replacement" = ""
        echo -n (set_color $color) $display_name (set_color normal) " "
      else
        set -l var_value (eval echo \$$var_name)
        echo -n (set_color $color) $display_name $var_value (set_color normal) " "
      end
    end
  end
end

function fish_prompt
  echo -n (set_color white)"╭─"(set_color cyan)"󱙳 "(set_color normal)
  __user_host
  __current_path
  __git_status
  __env_vars
  echo -e ''
  echo (set_color white)"╰─"(set_color --bold white)"\$ "(set_color normal)
end

function fish_right_prompt
  set -l st $status

  if [ $st != 0 ];
    echo (set_color red) ↵ $st(set_color normal)
  end
end