link_config() {
   mkdir -p "$(dirname "$2")"
   ln -sf "$1" "$2"
}

link_config ~/repos/dotfiles/i3/config ~/.config/i3/config
link_config ~/repos/dotfiles/init.lua ~/.config/nvim/init.lua
link_config ~/repos/dotfiles/settings.json ~/.config/Code/User/settings.json
link_config ~/repos/dotfiles/.tmux.conf ~/.tmux.conf
link_config ~/repos/dotfiles/config.yml ~/.config/lazygit/config.yml
link_config ~/repos/dotfiles/.wezterm.lua ~/.wezterm.lua
