local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16
config.window_decorations = "RESIZE"

config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({confirm = true}),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.SplitHorizontal({domain = "CurrentPaneDomain"}),
	},
	{
		mods = "LEADER",
		key = "v",
		action = wezterm.action.SplitVertical({domain = "CurrentPaneDomain"}),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},	
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER|SHIFT",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({"Left", 5}),
	},
	{
		mods = "LEADER|SHIFT",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({"Right", 5}),
	},
	{
		mods = "LEADER|SHIFT",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({"Up", 5}),
	},
	{
		mods = "LEADER|SHIFT",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({"Down", 5}),
	},
}

for i = 0, 9 do 
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i),
	})
end

config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

wezterm.on("update-right-status", function(window, _)
    local SOLID_LEFT_ARROW = ""
    local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
    local prefix = ""

    if window:leader_is_active() then
        prefix = " " .. utf8.char(0x1f30a)
        SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    end

    if window:active_tab():tab_id() ~= 0 then
        ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
    end -- arrow color based on if tab is first pane

    window:set_left_status(wezterm.format {
        { Background = { Color = "#b7bdf8" } },
        { Text = prefix },
        ARROW_FOREGROUND,
        { Text = SOLID_LEFT_ARROW }
    })
end)

config.default_prog = { "pwsh.exe", "-NoLogo" }

return config