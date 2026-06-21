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

## Submodules

Submodules track a pinned commit by default (detached HEAD). For repos you actively
develop, you can tell them to follow the `main` branch instead.

Each entry in `.gitmodules` has a `branch` field:

```ini
[submodule "nvim"]
    path = .config/nvim
    url = git@github.com:CTNOriginals/nvim.git
    branch = main
```

### Commands

| What | Command |
|---|---|
| clone with submodules at latest `main` | `git clone --recurse-submodules --remote <url>` |
| update every submodule to latest on its branch | `git submodule update --remote --merge` |
| also switch each submodule out of detached HEAD | see below |
| pin back to the current SHAs (commit the result) | `git add .config/<name>` → commit → push |

To get on the actual branch (not detached HEAD) after updating:

```sh
git submodule foreach -q --recursive \
  'b="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; \
   [ "$b" ] && git switch "$b"'
```

## Dependencies

```sh
sudo pacman -S alacritty tmux waybar zsh neovim hyprland
```

## TODO

[ ] Seperate aliases specific to this machine into an ifgored file
