#!/usr/bin/env Rscript
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
library(optparse)

# Command-line options
parser = OptionParser()
parser = add_option(parser, c("-i", "--input-dir"), type="character", default="../data/satellite",
    help="Directory of input files. May be compressed. (Default: %default)", metavar="path")
parser = add_option(parser, c("-o", "--output-dir"), type="character", metavar="path",
    default="../data/intermediary/cloud-free",
    help="Output directory. Subdirectories for each vegetation index will be created. (Default: %default)")
parser = add_option(parser, c("-t", "--file-type"), type="character", metavar="extension",
    default="grd",
    help="Output file type. grd is native uncompressed, tif is lightly compresssed. (Default: %default)")
parser = add_option(parser, c("-f", "--filter-pattern"), type="character", metavar="regex",
    help="Pattern to filter input files on. Should not include the extension (end with a *).")
sink("/dev/null") # Silence rasterOptions
parser = add_option(parser, c("-m", "--temp-dir"), type="character", metavar="path",
    help=paste0("Path to a temporary directory to store results in. (Default: ",
        rasterOptions()$tmpdir, ")"))
sink()
args = parse_args(parser)

MaskClouds = function(input_dir=args[["input-dir"]], output_dir=args[["output-dir"]],
    file_type=args[["file-type"]], filter_pattern=args[["filter-pattern"]],
    temp_dir=args[["temp-dir"]], ...)
{
    if (!is.null(temp_dir))
        rasterOptions(tmpdir=temp_dir)
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
    
    Threads = 10#detectCores()-1
    psnice(value = min(Threads - 1, 19))
    processLandsatBatch(x=input_dir, outdir=output_dir, fileExt=file_type, mask="pixel_qa", keep=c(66, 130),
        vi=c("ndvi", "evi", "msavi", "nbr", "ndmi"), delete=TRUE, pattern=filter_pattern,
        mc.cores=Threads, e=extent(172785, 433215, 533385, 747015), ...)
    
    # Repack files and remove 20000 (oversaturated AKA NA)
    FileList = list.files(output_dir, recursive = TRUE, pattern = GrdPattern, full.names = TRUE)
    registerDoParallel(cores = Threads)
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
                options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
        }
    }
    unlink(FileList)
    unlink(list.files(output_dir, recursive = TRUE, pattern = GriPattern, full.names = TRUE))
}

MaskClouds()

# Keep=c(0:223, 225:255) for nbr since it seems to be able to deal with shadows
# The result is fine but the compression is poor. We can do better with
# COMPRESS=DEFLATE ZLEVEL=9 SPARSE_OK=TRUE NUM_THREADS=4, so maybe run without compression first
