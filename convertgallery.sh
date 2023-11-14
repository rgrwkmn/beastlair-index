#!/bin/bash

input=${1%/}
output=${2%/}

echo "input $input";
echo "output $output";

if [[ ! -d $input ]]; then
	echo "input must be a directory";
	exit 1;
fi

if [[ ! -d $output ]]; then
	echo "making dir $output";
	mkdir "$output";
fi

if [[ ! -d $output/_gallery ]]; then
	echo "making dir $output/_gallery";
	mkdir "$output/_gallery";
fi

outputFolderName=$(echo $output | sed 's/^.\+\///')

if [[ ! -f $output/index.md ]]; then
	echo "adding default index.md";
	cat tmplt/default-index.md | sed "s/# TITLE/# $outputFolderName/" > $output/index.md;
fi

# convert to jpg
for f in $input/*.png ; do
	filename=${f#$input/};
	if [[ ! -f $output/_gallery/${filename%.png}.jpg ]]; then
		echo "process $filename > $output/_gallery/${filename%.png}.jpg";
		convert "$f" -quality 85 "$output/_gallery/${filename%.png}.jpg";
		convert "$f" -resize 512x512 -quality 85 "$output/_gallery/${filename%.png}-small.jpg" ;
		cp "$f" $output/_gallery/;
	fi
done
