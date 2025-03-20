local wezterm = require 'wezterm'
local act = wezterm.action

return {
    keys = {
        {
            key = 'f',
            mods = 'CMD',
            action = act.Search { Regex = '' }
        },
        { key = '{', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
        { key = '}', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
        {
        key = 'j',
        mods = 'LEADER',
        action = act.SplitPane {
            direction = 'Left'
        }
    }, {
        key = 'l',
        mods = 'LEADER',
        action = act.SplitPane {
            direction = 'Right'
        }
    }, {
        key = 'i',
        mods = 'LEADER',
        action = act.SplitPane {
            direction = 'Up'
        }
    }, {
        key = 'k',
        mods = 'LEADER',
        action = act.SplitPane {
            direction = 'Down'
        }
    }, {
        key = 't',
        mods = 'CMD',
        action = act.SpawnTab 'DefaultDomain'
    }, {
        key = 'w',
        mods = 'CMD',
        action = act.CloseCurrentTab {
            confirm = true
        }
    },{
        key = 'w',
        mods = 'CMD|SHIFT',
        action = act.CloseCurrentPane {
            confirm = true
        }
    }, {
        key = "v",
        mods = "CMD",
        action = act.PasteFrom 'Clipboard'
    }, {
        key = "c",
        mods = "CMD",
        action = act.CopyTo 'ClipboardAndPrimarySelection'
    }, {
        key = "k",
        mods = "CMD|SHIFT",
        action = act.ActivateCommandPalette
    }, {
        -- ¥ではなく、バックスラッシュを入力する。
        key = "¥",
        action = act.SendKey {
            key = '\\'
        }
    }, {
        -- Altを押した場合はバックスラッシュではなく¥を入力する。
        key = "¥",
        mods = "ALT",
        action = act.SendKey {
            key = '¥'
        }
    }, {
        -- ⌘ + でフォントサイズを大きくする
        key = "+",
        mods = "CMD|SHIFT",
        action = act.IncreaseFontSize
    }, {
        -- ⌘ - でフォントサイズを小さくする
        key = "-",
        mods = "CMD",
        action = act.DecreaseFontSize
    }, {
        -- ⌘ w でペインを閉じる（デフォルトではタブが閉じる）
        key = "w",
        mods = "CMD",
        action = act.CloseCurrentPane {
            confirm = true
        }
    }},

    key_tables = {
        copy_mode = {},
        search_mode = {
    { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    -- { key = 'r', mods = 'CMD', action = act.CopyMode 'ToggleRegex' },
    { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    -- { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
    -- { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
    { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
        }

    }
}
