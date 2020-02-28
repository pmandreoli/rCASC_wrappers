#!/bin/bash

echo "<h1 style=\"background-color:MediumSeaGreen;\"> Output COMET </h1>" > $2
for filepath in `find "$1" -maxdepth 3 -mindepth 1`;
do
html_path=`echo "$filepath" | sed 's/.*_files\///'`
path=`basename "$filepath"` 
if [[ ${path} != *"."* ]] ; then
path=$path" type: DIRECTORY" 
echo "<br><hr>" >> $2
fi

echo "<a href="$html_path">$path</a><br>" >> $2

done
