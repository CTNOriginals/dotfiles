# CTN dotfiles

Bare-repo dotfiles managed via `git --git-dir=$HOME/.dotfiles --work-tree=$HOME` (alias `dotfiles`).

Tracked configs live at their natural paths under `$HOME` -- the bare repo on disk at
`$HOME/.dotfiles` maps file paths straight to the home directory.

## Quick start

On a fresh machine:

```sh
# 1. Clone as a bare repo
git clone --bare git@github.com:CTNOriginals/dotfiles.git $HOME/.dotfiles

# 2. Define the alias for the current shell session
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# 3. Check out the tracked files into $HOME
dotfiles checkout
# If this fails with "untracked working tree files would be overwritten",
# see Troubleshooting below.

# 4. Init and fetch submodules
dotfiles submodule update --init --recursive

# 5. Symlink the zsh config so the shell finds it
ln -sf .config/zsh/zshrc ~/.zshrc

# 6. Install the tools whose configs you see under .config/
#    (e.g. sudo pacman -S alacritty tmux waybar zsh neovim hyprland)

# 7. Reload zsh config
source ~/.zshrc
```

Verify with `dotfiles status` and `dotfiles submodule status`.

## Shell setup

The repo tracks one critical symlink:

| Link | Target |
|------|--------|
| `~/.zshrc` | `.config/zsh/zshrc` |

The chain at startup:

- **`~/.zshrc`** -- symlinked to `.config/zsh/zshrc`, which sets XDG dirs, points
  `$ZSH` to `.config/zsh/oh-my-zsh`, and loads Oh My Zsh.
- **`$ZSH/custom/`** -- contains `init.zsh` that auto-sources files from
  subdirectories (e.g. `aliases/aliases.zsh`, `startup.zsh`).
- **`~/.profile`** (repo root) -- sources `~/.zshrc` (with a bash fallback)
  for display managers and login shells that read `.profile`.

The `dotfiles` alias and other shell helpers live in
`.config/zsh/custom/aliases/aliases.zsh`.

Other configs in `.config/<app>/` are read directly by their respective tools
(Alacritty, Waybar, tmux, git, etc.) because they honour XDG_CONFIG_HOME or
default to `~/.config/<app>/`.

## Managing configs

The `.gitignore` uses an ignore-all / whitelist pattern:

```
/*                 ignore everything in the repo root
!/.config/         but not the .config directory itself
/.config/*         re-ignore everything inside .config
!/.config/<app>    whitelist specific app configs
```

| What | Command |
|------|---------|
| Track a new config | Add `!/.config/<app>` to `.gitignore` → `dotfiles add <path>` → commit |
| Stop tracking / remove | Remove whitelist line from `.gitignore` → `dotfiles rm <path>` → commit |
| List tracked files | `dotfiles ls-tree -r HEAD --name-only ./` |
| Submodule status | `dotfiles submodule status` |

To avoid listing every config path manually, run `dotfiles ls-tree -r HEAD --name-only ./ | sort`.

## Submodules

The authoritative list lives in `.gitmodules` at the repo root.
Submodules with a `branch` field track that branch (merged on updates).
Submodules without a `branch` field stay pinned to a specific commit.

| What | Command |
|------|---------|
| Clone with submodules at latest `main` | `git clone --recurse-submodules --remote <url>` |
| Update every submodule to latest on branch | `dotfiles submodule update --remote --merge` |
| Switch submodules out of detached HEAD | see below |
| Pin to current SHAs (commit the result) | `dotfiles add .config/<name>` → commit → push |

To switch each submodule onto its configured branch after updating:

```sh
dotfiles submodule foreach -q --recursive \
  'b="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; \
   [ "$b" ] && git switch "$b"'
```

## Dependencies

The packages you need are the tools whose configs are tracked under `.config/`.
Check which are tracked with `dotfiles ls-tree -r HEAD --name-only ./.config/ | sort`,
then install the corresponding packages for your distro (e.g. `sudo pacman -S <pkg>`).

## Troubleshooting

- **`dotfiles checkout` fails** -- "The following untracked working tree files
  would be overwritten by checkout".  This happens when your home directory
  already has a file that the repo wants to track.  Back it up or remove it,
  or move the conflicting files out of the way and re-run `dotfiles checkout`.

- **`dotfiles: command not found`** -- the alias hasn't been defined yet.
  Run the alias command from Quick Start step 2, or (after checkout) open a
  new shell which will source the zsh config that defines it.

- **Submodules are empty directories** -- you ran `dotfiles checkout` but
  forgot `dotfiles submodule update --init --recursive`.  Run it now.

- **Oh My Zsh theme/plugins not loading** -- the oh-my-zsh submodule isn't
  initialized (see above) or `$ZSH` in `.config/zsh/zshrc` doesn't point to
  the right path.  Verify `~/.config/zsh/oh-my-zsh/oh-my-zsh.sh` exists.

- **Config changes not tracked** -- check `.gitignore`: the app's directory
  must be whitelisted with `!/.config/<app>` before Git will see it.
