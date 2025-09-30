local wezterm = require 'wezterm'

local colors = {
    foreground = "#c5c9c5",
    background = "#181616",
    cursor_bg = "#C8C093",
    cursor_fg = "#C8C093",
    cursor_border = "#C8C093",
    selection_fg = "#C8C093",
    selection_bg = "#2D4F67",
    scrollbar_thumb = "#16161D",
    split = "#16161D",
    ansi = {
        "#0D0C0C",
        "#C4746E",
        "#8A9A7B",
        "#C4B28A",
        "#8BA4B0",
        "#A292A3",
        "#8EA4A2",
        "#C8C093",
    },
    brights = {
        "#A6A69C",
        "#E46876",
        "#87A987",
        "#E6C384",
        "#7FB4CA",
        "#938AA9",
        "#7AA89F",
        "#C5C9C5",
    },
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
   local index = tab.tab_index + 1
   return { { Text = " " .. index .. " " } }
end)

return {
   default_prog = { "powershell.exe", "-NoLogo" },
   default_cwd = "D:\\repos",
   font = wezterm.font("Hurmit Nerd Font", { weight = "Bold" }),
   font_size = 24,
   window_padding = {
      left=0,
      top=0,
      right=0,
      bottom=0,
   },
   use_fancy_tab_bar = false,
   hide_tab_bar_if_only_one_tab = false,
   colors = colors,
   colors = {
      tab_bar = {
         background = colors.background,
         active_tab = {
            bg_color = "#2A2828", 
            fg_color = colors.foreground,
         },
         inactive_tab = {
            bg_color = "#181616",
            fg_color = "#A6A69C",
         },
         inactive_tab_hover = {
             bg_color = "#1F1E1E",
             fg_color = colors.foreground,
         },
         new_tab = {
             bg_color = "#181616",
             fg_color = "#C4B28A",
         },
         new_tab_hover = {
             bg_color = "#2A2828",
             fg_color = "#E6C384",
         },
      },
      foreground = colors.foreground,
      background = colors.background,
      cursor_bg = colors.cursor_bg,
      cursor_fg = colors.cursor_fg,
      cursor_border = colors.cursor_border,
      selection_bg = colors.selection_bg,
      selection_fg = colors.selection_fg,
      ansi = colors.ansi,
      brights = colors.brights,
   },
   tab_bar_at_bottom = true,
   leader = { key="b", mods="CTRL", timeout_milliseconds=1000 },
   keys = {
      {key="c", mods="LEADER", action=wezterm.action{SpawnTab="DefaultDomain"}},
      {key="x", mods="LEADER", action=wezterm.action{CloseCurrentTab={confirm=true}}},
      {key="1", mods="LEADER", action=wezterm.action{ActivateTab=0}},
      {key="2", mods="LEADER", action=wezterm.action{ActivateTab=1}},
      {key="3", mods="LEADER", action=wezterm.action{ActivateTab=2}},
      {key="4", mods="LEADER", action=wezterm.action{ActivateTab=3}},
      {key="5", mods="LEADER", action=wezterm.action{ActivateTab=4}},
      {key="6", mods="LEADER", action=wezterm.action{ActivateTab=5}},
      {key="7", mods="LEADER", action=wezterm.action{ActivateTab=6}},
      {key="8", mods="LEADER", action=wezterm.action{ActivateTab=7}},
      {key="9", mods="LEADER", action=wezterm.action{ActivateTab=8}},
   },
}
