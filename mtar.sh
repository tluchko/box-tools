#! /bin/bash

# Usage dialog for user
# Args:
#     $@ : command line arguments
# SideEffects:
#     Exits with status 1.
function usage {
    >&2 cat <<EOF
usage: `basename $0` SOURCE TARGET

Multivolume tar wrapper.

Makes using multivolume tar files slightly easier.  

* Automatically applies a script to provide the next file in the
  archive.
* All other options passed through.

The subscript that names all of the volumes after the first appends
the volume number to the end, '-#'.

EOF

    #* Allows human readable values for volume size. (Not working yet.)
    #-L : Size of volumes in human readable format.  E.g., 1 (1 kb),
    #-1K (1 kb), 1M (1 MB), 1G (1 GB)

    exit 1
}

# checks the input arguments and calls the usage dialog if necessary.
# -h, --help, or any '-*' argument causes usage to be called.  A
# -minimum of two arguments are also necessary.
# Args:
#     $@ : command line arguments
# SideEffects:
#     Calls usage if arguments have problems
function checkargs {
    echo checkargs $#
    if [[ $# -lt 2 ]] ; then
	usage $@
    fi

    while [[ $# -ge 1 ]] ; do
	key=$1
	case $key in
	    -h|--help)
		usage $@
		shift
		;;
	    *)
		shift
		;;
	esac
    done
}

# appends new-volume-script flag with the script name to the supplied
# parameters
# Args:
#     $@ : any arguments
# Returns:
#     $@ with the new-volume-script flag
function add_new_volume_script {
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    flag="--new-volume-script=$DIR/new-volume-script.sh"
    echo $@ $flag
}

checkargs $@
command="tar `add_new_volume_script $@`"

echo "$command"
eval "$command"

