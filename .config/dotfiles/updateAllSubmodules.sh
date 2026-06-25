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

mapfile -t -C mapper -c 1 < <($GIT submodule foreach --recursive --quiet 'echo "$name $toplevel $sm_path"')

mapfile -t diff_files < <($GIT diff --name-only HEAD)
echo DIFF:

function contains {
	haystack=$1
	needle=$2

	for item in ${haystack[@]}; do
		if [[ $item == $needle ]]; then
			echo 1
		fi
	done

	echo 0
}

for file in "${diff_files[@]}"; do
	echo ${file}
done

cd $CWD
echo ''
