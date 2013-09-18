#!/bin/bash

function intro() {
	echo -e "\nA simple gcc compiler\n"
}

## a function that sanitises the input command and checks wheather the input is a function, header file or statement etc and add them accordingly to the file. This can be implemented using a parser made in lex/yacc.
function addStmnt() {
        file=$1   ## filename to be appended into/ compiled
        shift     ## to shift the input arguements
        cmd="$@"  ## remaining arguements will be the new command to be appended

        if [ "$file" == "tmpFile.c" ]
        then
                echo "cmd" >> $file
        else
                rm -f tmp.c
                touch tmp.c
               
                ## adding code from tmpFileTemplate.c to tmp.c
                topPartN=$(expr $(cat $file | wc -l) - 1) ## number of lines to be copied
                while read -r lines
                do
                        if [ $topPartN -eq 0 ]
                        then
                                break
                        fi
                        echo "$lines" >> tmp.c
                        topPartN=$(expr $topPartN - 1)
                done < $file
                
                echo "$cmd" >> tmp.c   ## adding the input command
                echo "}" >> tmp.c
                ## mv tmp $1
####### this was done because: taking the top part excluding the "}" at the bottom and adding the input command and add the "}" bracket back and compile for result.
                ## topPart=$(head -n"$(expr $(cat $1 | wc -l) - 1)" $1)
                ## echo -e $topPart"\n$2""\n}"
                ## echo $topPart"\n$2""\n}" > $1
        fi
}

function run() {
        gcc $1
        if [ -f a.out ]  ## new a.out file will only be created if the compilation is successful
        then             ## if successful
                mv $1 $2
                ./a.out
                rm -f a.out
        else             ## else rm the tmp.c file which contains the errornous code and continue with the old one
                rm $1
        fi
}

##################### program starts here ###########################

intro   ## for giving introduction message

arg=$1
tmpFile=""

if [ -z $arg ]
then
        tmpFile="tmpFile.c"   ## initially nothing will be there in the file
        rm -f $tmpFile
        touch $tmpFile
elif [ "$arg" == "-template" ]
then
        tmpFile="tmpFileTemplate.c"
        rm -f $tmpFile
        cp $tmpFile".backup" $tmpFile
	## initially a small template including stdio.h and void main statement will be there in the file
else
        echo -e "\nERROR: Unknown arguements\nexiting...\n"
        exit
fi

while true  ## for runnning it infinitely until exit is given
do
        read -r -p "gcc> " cmd   ## read the input command

        echo $cmd
        if [ "$cmd" == "exit" ]
        then
                echo -e "\nExiting... Bye...\n"
                exit
        fi

        addStmnt $tmpFile $cmd          ## to add new statements into the internal program
        run "tmp.c" $tmpFile            ## run and check for error during compilation
done
