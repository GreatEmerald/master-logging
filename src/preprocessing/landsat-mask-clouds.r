# Masks clouds in Landsat imagery by applying FMask output to images.
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


# Input: Directory with input Landsat images, or a list of files; directory with FMask outputs, or a list of files;
#        output directory.
# Output: Landsat images with all clouded areas set to NA.

# NOTE: Due to the big data nature, we can't process everything at once, this needs to be done in batches.
# Therefore the script first checks if the output files already exist, if not, processes the input.
# That avoids the problem of mixing different batches together.
# It also optionally removes the input data to save disk space after processing is deemed successful.

# NOTE: Requires a new enough version of bfastSpatial that can handle Landsat Collection 1 data (-dev at the moment)
library(parallel)
library(foreach)
library(doParallel)
library(gdalUtils)
library(tools)
library(bfastSpatial)

MaskClouds = function(input_dir, output_dir, file_type, filter_pattern, temp_dir, threads, campaign, ...)
{
    if (!is.null(filter_pattern))
    {
        GrdPattern = glob2rx(paste0(filter_pattern, "*.grd"))
        GriPattern = glob2rx(paste0(filter_pattern, "*.gri"))
        filter_pattern = glob2rx(filter_pattern)
    }
    if (!exists("GrdPattern"))
        GrdPattern = glob2rx("*.grd")
    if (!exists("GriPattern"))
        GriPattern = glob2rx("*.gri")
        
    Extent = NULL
    Files = list.files(input_dir, filter_pattern, full.names=TRUE)
    FileInfo = getSceneinfo(Files)
    Path = FileInfo[1, "path"]
    Row = FileInfo[1, "row"]
    if (Path == 231 && Row == 56)
        Extent = extent(172785, 433215, 533385, 747015)
    if (Path == 230 && Row == 57)
        Extent = extent(334785, 562215, 363285, 595815)
    if (Path == 231 && Row == 57)
        Extent = extent(161685, 389715, 363285, 595815)
    
    psnice(value = min(threads - 1, 19))
    processLandsatBatch(x=input_dir, outdir=output_dir, fileExt=file_type, mask="pixel_qa", keep=c(66, 130),
        vi=c("ndvi", "evi", "msavi", "nbr", "ndmi"), delete=TRUE, pattern=filter_pattern,
        mc.cores=threads, e=Extent, ...)
    
    # Repack files and remove 20000 (oversaturated AKA NA)
    FileList = list.files(output_dir, recursive = TRUE, pattern = GrdPattern, full.names = TRUE)
    if (length(FileList) <= 0)
        stop("Could not repack files: no files found to repack.")
    registerDoParallel(cores = threads)
    outputs = foreach(i=1:length(FileList), .inorder = FALSE, .packages = "raster", .verbose=TRUE) %dopar%
    {
        RasterFileName = FileList[i]
        CompressedRasterName = sub("grd", "tif", RasterFileName)
        if (file.exists(CompressedRasterName))
        {
            print(paste("Skipping", CompressedRasterName, "because it already exists"))
        } else
        {
            print(paste("Repacking", CompressedRasterName))
            RawRaster = raster(RasterFileName)
            subs(RawRaster, data.frame(id=20000, v=NA), subsWithNA=FALSE, filename=CompressedRasterName,
                options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), datatype="INT2S")
        }
    }
    unlink(FileList)
    unlink(list.files(output_dir, recursive = TRUE, pattern = GriPattern, full.names = TRUE))
}

# Could keep=c(0:223, 225:255) for nbr since it seems to be able to deal with shadows (or maybe that makes NBR higher)
