# コマンドを実行し、出力に CD_TO: マーカーがあればそのパスへcdする汎用function
# 使い方: run_with_auto_cd <command> [args...] [-- <additional_commands>]
#
# コマンドは最終行に CD_TO:<path> を出力することで、
# このfunctionが自動的にそのディレクトリへcdします
#
# -- 以降に追加のコマンドを指定すると、cd先でそのコマンドが実行されます
#
# 例:
#   run_with_auto_cd bun script.ts arg1 arg2
#   run_with_auto_cd bun script.ts -- git status
#   run_with_auto_cd bun script.ts -- ls -la && git status

function run_with_auto_cd
    set -l cmd_args
    set -l after_cmds

    # -- を探して、メインコマンドと追加コマンドを分離
    set -l separator_index 0
    for i in (seq (count $argv))
        if test "$argv[$i]" = "--"
            set separator_index $i
            break
        end
    end

    if test $separator_index -gt 0
        # -- が見つかった場合
        set cmd_args $argv[1..(math $separator_index - 1)]
        if test $separator_index -lt (count $argv)
            set after_cmds $argv[(math $separator_index + 1)..-1]
        end
    else
        # -- がない場合
        set cmd_args $argv
    end

    if test (count $cmd_args) -eq 0
        echo "Usage: run_with_auto_cd <command> [args...] [-- <additional_commands>]"
        return 1
    end

    # コマンドを実行し、出力をキャプチャ
    set -l output (command $cmd_args 2>&1)
    set -l exit_code $status

    # CD_TO:で始まる行を探してパスを抽出
    set -l cd_path ""

    # 出力を表示しながら、CD_TO:行を探す
    for line in $output
        echo $line
        if string match -q "CD_TO:*" $line
            set cd_path (string replace "CD_TO:" "" $line | string trim)
        end
    end

    # パスが見つかったらcdする
    if test -n "$cd_path"
        cd $cd_path

        # 追加コマンドを実行
        if test (count $after_cmds) -gt 0
            eval (string join " " $after_cmds)
        end
    end

    return $exit_code
end
