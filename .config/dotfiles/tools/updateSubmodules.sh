#!/usr/bin/env bash

pipefailArgs=$1
pipefailArgs+="euo"
set "-$pipefailArgs" pipefail

DRY=${2:-1}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# getIndex[T](haystack T[], needle T) int
source "$script_dir/utils.sh"

CWD="$PWD"
cd "$HOME" || exit

GIT="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
declare -A gitcmdOverrides
gitcmdOverrides[$HOME]="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

names=()
roots=()
paths=()

function mapper {
	local i=$1
	local val=$2
	local name
	local root
	local path


	read -r name root path <<< "$val"
	echo "$i": name="$name" root="$root" path="$path"

	names[i]="$name"
	roots[i]="$root"
	paths[i]="$path"
}

mapfile -t -C mapper -c 1 < <($GIT submodule foreach --recursive --quiet 'echo "$name" "$toplevel" "$sm_path"')
echo Recurse:

# NOTE: (gitcmd string, dir string): files string[]
function getDiffFiles {
	local gitcmd=$1
	local gitdir=$2

	(cd "$gitdir" && $gitcmd diff --name-only HEAD)
}

diffModules=()

# NOTE: (gitcmd string)
function walkDiffTree {
	local gitcmd=$1
	local diffFiles
	mapfile -t diffFiles < <(getDiffFiles "$gitcmd" "$PWD")

	declare -i i=0
	while [[ $i -lt ${#diffFiles[@]} ]]; do
		local file=${diffFiles[$i]}
		declare -i idx
		idx=$(getIndex paths "$file")

		if [[ $idx -ne -1 ]]; then
			local path="${roots[$idx]}/${paths[$idx]}"
			echo $idx: "$path"
			diffModules+=("$idx")
			mapfile -t -O "${#diffFiles[@]}" diffFiles < <(getDiffFiles "git" "$path")
		fi

		i+=1
	done
}

walkDiffTree "$GIT"

echo Modules:
declare -A updatedModuleNames
declare -A updatedModulePaths
for i in "${!diffModules[@]}"; do
	declare -i idx
	declare -i len="${#diffModules[@]}"

	idx=${diffModules[len - i - 1]}

	name=${names[$idx]}
	root=${roots[$idx]}
	path=${paths[$idx]}
	gitcmd=${gitcmdOverrides[$root]:-"git"}

	updatedModuleNames[$root]+="$name "
	updatedModulePaths[$root]+="$path "

	##-TODO: check if stuff is already staged
	# ( cd "$root" || exit
	# 	echo "$PWD"
	# 	printf "%i: %s add %s\n" "$idx" "$gitcmd" "$path"
	# 	((DRY)) || "$gitcmd" add "$path"
	# 	# printf "update(submodule): $name\n"
	# )
done

# printf "update(submodule): %s\n" "${updatedModules[@]}"
for root in "${!updatedModuleNames[@]}"; do
	commitMessage=${updatedModuleNames[$root]}
	commitPaths=${updatedModulePaths[$root]}
	gitcmd=${gitcmdOverrides[$root]:-"git"}

	( cd "$root" || exit
		echo "$PWD"
		printf "%s commit %s -m %s\n" "$gitcmd" "${commitPaths% }" "update(submodule): $commitMessage"
		printf "%s push\n" "$gitcmd"
		(( DRY )) && exit
		$gitcmd commit ${commitPaths% } -m "update(submodule): $commitMessage"
		"$gitcmd" push
	)
done


cd "$CWD" || exit
echo '--'
