## Author: Abijith K P
## Email Id: abijithkp@yahoo.co.in
## Program: gcc interpreter on top of gcc compiler

#!/bin/bash

HEADERLEN=1
PREVOUTPUT=""
GLOBALCMD=""
GLOBALNUM=0

function intro() {
	echo -e "\ngcc interpreter on top of gcc compiler\n"
}

## a function that sanitises the input command and checks wheather the input is a function, header file or statement etc and add them accordingly to the file. This can be implemented using a parser made in lex/yacc.
function addStmnt() {
        FILE=$1   ## filename to be appended into/ compiled
        shift     ## to shift the input arguements
        CMD="$@"  ## remaining arguements will be the new command to be appended
        GLOBALCMD="$CMD"

        if [ "$FILE" == "tmpFile.c" ]
        then
                echo "$CMD" >> $FILE
        else
                rm -f tmp.c
                touch tmp.c
                TMPHEADER=-1
                FLAG=0

                ## adding code from tmpFileTemplate.c to tmp.c

                ##adding header files
                if [[ "$CMD" =~ "#include "" "*"<"[a-zA-Z]+".h>" ]]
                then
                        TMPHEADER=$HEADERLEN
                        HEADERLEN=$(expr $HEADERLEN + 1)
                        FLAG=1
                fi
                
                TOPPARTN=$(expr $(cat $FILE | wc -l) - 1) ## number of lines to be copied

                while read -r lines
                do
                        if [ $TMPHEADER -eq 0 ]
                        then
                                echo "$CMD" >> tmp.c
                                TMPHEADER=$(expr $TMPHEADER - 1)
                                ## continue
                        elif [ $TMPHEADER -gt 0 ]
                        then 
                                TMPHEADER=$(expr $TMPHEADER - 1)
                        fi

                        if [ $TOPPARTN -eq 0 ]
                        then                
                                break
                        fi
                        echo "$lines" >> tmp.c
                        TOPPARTN=$(expr $TOPPARTN - 1)
                done < $FILE

                if [ $FLAG -eq 0 ]
                then
                        echo "$CMD" >> tmp.c   ## adding the input command
                fi

                echo "}" >> tmp.c
                ## mv tmp $1

####### this was done because: taking the top part excluding the "}" at the bottom and adding the input command and add the "}" bracket back and compile for result.
                ## topPart=$(head -n"$(expr $(cat $1 | wc -l) - 1)" $1)
                ## echo -e $topPart"\n$2""\n}"
                ## echo $topPart"\n$2""\n}" > $1
        fi
}

function checkOut() {
        if [ ! -f $2 ]
        then
                cat $1
                return
        fi

        len1=$(cat $1 | wc -l)
        len2=$(cat $2 | wc -l)

        cat $1 | tail -n$(expr $len1 - $len2 + 1) > tmp1
        line1=$(tail -n1 $2)
        line2=$(head -n1 tmp1)
        
        if [ ! -z "$line2" ]
        then
                out=$(echo $line1 | sed -e "s/$line2//")
        else
                out=""
        fi

        if [ ! -z $out ]
        then
                echo -e $out
        fi
        rm tmp1
        cat $1 | tail -n$(expr $len1 - $len2)
}

## checkCont returns true if the current input string is the ending of a function definition or function call.
##              ie, the point at which all the opened brackets are clossed
function checkCont() {
         echo "sfdsfdsfdsfd"
         NUM=$(expr $(echo -n $a | grep -o -G "[({\[]" | wc -m) / 2)
         RNUM=$(expr $(echo -n $a | grep -o -G "[)}\]]" | wc -m) / 2)
         GLOBALNUM=$(expr $GLOBALNUM + $NUM - $RNUM)
         
         if [ $GLOBALNUM == 0 ]
         then
                 return 0
         else
                 return 1
         fi
}

function run() {
        gcc $1
        ## echo "sfdsfdsfdsfd"i

        if [ -f a.out ]  ## new a.out file will only be created if the compilation is successful
        then             ## if successfu<F5>l
                mv $1 $2
                ./a.out > tmpOut
                checkOut tmpOut prevOutput
                cat tmpOut > prevOutput
                ## echo -e "\n" >> prevOutput                
                rm -f a.out tmpOut
                PROMPT="gcc> "
                ## echo "00000000sfdsfdsfdsfd"
        elif [ checkCont ]
        then
                ## echo "1111111sfdsfdsfdsfd"
                PROMPT=".... "
        else             ## else rm the tmp.c file which contains the errornous code and continue with the old one
                ## echo "2222222sfdsfdsfdsfd"
                rm $1
        fi
}

#####################################################################
#####################################################################
#####################################################################
##################### program starts here ########################### 

## check if rlwrap is installed
if [[ $(find /usr/bin/ -name "rlwrap") == "" ]]
then
        echo "ERROR: Install rlwrap before running gcc-interpreter!!!\n"
        exit
fi

intro   ## for giving introduction message

ARG=$1
TMPFILE=""
PROMPT="gcc> "

rm -f prevOutput

if [ -z $ARG ]
then
        TMPFILE="tmpFile.c"   ## initially nothing will be there in the file
        rm -f $TMPFILE
        touch $TMPFILE
elif [ "$ARG" == "-template" ]
then
        TMPFILE="tmpFileTemplate.c"
        rm -f $TMPFILE
        cp $TMPFILE".backup" $TMPFILE
	## initially a small template including stdio.h and void main statement will be there in the file
else
        echo -e "\nERROR: Unknown arguements\nexiting...\n"
        exit
fi

while true  ## for runnning it infinitely until exit is given
do
        read -r -p "$PROMPT" CMD   ## read the input command

        if [ "$CMD" == "exit" ]
        then
                echo -e "\nExiting... Bye...\n"
                exit
        elif [ "$CMD" == "" ]
        then
                ## echo -e "\n"
                continue
        fi
        
        ## to check for the pattern in the input
        addStmnt $TMPFILE $CMD          ## to add new statements into the internal program
        run "tmp.c" $TMPFILE            ## run and check for error during compilation

        ## echo -e "\n"
done
