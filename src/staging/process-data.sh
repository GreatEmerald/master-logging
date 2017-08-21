#!/bin/sh
# Processing chain script for the thesis analysis itself.
# Contains environment-specific items, so this is just for reference.

# Mask clouds in Guyana 2014
# Using -p "LE0723105620??*" or "LC08??????2017*" is recommended, because that's a lot of disk space that it uses
Rscript landsat-mask-clouds.r -i ../data/satellite/Guyana2014 -o ../data/intermediary/cloud-free/Guyana2014 -m /userdata2/tmp/
Rscript landsat-mask-clouds.r -i ../data/satellite/Peru/ -o ../data/intermediary/cloud-free/Peru/ -m /userdata2/tmp/ -t 10

# Make extents equal
Rscript staging/landsat-mosaic-tiles.r -i ../data/intermediary/cloud-free/Peru/ -o ../data/intermediary/cropped/Peru/ -t 10 -m /userdata2/tmp/

# Stack time series
Rscript staging/landsat-stack-ts.r -i ../data/intermediary/cropped/Peru/ -c Peru -o ../data/intermediary/time-stacks/Peru/ -m /userdata2/tmp/
