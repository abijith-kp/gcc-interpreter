cmd=""
rm -f tmp main.c
touch tmp
touch main.c
prompt=">>> "

while (( 1 ))
do
        read -e -p "$prompt" cmd
        
        if [ "$cmd" == "exit" ]
        then
                break
        fi

        echo -e $cmd >> tmp
        out=$(./CLang < tmp)
        
        if [ -z "$out" ]
        then
                cat tmp >> main.c
                cat main.c
                rm tmp
                touch tmp
                prompt=">>> "
        else
                prompt="... "
        fi

done
