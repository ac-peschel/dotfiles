link_config() {
	mkdir -p "$(dirname "$2")"
	ln -sf "$1" "$2"
}

mkdir -p ~/.config/i3
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/picom
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi

chmod +x ~/github/ac-peschel/dotfiles/polybar/launch.sh

rm -rf ~/.config/nvim
ln -s ~/github/ac-peschel/dotfiles/nvim ~/.config/nvim
link_config ~/github/ac-peschel/dotfiles/i3/config ~/.config/i3/config
link_config ~/github/ac-peschel/dotfiles/alacritty.toml ~/.config/alacritty/alacritty.toml
link_config ~/github/ac-peschel/dotfiles/.tmux.conf ~/.tmux.conf
link_config ~/github/ac-peschel/dotfiles/picom.conf ~/.config/picom/picom.conf
link_config ~/github/ac-peschel/dotfiles/polybar/config.ini ~/.config/polybar/config.ini
link_config ~/github/ac-peschel/dotfiles/polybar/launch.sh ~/.config/polybar/launch.sh
link_config ~/github/ac-peschel/dotfiles/rofi/config.rasi ~/.config/rofi/config.rasi
link_config ~/github/ac-peschel/dotfiles/rofi/catppuccin-mocha.rasi ~/.config/rofi/catppuccin-mocha.rasi
