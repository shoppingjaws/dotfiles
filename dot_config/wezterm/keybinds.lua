local wezterm = require 'wezterm'
local act = wezterm.action

return {
    keys = {{
        -- ¥ではなく、バックスラッシュを入力する。
        key = "¥",
        action = wezterm.action.SendKey {
            key = '\\'
        }
    }, {
        -- Altを押した場合はバックスラッシュではなく¥を入力する。
        key = "¥",
        mods = "ALT",
        action = wezterm.action.SendKey {
            key = '¥'
        }
    }, {
        -- ⌘ + でフォントサイズを大きくする
        key = "+",
        mods = "CMD|SHIFT",
        action = wezterm.action.IncreaseFontSize
    }, {
        -- ⌘ - でフォントサイズを小さくする
        key = "-",
        mods = "CMD",
        action = wezterm.action.DcreaseFontSize
    }, {
        -- ⌘ w でペインを閉じる（デフォルトではタブが閉じる）
        key = "w",
        mods = "CMD",
        action = wezterm.action.CloseCurrentPane {
            confirm = true
        }
    },
    { key = 'u', mods = 'LEADER', action = act.CharSelect },
  },

    key_tables = {
        copy_mode = {},

        search_mode = {}

    }
}
