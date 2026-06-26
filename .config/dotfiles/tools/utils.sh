#!/usr/bin/env bash

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
