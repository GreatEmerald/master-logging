#!/bin/bash
# Script for comparing directories of Landsat imagery to make sure all packed files are processed as expected

# Make a list of processed (TIFF) tiles in a directory, $1="intermediary/cloud-free/peru/ndvi/*.tif"
for file in $1; do base=${file##*/}; echo "${base%_*}" >> /tmp/filelist.txt; done
# List archives that are not yet processed, $2="satellite/peru/"
find $2 -name "*.tar.gz" -print | grep -Fvf /tmp/filelist.txt
rm /tmp/filelist.txt
