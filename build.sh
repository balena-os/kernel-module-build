#!/bin/bash

files_url='https://files.resin.io' # URL exporting S3 XML

# Output arguments to stderr.
function err()
{
	echo "$@">&2
}

# Output arguments to stderr and halt with non-zero exit code.
function fatal()
{
	err "$@"
	exit 1
}

# Output usage and halt.
function usage()
{
	err   "usage: $0 <device type> <version> <module path>"
	fatal "   or: $0 --list - list available devices and versions"
}

function push()
{
	pushd $1 >/dev/null
}

function pop()
{
	popd >/dev/null
}

# Super-basic XML parsing.
# See http://stackoverflow.com/a/2608159
function rdom()
{
	local IFS=\>
	read -d \< key val
}

# Retrieves all available kernel header archives.
# args: $1 - marker
#       $2 - if non-empty use list mode
#       $3 - device search pattern (default .*)
#       $4 - version search pattern (default .*)
function get_header_paths()
{
	local marker="$1"
	local list_mode="$2"
	local dev_pat="${3:-.*}"
	local ver_pat="${4:-.*}"

	local pattern="^images/(${dev_pat})/(${ver_pat})/kernel_modules_headers"

	local last_marker=''

	while rdom; do
		local path="$val"

		if [[ "$key" = 'Key' ]]; then
			last_marker=$val

			[[ "$val" =~ $pattern ]] || continue

			local device="${BASH_REMATCH[1]}"
			local version="${BASH_REMATCH[2]}"

			if [[ -n "$list_mode" ]]; then
				echo $device $version
			else
				echo $path
			fi
		fi
	done <<<$(curl --silent "$files_url?marker=$marker")

	# If we have seen all of the available data then the last marker we've
	# seen will be empty, otherwise we need to recurse to retrieve the rest
	# of the data.
	[[ -z "$last_marker" ]] || get_header_paths "$last_marker" "$list_mode" "$dev_pat" "$ver_pat"
}

# List available devices and versions.
function list_versions()
{
	get_header_paths '' 'y' | while read device version path; do
		printf "%-30s %-30s\n" $device $version
	done
}

if [[ "$1" = "--list" ]]; then
	list_versions
	exit
elif [[ $# -lt 3 ]]; then
	usage
fi

device="$1"
version="$2"
module_dir="$3"

[[ -d "${module_dir}" ]] || fatal "ERROR: Cannot find module directory ${module_dir}"

path=$(get_header_paths '' '' "$device" "$version")
[[ -n "$path" ]] || fatal "Could not find headers for '$device' at version '$version', run $0 --list"

filename=$(basename $path)
url="$files_url/$path"

tmp_path=$(mktemp --directory)
push $tmp_path

if ! wget "$url"; then
	pop
	rmdir $tmp_path
	fatal "ERROR: Could not retrieve $url"
fi

tar -xf $filename --strip 1 || (rm $filename; fatal "ERROR: Unable to extract $tmp_path/$filename")
rm $filename
pop

push $module_dir
make -C "$tmp_path" M="$PWD" modules

rm -rf "tmp_path"
