link_config() {
	mkdir -p "$(dirname "$2")"
	ln -sf "$1" "$2"
}

link_config ~/github/ac-peschel/dotfiles/i3/config ~/.i3/config
link_config ~/github/ac-peschel/dotfiles/init.lua ~/.config/nvim/init.lua
link_config ~/github/ac-peschel/dotfiles/alacritty.toml ~/.config/alacritty/alacritty.toml
link_config ~/github/ac-peschel/dotfiles/.tmux.conf ~/.tmux.conf
