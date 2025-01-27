# My Neovim/Wezterm Setup for golang and typescript on Windows

## Font
JetBrains Mono Nerd Font

## Requirements
- ```scoop install ripgrep```
- ```scoop install gcc```
- ```scoop install main/lua```
- ```scoop install main/luarocks```
- ```scoop install main/pwsh```
- ```winget upgrade JanDeDobbeleer.OhMyPosh -s winget```

## Installing LSPs
- C# ```dotnet tool install --global csharp-ls```

## WezTerm Config Location
Config inspired (copied and then modified) from: https://www.youtube.com/watch?v=V1X4WQTaxrc
- ```%userprofile%\.wezterm.lua```

## Neovim Config Location
- ```%localappdata%\nvim\init.lua```