# CTN dotfiles

Managed with a bare git repo at `~/.dotfiles` tracked via
`dotfiles` alias: `git --git-dir=$HOME/.dotfiles --work-tree=$HOME`

## Layout

All config files live in `~/.config/{bash,zsh,git}/`. Thin symlinks
in `$HOME` point to them as entry points.

| `$HOME` | Type | Real location in `~/.config/` |
|---------|------|------------------------------|
| `.bashrc` | symlink | `~/.config/bash/bashrc` |
| `.zshrc` | symlink | `~/.config/zsh/zshrc` |
| `.gitconfig` | — | `~/.config/git/config` (native XDG) |

- `.bash_profile` lives at `~/.config/bash/bash_profile` (not symlinked;
  bash falls back to `.bashrc` on interactive shells anyway)
- `.bash_aliases` lives at `~/.config/bash/bash_aliases`, sourced from
  `~/.config/bash/bashrc`
- `.zprofile` was redundant (same PATH line in `.zshrc`) and deleted
- `.gtkrc-2.0` was unused (gtk2 not installed) and deleted
- `.gitignore` stays at `~/.gitignore` — controls the dotfiles bare
  repo worktree

## Fresh-machine bootstrap

```bash
git clone --bare git@github.com:CTNOriginals/dotfiles.git $HOME/.dotfiles

# Set up dotfiles alias for the session
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Create required directories
mkdir -p ~/.config/{bash,zsh,git}

# Checkout (may fail on existing stock files; back them up or remove)
dotfiles checkout

# Verify symlinks exist in $HOME
ls -la ~/.bashrc ~/.zshrc
```
