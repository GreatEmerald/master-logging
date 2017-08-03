# Mosaic multiple granules into a single granule with best quality pixels
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

# Depends on GetSentinel2Info
source("preprocessing/sentinel-calc-indices.r")

# Input: directory with Sentinel-2-derived vegetation indices;
#        pattern of files to mosaic (to filter out only vegetation indices);
#        list of granule names to mosaic;
#        output directory
# Output: Multi-granule 10m VI files with best pixels selected (by max value of itself)

# Allows specifying only two granules due to raster::mosaic limitations
S2MosaicVI = function(input_dir, pattern, output_dir, granule_a="21NUE", granule_b="21NUF")
{
    Files = list.files(input_dir, glob2rx(pattern), full.names=TRUE)
    
    GetOutputFilename = function(sample_file, granule)
    {
        return(file.path(output_dir, sub(granule, "99ZZZ", basename(sample_file))))
    }
    
    FileInfo = GetSentinel2Info(Files)
    RasterA = FileInfo[FileInfo$granule == granule_a,"filename"]
    RasterB = FileInfo[FileInfo$granule == granule_b,"filename"]
    if (nrow(RasterA) <= 0)
    {
        if (nrow(RasterB) <= 0)
            stop(paste("Could not find either of the rasters to mosaic in", input_dir, pattern))
        
        warning(paste("Only one granule found; output is a copy of" RasterB))
        file.copy(RasterB, GetOutputFilename(RasterB, granule_b))
    }
    else if (nrow(RasterB) <= 0)
    {
        warning(paste("Only one granule found; output is a copy of" RasterA))
        file.copy(RasterA, GetOutputFilename(RasterA, granule_a))
    }
    else
    {
        Mosaic = mosaic(raster(RasterA), raster(RasterB), fun=max, progress="text",
            filename=GetOutputFilename(RasterA, granule_a), datatype="INT2S",
            options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
    }
}

S2MosaicVIs = function(input_dir, output_dir, VIs = c("EVI", "MSAVI", "NBR", "NDMI", "NDVI"), threads=1, ...)
{
    Directories = list.files(input_dir, full.names=TRUE)
    
    psnice(value = min(threads - 1, 19))
    registerDoParallel(threads)
    
    foreach (Directory = iter(Directories), .inorder=FALSE, .verbose=TRUE, .packages="raster") %:%
    {
        foreach (VI = iter(VIs), .inorder=FALSE, .verbose=TRUE, .packages="raster") %dopar%
        {
            OutputSubdirectory = file.path(output_dir, basename(Directory))
            if (!file.exists(OutputSubdirectory))
                dir.create(OutputSubdirectory)
            S2MosaicVI(Directory, paste0("*", VI, "*"), OutputSubdirectory, ...)
        }
    }
}
