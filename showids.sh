#!/bin/bash


###
# showids.sh, script to show a sorted list of used {U,G}IDs on the local node
# of Mac OS X 10.3+ systems that include the dscl(1) commmand line tool.
# Copyright (c) 2007 Juan Manuel Palacios <jmpp@macports.org>
# $Id$
###


###
# TODO:
# 1) provide support for nodes other than the local;
# 2) find a not so involved way of supporting getopt_long(3) style long command
#    line options for their short style equivalents (e.g. --users for -u, --groups
#    for -g, etc.);
# 3)
# 
###

usage () {
    echo -e "\nUsage: $0 { -u | -g } [ -v ] [ -h ]:\n"
    echo -e "\t-u: show used UIDs;"
    echo -e "\t-g: show used GIDs;"
    echo -e "\t-r: sort {U,G}IDs in reverse order;"
    echo -e "\t-v: verbose mode;"
    echo -e "\t-h: print this help message and exit.\n"
}


(($# < 1)) && { usage; exit 1; }
while getopts "ugrvh" ARG; do
    case ${ARG} in
        u)
            [ -n "${TYPE}" ] && { usage && exit 1; }
            TYPE=Users
            KEY=UniqueID
        ;;
        g)
            [ -n "${TYPE}" ] && { usage && exit 1; }
            TYPE=Groups
            KEY=PrimaryGroupID
        ;;
        r)
            SORT_TYPE="-r"
        ;;
        v)
            VERBOSE=1
        ;;
        h)
            usage && exit 0
        ;;
        \?|*)
            usage && exit 1
        ;;
    esac
done
[ -z "${TYPE}" ] && { usage && exit 1; }
SORT_TYPE="-n ${SORT_TYPE}"

for id in $(dscl . -list /${TYPE} ${KEY} | awk '{print $2}' | sort ${SORT_TYPE} | uniq -u); do {
    [ -n "${VERBOSE}" ] && echo -n "$(dscl . -search /${TYPE} ${KEY} ${id} | awk '{print $1}'): "
    echo ${id}
}; done && exit 0
