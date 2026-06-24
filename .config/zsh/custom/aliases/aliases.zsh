alias install='sudo pacman -S '
alias reload='source ~/.zshrc'
alias FUCK='shutdown now'

alias lsa='ls -A'
lsdepth () {
	find . -maxdepth ${1:-0} -type d -ls ${@:2}
}

alias hyprconf='cd ~/.config/hypr && nvim'
alias hyprreload='hyprctl reload config-only'
alias hyprkenisis='hyprctl keyword source ~/.config/hypr/kenisis/init.conf'

alias bbrun='~/code/bitburner/bitburner-src/.build/bitburner-linux-x64/bitburner'
alias bbfilesync='cdbbfilesync && go run main.go --dir ~/code/bitburner/ctn-bitburner-nvim/ '
alias cdbb='cd ~/code/bitburner/'
alias cdbbctn='cd ~/code/bitburner/ctn-bitburner-nvim/'
alias cdbbfilesync='cd ~/code/bitburner/gofilesync/'
alias cdbbsrc='cd ~/code/bitburner/bitburner-src/'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias dotfiles-tracked='dotfiles ls-tree -r HEAD --name-only ./ | sort -u'

alias autonvim='$HOME/.config/nvim/lua/cthemen/exsamples/auto-nvim.zsh'
