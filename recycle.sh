#!/bin/bash



# recycle_with_prompt_display is called when the user use either -vi or -iv options
function recycle_with_prompt_display {
        for i in $@;
                do
                        if [[ -e $i && $i != 'recycle' ]] ;
                                then
                                if [[ -d $i  ]] ;
                                        then echo 'ERROR: Directory name provided'
                                        exit 1
                                elif [[ -f $i  ]] ;
                                        then
                                        #get the absolute path
                                        abs_path=$(echo $PWD/$i)
                                        #store inode in inode variable
                                        inode=$(ls -i $i | cut -d " " -f1)
                                        #store filename in name variable. rev is use here to reverese the path to and cut the first field which is the filename
                                        name=$(ls -i $i | rev | cut -d "/" -f1 | rev)
                                        read -p "remove regular file '$name' ?": answer
                                        first_letter=${answer:0:1}
                                        if [[ $first_letter == 'Y' || $first_letter == 'y' ]] ;
                                                then
                                                mv "$i" "$HOME/recyclebin/${name}_${inode}"
                                                echo "removed '${name}_${inode}'"
                                                echo "${name}_${inode}:$abs_path" >> $HOME/.restore.info
                                        else
                                                :
                                        fi
                                fi
                        elif [ $i == 'recycle' ] ;
                                then echo 'Attempting to delete recycle - operation aborted'
                                exit 1
                        else
                                echo 'ERROR: The file does not exist'
                                exit 1
                        fi
        done
        exit 0
}


# recycle_display is called when the user use -v option
function recycle_display {
        for i in $@;
                do
                        if [[ -e $i && $i != 'recycle' ]] ;
                                then
                                if [[ -d $i  ]] ;
                                        then echo 'ERROR: Directory name provided'
                                        exit 1
                                elif [[ -f $i  ]] ;
                                        then
                                        #get the absolute path
                                        abs_path=$(echo $PWD/$i)
                                        #store inode in inode variable
                                        inode=$(ls -i $i | cut -d " " -f1)
                                        #store filename in name variable. rev is use here to reverese the path to and cut the first field which is the filename
                                        name=$(ls -i $i | rev | cut -d "/" -f1 | rev)
                                        mv "$i" "$HOME/recyclebin/${name}_${inode}"
                                        echo "removed '${name}_${inode}'"
                                        echo "${name}_${inode}:$abs_path" >> $HOME/.restore.info
                                fi
                        elif [ $i == 'recycle' ] ;
                                then echo 'Attempting to delete recycle - operation aborted'
                                exit 1
                        else
                                echo 'ERROR: The file does not exist'
                                exit 1
                        fi
        done
        exit 0
}


# recycle_without_prompt is called when no option is entered
function recycle_without_prompt {
        for i in $@;
                do
                        if [[ -e $i && $i != 'recycle' ]] ;
                                then
                                if [[ -d $i  ]] ;
                                        then echo 'ERROR: Directory name provided'
                                        exit 1
                                elif [[ -f $i  ]] ;
                                        then
                                        #get the absolute path
                                        abs_path=$(echo $PWD/$i)
                                        #store inode in inode variable
                                        inode=$(ls -i $i | cut -d " " -f1)
                                        #store filename in name variable. rev is use here to reverese the path to and cut the first field which is the filename
                                        name=$(ls -i $i | rev | cut -d "/" -f1 | rev)
                                        mv "$i" "$HOME/recyclebin/${name}_${inode}"
                                        echo "${name}_${inode}:$abs_path" >> $HOME/.restore.info
                                fi
                        elif [ $i == 'recycle' ] ;
                                then echo 'Attempting to delete recycle - operation aborted'
                                exit 1
                        else
                                echo 'ERROR: The file does not exist'
                                exit 1
                        fi
        done
}

# recycle_directory is called  when the user use -r option

function recycle_directory {
for i in $@;
        do
                if [[ -e $i && $i != 'recycle' && -d $i ]] ;
                        then
                        #get the absolute path of the directory
                        dir_abs_path=$(echo $PWD/$i)

                        for file in $dir_abs_path/*;
                                do
                                        #store inode in inode variable
                                        inode=$(ls -i $file | cut -d " " -f1)
                                        #store filename in name variable. rev is use here to reverese the path to and cut the first field which is the filename
                                        name=$(ls -i $file | rev | cut -d "/" -f1 | rev)
                                        mv "$file" "$HOME/recyclebin/${name}_${inode}"
                                        echo "${name}_${inode}:$file" >> $HOME/.restore.info
                                done
                        #final step is to remove the directory once all the files has been deleted
                        rm -r $dir_abs_path
                fi
        done
}


# recycle_with_prompt is called when the user use -i option
function recycle_with_prompt {
        for i in $@;
                do
                        if [[ -e $i && $i != 'recycle' ]] ;
                                then
                                if [[ -d $i  ]] ;
                                        then echo 'ERROR: Directory name provided'
                                        exit 1
                                elif [[ -f $i  ]] ;
                                        then
                                        #get the absolute path
                                        abs_path=$(echo $PWD/$i)
                                        #store inode in inode variable
                                        inode=$(ls -i $i | cut -d " " -f1)
                                        #store filename in name variable. rev is use here to reverese the path to and cut the first field which is the filename
                                        name=$(ls -i $i | rev | cut -d "/" -f1 | rev)
                                        read -p "remove regular file '$name'?": answer
                                        first_letter=${answer:0:1}
                                        if [[ $first_letter == 'Y' || $first_letter == 'y' ]] ;
                                                then
                                                mv "$i" "$HOME/recyclebin/${name}_${inode}"
                                                echo "${name}_${inode}:$abs_path" >> $HOME/.restore.info
                                        else
                                                :
                                        fi
                                fi
                        elif [ $i == 'recycle' ] ;
                                then echo 'Attempting to delete recycle - operation aborted'
                                exit 1
                        else
                                echo 'ERROR: The file does not exist'
                                exit 1
                        fi
        done
        exit 0
}



function optFunc() {
i=false
v=false
r=false

while getopts :ivr opt
do
        case $opt in
        i) i=true ;;
        v) v=true ;;
        r) r=true ;;
        \?) echo "$OPTARG is an invalid option"
        exit 1 ;;
        esac
done
}

function option_handler() {


if [[ $i == 'true' && $v == 'false'  ]] ;
        then
        recycle_with_prompt $@
fi
if [[ $v == 'true' && $i == 'false'  ]] ;
        then
        recycle_display $@
fi
if [[ $v == 'true'  && $i == 'true' ]] ;
        then
        recycle_with_prompt_display $@

fi
if [ $r == 'true' ] ;
        then
        recycle_directory $@

fi
exit 1
}


# BUG NEEDS TO BE COMMENTED WHEN NOT PASSING OPTIONS !
#optFunc $*
#shift $[ OPTIND - 1 ]
#option_handler $*


if [ -e $HOME/recyclebin ] ;
        then
        if [ $# -eq '0' ] ;
                then echo 'ERROR: No filename is provided'
        elif [ $# -ge '1' ] ;
                then recycle_without_prompt $@
        fi
else
        mkdir $HOME/recyclebin
fi
