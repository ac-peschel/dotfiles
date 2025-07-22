link_config() {
   mkdir -p "$(dirname "$2")"
   ln -sf "$1" "$2"
}

link_config ~/repos/dotfiles/alacritty.yml ~/.config/alacritty/alacritty.yml
link_config ~/repos/dotfiles/i3/config ~/.config/i3/config
link_config ~/repos/dotfiles/init.lua ~/.config/nvim/init.lua
