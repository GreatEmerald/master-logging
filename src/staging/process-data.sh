#!/bin/sh
# Processing chain script for the thesis analysis itself.
# Contains environment-specific items, so this is just for reference.

# Following the flowchart in the thesis:
# 1. Atmospheric correction: run manually. Not needed for Landsat and ASTER, those are already Level 2A.
#    For Sentinel-2, run sen2cor on the imagery to obtain Level 2A products.

# 2. Vegetation index calculation: only for Sentinel-2 and ASTER.
#    For ASTER: See preprocessing/aster-calc-indices.r. It will need adjustments for the images you use.
#    For Sentinel-2, this step needs to be run after cloud masking, because the cloud masking script sets direstory structure.

# 3. Cloud masking.
#    For Landsat:
# Using -p "LE0723105620??*" or "LC08??????2017*" is recommended, because that's a lot of disk space that it uses
Rscript landsat-mask-clouds.r -i ../data/satellite/Guyana2014/landsat7/ -o ../data/intermediary/cloud-free/Guyana2014/landsat7/ -m /userdata2/tmp/
Rscript landsat-mask-clouds.r -i ../data/satellite/Peru/landsat7 -o ../data/intermediary/cloud-free/Peru/landsat7 -m /userdata2/tmp/ -t 10
Rscript landsat-mask-clouds.r -i ../data/satellite/Guyana2017/landsat8 -o ../data/intermediary/cloud-free/Guyana2017/landsat8
# ...and so on
#    For Sentinel-2:
Rscript sentinel-mask-clouds.r ../data/satellite/Guyana2017/sentinel2 -o ../data/intermediary/cloud-free/Guyana2017/sentinel2
# Then to calculate indices (no output since it just writes more files to the existing directory):
Rscript sentinel-calc-indices.r -i ../data/intermediary/cloud-free/Guyana2017/sentinel2

# 4. Mosaicking/extent matching:
#    For Landsat:
Rscript landsat-mosaic-tiles.r -i ../data/intermediary/cloud-free/Peru/landsat7 -o ../data/intermediary/mosaics/Peru/landsat7 -t 10 -m /userdata2/tmp/
# ...and so on
#    For Sentinel-2:
Rscript sentinel-mosaic-granules.r -i ../data/intermediary/cloud-free/Guyana2017/sentinel2 -o ../data/intermediary/mosaics/Guyana2017/sentinel2

# 5. Point bounding box calculation:
Rscript calc-bbox.r

# 6. Time series stacking:
#    For Landsat:
Rscript landsat-stack-ts.r -i ../data/intermediary/mosaics/Peru/landsat7 -c Peru -o ../data/output/Peru/landsat8 -m /userdata2/tmp/
# ...and so on
#    For Sentinel-2:
Rscript sentinel-stack-ts.r -i ../data/intermediary/mosaics/Guyana2017/sentinel2 -c Guyana2017 -o ../data/output/Guyana2017/sentinel2

# 7. Time series break detection: Done manually, see the `visualisation` subdirectory
