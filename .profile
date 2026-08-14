if [[ -f ~/.zshrc ]]; then
	. ~/.zshrc
elif [[ -f ~/.bashrc ]]; then
	. ~/.bashrc
fi


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
