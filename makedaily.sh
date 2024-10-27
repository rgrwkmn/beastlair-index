#!/bin/bash
echo "make daily";

cd /home/robeast/beastlair-index;

filename=$(python3 comfy-api.py);
filepath="../stable-diffusion/ComfyUI/output/DAILY/$filename"

echo $filepath;

rm ./public/Daily/_gallery/*

# convert to jpg
echo "process $filename";
convert $filepath -quality 85 "public/Daily/_gallery/${filename%.png}.jpg";
convert $filepath -resize 512x512 -quality 85 "public/Daily/_gallery/${filename%.png}-small.jpg" ;
cp $filepath "public/Daily/_gallery/";

ls public/Daily/_gallery

node gen.js
