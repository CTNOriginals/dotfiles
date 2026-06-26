#!/usr/bin/env bash

CWD=$PWD
cd $HOME

GIT="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

names=()
roots=()
paths=()

function mapper {
	i=$1
	val=$2

	read -r name root path <<< "$val"
	echo $i: name=$name root=$root path=$path

	names[$i]=$name
	roots[$i]=$root
	paths[$i]=$path
}

mapfile -t -C mapper -c 1 < <($GIT submodule foreach --recursive --quiet 'echo "$name" "$toplevel" "$sm_path"')

mapfile -t diff_files < <($GIT diff --name-only HEAD)
echo DIFF:

function getIndex {
	declare -n haystack=$1
	local needle=$2

	for idx in ${!haystack[@]}; do
		item=${haystack[$idx]}
		# echo $idx: "$needle == $item" = $([[ "$item" == "$needle" ]])
		[[ "$item" == "$needle" ]] && echo $idx
	done

	echo -1
}

for file in "${diff_files[@]}"; do
	declare -i idx
	idx=$(getIndex paths $file)

	if [[ $idx -gt -1 ]]; then
		echo $idx: "$file"
	fi
done

cd $CWD
echo ''
