#!/usr/bin/env bash

function getIndex {
	declare -n haystack=$1
	local needle=$2
	local -i idx=0

	for idx in "${!haystack[@]}"; do
		item=${haystack[$idx]}
		# printf "%i: %s == %s\n" "$idx" "$needle" "$item"
		if [[ "$item" == "$needle" ]]; then
			echo "$idx"
			return 0
		fi
	done

	echo -1
}
