# CTN dotfiles

Managed with a bare git repo at `~/.dotfiles` (alias: `dotfiles`).

## How it works

The bare repo uses `$HOME` as its worktree. A `.gitignore` at `$HOME`
ignores everything by default and whitelists only specific paths.

## Layout

Config files live in `~/.config/<app>/`. Shells that can't read XDG
paths get a thin symlink in `$HOME`.

### Shell symlinks

| `$HOME` | Type | Target |
|---------|------|--------|
| `.bashrc` | symlink | `.config/bash/bashrc` |
| `.zshrc` | symlink | `.config/zsh/zshrc` |

`bash_profile` and `zprofile` are not needed 
(bash falls back to `.bashrc` for interactive shells; zprofile content was redundant).

## Adding a new config

```bash
# 1. Whitelist it in ~/.gitignore
!/.config/<app>

# 2. Track it
dotfiles add .config/<app>

# 3. Commit
dotfiles commit -m "add: <app> config"
dotfiles push
```

## Fresh-machine bootstrap

```bash
git clone --bare git@github.com:CTNOriginals/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Create dirs for tracked configs
mkdir -p ~/.config/{alacritty,bash,git,tmux,waybar,zsh}

# Checkout (may conflict with stock files — back up or remove them)
dotfiles checkout

# Verify shell symlinks
ls -la ~/.bashrc ~/.zshrc
```
