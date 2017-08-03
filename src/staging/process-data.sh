#!/bin/sh
# Processing chain script for the thesis analysis itself.
# Contains environment-specific items, so this is just for reference.

# Mask clouds in Guyana 2014
# Using -f "LE0723105620??*" is recommended, because that's a lot of disk space that it uses
Rscript mask-clouds.r -i ../data/satellite/Guyana2014 -o ../data/intermediary/cloud-free/Guyana2014 -m /userdata2/tmp/

# Stack time series, one line per VI
Rscript stack-ts.r -i ../data/intermediary/cloud-free/Guyana2014b/evi/ -c Guyana2014 -o ../data/intermediary/time-stacks/Guyana2014/evi/ -m /userdata2/tmp
