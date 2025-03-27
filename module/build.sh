#!/usr/bin/env bash

. include/logging

set -o errexit
set -o pipefail

readonly script_name=$(basename "${0}")

usage() {
	cat <<EOF
Usage: ${script_name} [OPTIONS]
		-i Source directory (default to ./src)
		-o Output directory (default to ./out)
		-v balenaOS version (mandatory)
		-s BalenaCloud slug name (mandatory)
		-h Display usage
EOF
}

fetch_headers()
{
	local slug="${1}"
	local version="${2}"
	local files_url="https://files.balena-cloud.com"
	local esr_pattern="^[1-3][0-9]{3}\.(1|01|4|04|7|07||10)\.[0-9]*(.dev|.prod)?$"
	local image_path="images"
	local filename
	local url

	if [[ ${version} =~ ${esr_pattern} ]]; then
		image_path="esr-images"
	fi

	url="${files_url}/${image_path}/${slug}/${version//+/%2B}/kernel_modules_headers.tar.gz"
	filename=$(basename "$url")
	tmp_path=$(mktemp --directory)

	# See if the header files are already provided
	if [ -f "/usr/src/app/${filename}" ]; then
		cp "/usr/src/app/${filename}" "${tmp_path}"
	else

		if ! wget --quiet -P "$tmp_path" $(echo "$url" | sed -e 's/+/%2B/g'); then
			fail "Could not find headers for '$slug' at version '$version'"
		fi
	fi

	if [ ! -f "$tmp_path/$filename" ]; then
		fail "Could not find headers for '$slug' at version '$version'"
	fi

	cd "$tmp_path"
	# Count paths to strip by looking for .config and counting forward slashes
	strip_depth=$(tar tf ${filename} | grep "/\.config$" | tr -dc / | wc -c)
	if ! tar -xf $filename --strip $strip_depth; then
		rm -rf "$tmp_path"
		fail "Unable to extract $tmp_path/$filename."
	fi
	/usr/src/app/workarounds.sh "${slug}" "${version}" "${tmp_path}"
	echo "${tmp_path}"
}

build_module() {
	local headers_dir="${1}"
	local output_dir="${2}"

	mkdir -p "${output_dir}"
	cd "${output_dir}"
	make -C "${headers_dir}" modules_prepare
	make -C "${headers_dir}" M="$PWD" modules
	rm -rf "$headers_dir"
}

main() {
	local src_dir=
	local output_dir=
	local os_version="${OS_VERSION}"
	local slug=

	## Sanity checks
	if [ ${#} -eq 0 ] ; then
		usage
		exit 1
	else
		while getopts "hi:o:v:s:" c; do
			case "${c}" in
				i) src_dir="${OPTARG:-}";;
				o) output_dir="${OPTARG:-}";;
				v) os_version="${OPTARG:-}";;
				s) slug="${OPTARG:-}";;
				h) usage;;
				*) usage;exit 1;;
			esac
		done

		# Sanity checks
		[ -z "${src_dir}" ] && fail "No module source directory provided"
		[ -z "${output_dir}" ] && fail "No output directory provided"
		[ -z "${os_version}" ] && fail "No OS versions specified"
		[ -z "${slug}" ] && fail "No slugs specified"

		output_dir="${output_dir}/${src_dir}_${slug}_${os_version}"
		info "Building source from ${src_dir} into ${output_dir} for:
			OS versions: ${os_version}
			Device types: ${slug}"

		rm -rf "$output_dir"
		mkdir -p "$output_dir"
		cp -dR "$src_dir"/* "$output_dir"

		build_module $(fetch_headers "${slug}" "${os_version}") "${output_dir}"
	fi
}

main "${@}"
