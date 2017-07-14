#!/bin/sh
# Processing chain script for the thesis analysis itself.
# Contains environment-specific items, so this is just for reference.

# Mask clouds in Peru
# Using -f "LE0723105620??*" is recommended, because that's a lot of disk space that it uses
Rscript mask-clouds.r -i ../data/satellite/Guyana2014 -o ../data/intermediary/cloud-free/Guyana2014 -m /userdata2/tmp/
