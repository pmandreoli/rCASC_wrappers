#!/bin/bash

echo "<h1>Output Permutational Clustering</h1>" > $2
for filepath in `find "$1" -maxdepth 4 -mindepth 1`;
do
html_path=`echo "$filepath" | sed 's/.*_files\///'`
path=`basename "$filepath"` 


echo "<a href="$html_path">$path</a><br>" >> $2

done
