local wezterm = require("wezterm")

return {
   font = wezterm.font("FiraCode Nerd Font Mono"),
   font_size = 18,
   hide_tab_bar_if_only_one_tab = true,
   window_padding = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
   },
   colors = {
      foreground = "#ebdbb2",
      background = "#282828",
      ansi = {
         "#282828", -- black (color0)
         "#fb4934", -- red (color1)
         "#a89984", -- green (color2)
         "#d79921", -- yellow (color3)
         "#83a598", -- blue (color4)
         "#d3869b", -- magenta (color5)
         "#8ec07c", -- cyan (color6)
         "#ebdbb2", -- white (color7)
      },
      brights = {
         "#928374", -- bright black (color8)
         "#fb4934", -- bright red (color9)
         "#a89984", -- bright green (color10)
         "#d79921", -- bright yellow (color11)
         "#83a598", -- bright blue (color12)
         "#d3869b", -- bright magenta (color13)
         "#8ec07c", -- bright cyan (color14)
         "#ffffff", -- bright white (color15)
      },
   },
   keys = {
      {
         key = "f",
         mods = "CTRL",
         action = wezterm.action.SendString("bash ~/repos/dotfiles/fuzzy-proj.sh\n")
      },
      {
         key = "i",
         mods = "CTRL",
         action = wezterm.action.SendString("bash ~/repos/dotfiles/fuzzy-proj.sh init\n")
      }
   }
}

