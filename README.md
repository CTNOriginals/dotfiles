# CTN dotfiles

bare-repo dotfiles managed via `git --git-dir=$HOME/.dotfiles --work-tree=$HOME` (alias `dotfiles`).

## Quick start

```sh
git clone --recursive git@github.com:CTNOriginals/dotfiles.git $HOME
ln -sf .config/bash/bashrc ~/.bashrc && ln -sf .config/zsh/zshrc ~/.zshrc
sudo pacman -S alacritty tmux waybar zsh neovim hyprland
reload ~/.bashrc
```

## Setup

Configs are stored under `.config/<app>/` in the repo, but tools expect them at specific paths.  
Symlinks bridge the gap:

| Link | Target |
|---|---|
| `~/.bashrc` | `.config/bash/bashrc` |
| `~/.zshrc` | `.config/zsh/zshrc` |

`.bashrc` sources `.config/bash/bash_aliases` (where the `dotfiles` alias lives).  
`.zshrc` sources `~/.bashrc`, so aliases work in both shells.

The repo root also has `.profile` (sources `.bashrc`) and `.gitignore` (see reference below).

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

## TODO

[ ] Seperate aliases specific to this machine into an ifgored file
