# CTN dotfiles

bare-repo dotfiles managed via `git --git-dir=$HOME/.dotfiles --work-tree=$HOME` (alias `dotfiles`).

## Quick start

```sh
git clone --recursive git@github.com:CTNOriginals/dotfiles.git $HOME
ln -sf .config/bash/bashrc ~/.bashrc && ln -sf .config/zsh/zshrc ~/.zshrc
sudo pacman -S alacritty tmux waybar zsh neovim hyprland
reload ~/.bashrc
```

## Reference

The [`.gitignore`](./.gitignore) uses an ignore-all (`/*`) then whitelist (`!/.config/<app>`) pattern.

| What | Command |
|---|---|
| track a new config | add `!/.config/<app>` to `.gitignore` → `dotfiles add .config/<app>` → commit |
| untrack a config | remove `!/.config/<app>` from `.gitignore` → `dotfiles rm .config/<app>` → commit |
| list tracked | `dotfiles-tracked` |
| submodule status | `dotfiles submodule status` |
| bump a submodule | `dotfiles add .config/<name>` → commit → push |

## Dependencies

```sh
sudo pacman -S alacritty tmux waybar zsh neovim hyprland
```
