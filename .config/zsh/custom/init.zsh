# working directory
local wd="${0%/*}"

function loadDirContent {
	local dir=$1

	for filepath in $dir/*(.); do
		local ext="${filepath##*.}"
		if [[ $ext == "zsh" ]]; then
			source $filepath
		fi
	done
}

# Source all .zsh files in subdirectories that are not detected by zsh initially
for filepath in $wd/*(N/); do
	local base="${filepath##*/}"
	if [[ $base != "themes" && $base != "plugins" ]]; then
		loadDirContent $filepath
	fi
done
