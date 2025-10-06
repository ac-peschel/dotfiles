local wezterm = require 'wezterm'
local colors = {
    foreground = "#ECE1D7",
    background = "#292522",
    cursor_bg = "#ECE1D7",
    cursor_fg = "#292522",
    cursor_border = "#ECE1D7",
    selection_fg = "#ECE1D7",
    selection_bg = "#403A36",
    scrollbar_thumb = "#16161D",
    split = "#16161D",
    ansi = {
        "#34302C",
        "#BD8183",
        "#78997A",
        "#E49B5D",
        "#7F91B2",
        "#B380B0",
        "#7B9695",
        "#C1A78E",
    },
    brights = {
        "#867462",
        "#D47766",
        "#85B695",
        "#EBC06D",
        "#A3A9CE",
        "#CF9BC2",
        "#89B3B6",
        "#ECE1D7",
    },
}
colors.tab_bar = {
    background = colors.background,
    active_tab = {
        bg_color = "#2A2828", 
        fg_color = colors.foreground,
    },
    inactive_tab = {
        bg_color = colors.background,
        fg_color = colors.brights[1], 
    },
    inactive_tab_hover = {
        bg_color = "#3A3838",
        fg_color = colors.foreground,
    },
    new_tab = {
        bg_color = colors.background,
        fg_color = colors.ansi[4], 
    },
    new_tab_hover = {
        bg_color = "#2A2828",
        fg_color = colors.brights[4],
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
   tab_bar_at_bottom = true,
   leader = { key="b", mods="CTRL", timeout_milliseconds=1000 },
   keys = {
      {key="c", mods="LEADER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
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
