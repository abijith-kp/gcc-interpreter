#!/bin/bash

## Author: Abijith K P
## Email Id: abijithkp@yahoo.co.in
## Program: gcc interpreter on top of gcc compiler

opt_t=0
opt_prompt="gcc> "
config=".gcc"
del_count=0
HEADER=
BODY=
TMP_BODY=
OPEN=
CLOSE=
TMP_PROG=
OUTPUT=

function intro() {
    echo -e "\ngcc interpreter on top of gcc compiler\n"
    echo -e "Version: 0.2\n"
}

function print_out() {
    ./$config/"a.out"
}

function run_stmnt() {
    stmnt=$@
    FLAG=0
    if test "$stmnt" = "" && test $del_count -gt 0; then
        head -n -$del_count $TMP_BODY > $BODY
        cp $BODY $TMP_BODY
        del_count=0
        opt_prompt="gcc> "
        cat $config/out
        rm -rf "$config"/{a.out,out}
        return
    elif [[ "$stmnt" =~ "#include "" "*"<"?\"?[a-zA-Z_-]+".h"?\"?">"? ]]; then
        FLAG=1
    fi
    if test "$FLAG" = "1"; then
        echo $stmnt >> $HEADER
    elif test $del_count -gt 0; then
        echo $stmnt >> $TMP_BODY
    else
        cp $BODY $TMP_BODY
        echo $stmnt >> $TMP_BODY
    fi

    cat $HEADER $OPEN $TMP_BODY $CLOSE > $TMP_PROG
    gcc -Werror $TMP_PROG -o "$config"/"a.out" >> "$config"/out 2>&1
    if ls $config | grep -x "a.out" > /dev/null; then
        ./$config/"a.out"
        cp $TMP_BODY $BODY
        rm -rf $config/{a.out,out}
        touch $config/out
        del_count=0
        opt_prompt="gcc> "
    else
        opt_prompt=".... "
        del_count=$[ $del_count + 1 ]
    fi
}

function init_val() {
    HEADER="$config"/header
    BODY="$config"/body
    TMP_BODY="$config"/tmp_body
    OPEN="$config"/open
    CLOSE="$config"/close
    TMP_PROG="$config"/tmp_prog.c
    rm -rf "$config"/{header,body,tmp_body,tmp_prog.c,a.out}
    touch "$config"/{header,body,tmp_body,tmp_prog.c}
}

function help() {
    cat <<END_HELP
Usage: $1 [-t] [-h]

 -t  enable Template mode
 -h  print this Help
 -v  Version info

END_HELP
}

function exit_prog() {
    echo -e "\nExiting... Bye...\n"
    exit 0
}

init_val
while getopts "tvh" opt; do
  case $opt in
    t ) opt_t=1;;
    h ) help $0
        exit 0;;
    v ) intro
        exit 0;;
    \?) printf "Invalid option: -"$opt", try $0 -h\n" >&2
        exit 1;;
  esac
done

while true; do
    read -r -p "$opt_prompt" CMD
    if [ "$CMD" == "exit" ]; then
        exit_prog
    fi
    run_stmnt $CMD
done
