#!/bin/bash

#i=0
#while [ $i -le 25 ]; do
#       i=$((i+1))
#       echo ""
#done
set -f #x

Usage(){
        echo "
Usage: files-arranger.sh [OPTION]  ArrangeDescriptionFile SourceDirectory
Description:
files-arranger.sh will create new directory 'ArrangedSourceDirectoryN' in the SourceDirectory unless -d option is used. There will be all files of SourceDirectory arranged in format given in ArrangeDescriptionFile
Options:
 -r - to get files also from all SourceDirectory subdirectories
 -d 'directory' - to place the result of the work in the given directory
      instead of SourceDirectory, given directory must be empty or nonexistent
 -o - to make directory 'other' for theese files, that did not match anything
 -h - to show this page
ArrangeDescriptionFile format:
 /dirA  regexSpecificForDirA
 /dirA/subdirB/ regexToFilterResultsOf'regexpSpecificForDirA'
 /dirA/subdirB/subdirC  ...
where each regexp specifies, what files will be present here
"
}
Fail(){ Usage; exit 1; }
Help(){ Usage; exit 0; }

descFile=""
sourceDir=""
recurse=""
other=0
realDestDir=""
destDir=""

SetTreeForDir(){        #$1 = matching, $2 = ammount of "/"
        cat $descFile | grep '^\(/[^/]*\)\{'"$2"'\}$' | grep "$1" |
        while read dir regex; do
                mkdir $destDir$dir
                echo $regex >$destDir$dir/.regex
                SetTreeForDir "$dir" $(($2+1))
        done
}

Copy(){         #$1 = sourceDir, $2 = filename, $3 = currDir, $4 = command
        ( cd $3 && ls -l ) | grep "^d" | tr -s " " | cut -f9 -d" " |
        while :; do
                if ! read dir; then
                        eval "$4"
                        break
                fi
                if ! [ -z $(echo "$2" | grep $(cat $3/$dir/.regex)) ]; then
                        Copy "$1" "$2" "$3/$dir" 'cp "$1/$2" "$3/$2"'
                        break
                fi
        done
}

if [ $# -le 2 ]; then Fail; fi
if [ $1 = -h ]; then Help; fi
while [ $# -gt 2 ]; do
        case $1 in
                -r) recurse="R";;
                -d) shift 1; realDestDir=$1;;
                -o) other=1
        esac
        shift 1
done
if ! [ -f $1 ]; then echo "ArrangeDescriptionFile ($1) does not exist"; exit 1; fi
descFile="$1"
if ! [ -d $2 ]; then echo "SourceDirectory ($2) does not exist"; exit 1; fi
sourceDir="$2"
if [ -z realDestDir ]; then
        N=1
        while [ -e "$2/Arranged$2$N" ]; do
                N=$((N+1))
        done
        realDestDir="$2/Arranged$2$N"
fi
destDir="$realDestDir-Chudacec_arranger_$$"
mkdir "$destDir"
if ! [ $(: | (cd $destDir && ls -l) | wc -l ) -eq 1 ]; then
        echo "Destination directory is not empty."
        exit 1
fi
SetTreeForDir ".*" "1"
if ! [ $other -eq 0 ]; then
        mkdir "$destDir/others"
        echo ".*" > "$destDir/others/.regex"
fi
sTeckou="."
(cd "$sourceDir" && ls -lA$recurse) | tr -s " " | cut -f9 -d" " |
while read line; do
        if [ -z $line ]; then
                :
        elif [ -z $( echo $line | grep ":$") ]; then
                if [ -z $( echo $line | grep "Chudacec_arranger_$$") ]; then
                        Copy "$sourceDir/$sTeckou" "$line" "$destDir" ":"
                fi
        else
                sTeckou=`echo "$line" | grep -o "^[^:]*"`
        fi
done
(cd "$destDir" && ls -laR) | grep ":$" |
while read line; do
        line=`echo $line | grep -o "^[^:]*"`
        if [ -e "$destDir/$line/.regex" ]; then
                rm "$destDir/$line/.regex"
        fi
done
mv "$destDir" "$realDestDir"
