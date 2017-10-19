# Scratchpad for calculating vegetation indices from ASTER data.
#
# Copyright (C) 2017  Dainius Masiliunas
#
# This file is part of the selective logging detection through time series thesis.
#
# Scripts of the thesis are free software: you can redistribute them and/or modify
# them under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The scripts are distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the scripts.  If not, see <http://www.gnu.org/licenses/>.

library(raster)
source("preprocessing/index-utils.r")

# Note: this script is not part of the preprocessing chain, this is for validation and thus is not automated.

# Set to the input directory with ASTER imagery, for instance
Dir = "../data/satellite/Peru/aster/AST_07XT_00304182013145807_20170821093010_5067/"

SWIR = raster(file.path(Dir, "band4.tif"))
SWIR2 = raster(file.path(Dir, "band6.tif"))
NIR = raster(file.path(Dir, "band3n.tif"))
Red = raster(file.path(Dir, "band2.tif"))

SWIR = disaggregate(SWIR, 2, "bilinear")
SWIR2 = disaggregate(SWIR2, 2, "bilinear")

# ASTER uses a range of 0-1000, unlike Sentinel/Landsat that use 0-10000
MSAVI = function(red, nir)
{
    red = red/1000
    nir = nir/1000
    (2*nir+1 - sqrt((2*nir+1)^2 - 8*(nir-red)))/2 * 10000
}

# SWIR-based indices do not work with post-2008 data!
Result = overlay(SWIR, NIR, fun=NDMI, filename=file.path(Dir, "ndmi.tif"), datatype="INT2S",
    options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), progress="text")

Result = overlay(Red, NIR, fun=MSAVI, filename=file.path(Dir, "msavi.tif"), datatype="INT2S",
    options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), progress="text", overwrite=TRUE)

Result = overlay(Red, NIR, fun=NDVI, filename=file.path(Dir, "ndvi.tif"), datatype="INT2S",
    options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), progress="text")
    
Result = overlay(SWIR2, NIR, fun=NBR, filename=file.path(Dir, "nbr.tif"), datatype="INT2S",
    options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), progress="text")
    