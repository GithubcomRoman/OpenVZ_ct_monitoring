#!/bin/sh
# vzubc - a tool for displaying OpenVZ user beancounters.
# Copyright (C) 2011-2012, Parallels, Inc. All rights reserved.
# Licensed under GNU GPL v2 or later version.

umask 0077


CTIDS=""
FILE=""
WATCH=""
ARGV=$*

# For vzlist to work, make sure /usr/sbin is in $PATH
if ! echo ":${PATH}:" | fgrep -q ':/usr/sbin:'; then
        PATH="/usr/sbin:$PATH"
fi

while test $# -gt 0; do
        case $1 in
*)
                # Try to convert CT name to ID
                ID=$(vzlist -H -o ctid "$1" 2>/dev/null)
                if test $? -eq 0; then
                        CTIDS=$(echo $CTIDS $ID)
                else
                        CTIDS=$(echo $CTIDS $1)
                fi
                ;;
        esac
        shift
done



chk_zeroarg() {
        if test -z "$2"; then
                echo "Error: option $1 requires an argument" 1>&2
                usage 1
        fi
}


if test -n "$thr" -a -z "$color" -a -z "$quiet"; then
        echo "Error: -qh and -qm only make sense with --quiet or --color"
usage 1
fi

if test -z "$FILE"; then
        # No file name given, substitute sane default
        FILE=/proc/bc/resources
        test -f $FILE || FILE=/proc/user_beancounters
fi

# Test that input file is readable
if test "$FILE" != "-"; then
        cat < "$FILE" > /dev/null || exit 1
fi

# Relative/incremental mode preparations and sanity checks
if test -n "$relative" -o -n "$incremental"; then
        # Create dir if needed
        if ! test -d $STOREDIR; then
                mkdir $STOREDIR || exit 1
        fi
        # Check we can write to it
        touch $STOREDIR/ubc.test || exit 1
        rm -f $STOREDIR/ubc.test || exit 1
fi

# Re-exec ourselves under watch
test -z "$watch" || exec watch $WATCH_ARGS -- $0 $ARGV -W

cat $FILE | LANG=C awk -v CTIDS=" ${CTIDS} " -v quiet="$quiet" \
        -v qheld="$Q_HELD" -v qmaxheld="$Q_MAXHELD" \
        -v rel="$relative" -v storedir="$STOREDIR" \
        -v inc="$incremental" $AWK_COLORS \
'

#-----formula 
function hr(res, v) {
        if ((v == 9223372036854775807) || (v == 2147483647) || (v == 0))
                return "- ";
        i=1
        if ((res ~ /pages$/) && (v != 0)) {
                v = v*4; i++
        }
        while (v >= 1024) {
 v=v/1024
                i++

        }
        fmt="%d%c"
        if (v < 100)
                fmt="%.3g%c"
        return sprintf(fmt, v, substr(" KMGTPEZY", i, 1))
}

function dp(p, d) {
        if ((d == 0) || (d == 9223372036854775807) || (d == 2147483647))
                return "- "
        r = sprintf("%.1f", p / d * 100);
        fmt="%d"
        if (r < 10)
                fmt="%.1g"
        r = sprintf(fmt, r)
        if (r == 0)
                return "- "
        return r "%"
}

function important(id, held, maxheld, barrier, limit, failcnt) {
        if (failcnt > 0)
                return 2;
        if (barrier == 0)
                barrier = limit;
        if ((barrier == 9223372036854775807) || (barrier == 2147483647))
                return 0;
        if (held > barrier)
                return 2;
        if (held > barrier * qheld)
                return 1;
        if (maxheld > barrier * qmaxheld)
                return 1;
        return 0;
}


BEGIN {
        if (qheld > 1)
                qheld /= 100
if (qmaxheld > 1)
                qmaxheld /= 100
        if (qheld > qmaxheld)
                qheld=qmaxheld
        bcid=-1
}
/^Version: / {
        if ($2 != "2.5") {
                print "Error: unknown version:",
                        $2 > "/dev/stderr"
                exit 1
        }
        next
}
/^[[:space:]]*uid / {
        next
}
/^[[:space:]]*dummy/ {
        id=""
        next
}
/^[[:space:]]*[0-9]+:/ {
        header=""
        bcid=int($1)
        if ((CTIDS !~ /^[ ]*$/) && (CTIDS !~ " " bcid " ")) {
                skip=1
                next
        }
        skip=0

        #prepare_header()

        id=$2
        held=$3
        maxheld=$4
        barrier=$5
        limit=$6
        failcnt=$7
}
/^[[:space:]]*[a-z]+/ {
        id=$1
        held=$2
        maxheld=$3
barrier=$4
        limit=$5
        failcnt=$6
}
((id!="") && (!skip)) {
        if ((bcid < 0) && (rel || inc)) {
                print "Error: can not use relative/incremental" \
                        " modes: BCID is unknown" > "/dev/stderr"
                exit 1
        }
        newfc=failcnt
        store=storedir "/ubc." bcid "." id
        if ( (rel) && (failcnt > 0) ) {
                f_file=store ".failcnt"
                getline oldfc < f_file
                if (oldfc > 0)
                        failcnt=failcnt-oldfc
                if (failcnt < 0)
                        failcnt=newfc
        }
        save_held=0
        dh=0
        if (inc) {
                d_held="       "
                h_file=store ".held"
                save_held=1
                getline o_held < h_file
                if (o_held >= 0) {
                        dh=held - o_held
                        sig="+"
                        if (dh < 0) {
                                dh=-dh; sig="-"
                        }
                        if (dh != 0)
                                d_held = sprintf("%7s", sig hr(id, dh))
                        else
                                save_held=0
                }
        }
        imp=important(id, held, maxheld, barrier, limit, failcnt)
        if ((quiet) && (!imp) && (dh==0)) {
                id=""
                next
 }
        if (header != "") {
                if (printed)
                        print ""
                print header
                printed=1
                header=""
        }
        if (imp == 2)
                printf c_e;
        else if (imp == 1)
                printf c_w;
        else
                printf c_n;
#       printf "%13s|%5s%s %4s %4s|%5s %4s %4s|%5s|%5s| %5s\n" c_n,
printf "%13s | %5s%s %4s %4s | %5s %4s %4s | %5s | %5s | %5s\n" c_n,
                id,
                hr(id, held), d_held, dp(held, barrier), dp(held, limit),
                hr(id, maxheld), dp(maxheld, barrier), dp(maxheld, limit),
                hr(id, barrier), hr(id, limit), hr("", failcnt)

        if ( (rel) && (newfc > 0) ) {
                print newfc > f_file
                close(f_file)
        }
        if (save_held) {
                print held > h_file
                close(h_file)
        }
        id=""
}
END {
#       if (printed)
#               printf "----------------------------------------------------------------%s\n", inc ? "-------" : ""
#printf hr(id, held)
}
'

				