#!/bin/bash
# Script for repacking ESPA .tar.gz files into 7Z files to save storage space
# Run from the directory in which to save files and pass "*" in quotes always
# Adjust the algorithm to LZMA2 if you need it to be faster for a bit worse compression
for file in $1; do
    basefile=${file##*/}
    basedir=${basefile%.tar.gz}
    mkdir $basedir
    tar -xzf $file -C $basedir
    7z a -m0=PPMd -mx=9 $basedir.7z $basedir/*
    rm -r $basedir
    rm $file
done
