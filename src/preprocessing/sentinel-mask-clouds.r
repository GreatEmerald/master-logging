# Apply the scene classification mask to Sentinel-2 imagery.
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
library(foreach)
library(doParallel)
library(tools)
library(XML)

# Applies a mask to a single granule. mask_values stands for what values in the mask to filter out
S2ApplyMaskToGranule = function(path, output_dir, mask_values=c(0:3, 7:10), resolution=c("20", "10"))
{
    # NOTE: mask_values default to paranoid values. You might want to exclude 2 (dark areas, usually cloud shadows though)
    # and 7 (low probability that it's cloud)
    
    # Find mask file: old style
    ID = file.path(path, "IMG_DATA")
    MaskFile = list.files(ID, pattern=glob2rx("*SCL_L2A*20m.jp2"), full.names=TRUE)
    # New style
    if (length(MaskFile) <= 0)
    {
        MaskFile = list.files(file.path(ID, "R20m"), pattern=glob2rx("L2A_*_SCL_20m.jp2"), full.names=TRUE)
        if (length(MaskFile) <= 0)
            stop(paste("Could not find mask file in directory", ID))
    }
    Mask = raster(MaskFile)
    Mask10 = disaggregate(Mask, 2)
    
    masker = function(x, y)
    {
        x[y %in% mask_values] <- NA
        return(x)
    }
    
    # Function for handling any size, run for 20 and then 10m resolution files; size is string
    MaskGranuleWithSize=function(size)
    {
        size = as.character(size)
        if (size == "10")
            CurrentMask = Mask10
        else
            CurrentMask = Mask
        
        Bands = list.files(ID, pattern=glob2rx(paste0("*L2A_*_B??_", size, "m.jp2")), full.names=TRUE, recursive=TRUE)
        OutputDir = file.path(output_dir, paste0("R", size, "m"))
        if (!file.exists(OutputDir))
            dir.create(OutputDir, recursive=TRUE)
        
        foreach(BandFile=iter(Bands), .inorder=FALSE, .packages="raster", .verbose=TRUE) %dopar%
        {
            Band = raster(BandFile)
            OutputFile = sub("0m.jp2", "0m.tif", file.path(OutputDir, basename(BandFile)))
            MaskedBand = overlay(Band, CurrentMask, fun=masker, filename=OutputFile, datatype="INT2U",
                options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), progress="text")
        }
    }
    for (i in 1:length(resolution))
        MaskGranuleWithSize(resolution[i])
}

S2ApplyMaskToProduct = function(path, output_dir, temp_dir=NULL, threads=2, granule=c("21NUE", "21NUF"), ...)
{
    if (!is.null(temp_dir))
        rasterOptions(tmpdir=temp_dir)
    
    # NOTE: Needs 2.1 GiB RAM per thread of 20m, up to 8 GiB per thread of 10m
    rasterOptions(chunksize=5e+07, maxmemory=5e+08)
    psnice(value = min(threads - 1, 19))
    registerDoParallel(threads)
    
    # Get a regex of all *granule*s ORed so we don't need loops
    if (length(granule) > 0)
        GranulePattern = glob2rx(paste0("*", paste(granule, collapse="*|*"), "*"))
    else
        GranulePattern = NULL
        
    GranuleList = list.files(file.path(path, "GRANULE"), GranulePattern, full.names=TRUE)
    if (length(GranuleList) <= 0)
        stop(paste("Could not find granule in", path))
    
    for (i in 1:length(GranuleList))
    {
        print(paste("Processing granule", GranuleList[i]))
        # The name of a granule refers to the processing time. That is useless, so parse metadata to extract sensing time
        GranuleMetadataFile = list.files(GranuleList[i], glob2rx("*MTD*_TL*.xml"), full.names=TRUE)
        print(paste("Granule metadata file is:", GranuleMetadataFile))
        GranuleMetadata = xmlToList(GranuleMetadataFile)
        S2ApplyMaskToGranule(GranuleList[i], file.path(output_dir, GranuleMetadata[["General_Info"]][["SENSING_TIME"]]$text), ...)
    }
}

# Wrapper to handle multiple files if a pattern is passed
S2ApplyMaskToProducts = function(path, pattern=NULL, ...)
{
    if (!is.null(pattern))
    {
        Products = list.files(path, glob2rx(pattern), full.names=TRUE)
        for (i in 1:length(Products))
            S2ApplyMaskToProduct(Products[i], ...)
    }
    else
        S2ApplyMaskToProduct(path, ...)
}
