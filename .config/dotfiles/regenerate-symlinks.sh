#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.config/dotfiles"
DOTFILES_CMD="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

mkdir -p "$DOTFILES_DIR"
find "$DOTFILES_DIR" -type l -delete

mapfile -t tracked_files < <($DOTFILES_CMD ls-tree -r HEAD --name-only)

# Detect .config/<app> directories where every file on disk is tracked.
# Those get a single directory symlink instead of one-per-file.
declare -A full_dirs
for file in "${tracked_files[@]}"; do
    if [[ "$file" =~ ^\.config/([^/]+)/.+ ]]; then
        app_dir=".config/${BASH_REMATCH[1]}"
        [[ "$app_dir" == ".config/dotfiles" ]] && continue
        [[ -n "${full_dirs[$app_dir]:-}" ]] && continue

        target="$HOME/$app_dir"
        [ -d "$target" ] || continue

        untracked=$($DOTFILES_CMD ls-files --others --exclude-standard "$target" 2>/dev/null) || true
        [ -z "$untracked" ] && full_dirs["$app_dir"]=1
    fi
done

count=0

# Individual file symlinks (files NOT under a fully-tracked dir)
for file in "${tracked_files[@]}"; do
    [[ "$file" == ".config/dotfiles/regenerate-symlinks.sh" ]] && continue
    [[ "$file" == ".gitignore" ]] && continue

    skip=0
    for d in "${!full_dirs[@]}"; do
        if [[ "$file" == "$d/"* ]]; then
            skip=1
            break
        fi
    done
    ((skip)) && continue

    target="$HOME/$file"
    link="$DOTFILES_DIR/$file"

    [ -e "$target" ] || continue

    mkdir -p "$(dirname "$link")"
    ln -srf "$target" "$link"
    ((++count))
done

# Directory symlinks for fully-tracked dirs
for d in "${!full_dirs[@]}"; do
    target="$HOME/$d"
    link="$DOTFILES_DIR/$d"
    [ -d "$target" ] || continue
    rm -rf "$link"
    mkdir -p "$(dirname "$link")"
    ln -srf "$target" "$link"
    ((++count))
done

echo "done -- $count symlinks under $DOTFILES_DIR"
