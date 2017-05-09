#!/bin/bash

# Usage dialog for user
# Args:
#     $@ : command line arguments
# SideEffects:
#     Exits with status 1.
function usage {
    >&2 cat <<EOF
usage: `basename $0` SOURCE TARGET

Copy SOURCE files to TARGET where TARGET is on the Box.com.  If TARGET
does not exist, it is created.  lftp is used to non-recusively copy a
list of files. Time of execution is always reported.
EOF
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
	    -*)
		usage $@
		shift
		;;
	    *)
		shift
		;;
	esac
    done
}

checkargs $@

# get the last argument
target=${*: -1}
# get everything but the last argument
source=${*: 1:($#-1)}

# the command
time lftp  -e "set ftps:initial-prot \"\"; \
   set ftp:ssl-force true; \
   set ftp:ssl-protect-data true; \
   open ftps://ftp.box.com:990; \
   user tluchko@csun.edu; \
   mkdir -p $target; \
   mirror -R $source $target;\
   exit"
