alias tree='tree --filesfirst -C'

# echo Tree aliases loaded
function treel {
	# echo tree --filesfirst -C -L $@

	local depth=1

	if [[ ${#@} == 1 && $1 =~ ^[0-9]+$ ]]; then
		depth=$1
		shift
	fi

	if [[ ${#@} == 0 ]]; then
		tree -L $depth
	fi
	
	for arg in "$@"; do
		if [[ $arg =~ ^[0-9]+$ ]]; then
			depth=$arg
		else
			tree -L $depth "$arg"
		fi
	done
}
