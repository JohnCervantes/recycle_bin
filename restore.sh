#!/bin/bash



function restore_recursively {

# Check all the lines in restore.info that has the word given by the user
cat $HOME/.restore.info | grep $2  | while read line
        do
                #get the name of the folder where this file was placed
                dir_name=$(echo $line | cut -d ':' -f2 |rev| cut -d '/' -f3 | rev)

                # get the path where the file will be restored
                restore_path=$(echo $line | cut -d ':' -f2 )

                # check if the user input matches the folder that we want to restore
                if [ "$2" == "$dir_name" ] ;
                        then
                        abs_path=$( echo $line | cut -d ':' -f2)
                        recycle_file_name=$( echo $line | cut -d ':' -f1)
                        base_name=$(basename $abs_path)

                        if [ -e $HOME/recyclebin/$recycle_file_name ] ;
                                then
                                mkdir --parents $restore_path ; mv $HOME/recyclebin/$recycle_file_name $_
                                #remove the appropriate entry in .restore.info
                                grep -v $line $HOME/.restore.info > temp.txt
                                mv temp.txt $HOME/.restore.info
                        fi
                fi
        done
        exit 0
}


while getopts r opt
do
     case $opt in
        r) restore_recursively $@ ;;
     esac
done



if [ $# -eq '0' ] ;
        then echo 'ERROR: No filename is provided'
        exit 1
elif [ $# -eq '1' ] ;
        then
        if [[ -e $HOME/recyclebin/$1 ]]  ;
                then
                #get the path from .restore.info where the file will get restored
                abs_path=$(cat $HOME/.restore.info | grep $1 | cut -d ":" -f2)
                #the lines that has to be remove in .restore.info
                remove_line=$(cat $HOME/.restore.info | grep $1)

                if [[ -e $abs_path ]] ;
                        then
                        read -p ' File with the same name already exist in the target path. Do you want to overwrite? y/n': answer
                        first_letter=${answer:0:1}
                        if [[ $first_letter == 'Y' || $first_letter == 'y' ]] ;
                                then
                                rm $abs_path
                                mv $HOME/recyclebin/$1 $abs_path
                                grep -v $remove_line $HOME/.restore.info > temp.txt
                                mv temp.txt $HOME/.restore.info
                        elif [[ $first_letter == 'N' || $first_letter == 'n' ]] ;
                                then :
                        else
                                echo 'ERROR:Invalid response'
                                exit 1
                        fi
                else
                        mv $HOME/recyclebin/$1 $abs_path
                        grep -v $remove_line $HOME/.restore.info > temp.txt
                        mv temp.txt $HOME/.restore.info
                fi
        else
                echo 'ERROR: File does not exist'
                exit 1
        fi
        exit 0
fi
