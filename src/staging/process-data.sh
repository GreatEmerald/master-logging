#!/bin/sh
# Processing chain script for the thesis analysis itself.
# Contains environment-specific items, so this is just for reference.

# Mask clouds in Peru
Rscript mask-clouds.r -i ../data/satellite/peru -o ../data/intermediary/cloud-free/peru -m /userdata2/tmp/
