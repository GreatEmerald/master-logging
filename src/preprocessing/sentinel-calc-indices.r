# Calculate vegetation indices from Sentinel-2 bands.
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

source("preprocessing/index-utils.r")

# This will enhance the R10m directory with new "bands" for NDVI, NBR, etc.
# For indices that require bands at 20m resolution, they get disaggregated to 10m

# Utility function to get the granule ID (TNNCCC) by parsing a filename
GetGranuleID = function(name)
{
    return(grep(glob2rx("T?????"), unlist(strsplit(name, "_")), value=TRUE))
}

# Utility function to get the band name (BNN) by parsing a filename. A bee?!
GetBandName = function(name)
{
    Result = grep(glob2rx("B??"), unlist(strsplit(name, "_")), value=TRUE)
    if (length(Result) == 0)
    {
        warning(paste("Could not extract band name from file", name))
        return(NA)
    }
    return(Result)
}

# Utility function to create a data frame with "granule" and "band" from a list of filenames.
GetSentinel2Info = function(filenames)
{
    GranuleIDs = filenames
    BandNames = filenames
    for (i in 1:length(filenames))
    {
        GranuleIDs[i] = GetGranuleID(filenames[i])
        BandNames[i] = GetBandName(filenames[i])
    }
    return(data.frame(filename=filenames, granule=factor(GranuleIDs), band=factor(BandNames), stringsAsFactors=FALSE))
}

# Utility function to save space and increase readablity
GetRasterByBand = function(file_df, target_band)
{
    Result = unlist(subset(file_df, file_df$band == target_band)["filename"])
    #print(paste("Returning raster of:", Result))
    stopifnot(length(Result)==1)
    return(raster(Result))
}

# Utility function to save space and increase readablity
GetOutputFilename = function(file_df, vi_name)
{
    SampleFilename = unlist(subset(file_df, file_df$band == "B08")["filename"])
    NewFilename = sub("_B08_", paste0("_", vi_name, "_"), basename(SampleFilename))
    NewFilename = file.path(dirname(SampleFilename), NewFilename)
    print(paste("Writing to file:", NewFilename))
    return(NewFilename)
}

# Input: path to a granule (the directory with a timestamp), list of VIs to generate
# This function is a dispatcher to VI-specific functions
S2CalcIndicesGranule = function(path, indices=c("EVI", "NBR", "MSAVI", "NDMI", "NDVI"))
{
    R10m = list.files(file.path(path, "R10m"), glob2rx("*.tif"), full.names=TRUE)
    R20m = list.files(file.path(path, "R20m"), glob2rx("*.tif"), full.names=TRUE)
    
    # Figure out tiles. There may be more than one tile per directory due to timestamps matching.
    R10m = GetSentinel2Info(R10m)
    R20m = GetSentinel2Info(R20m)
    UniqueGranuleIDs = levels(R10m$granule)
    
    for (GranuleID in 1:length(UniqueGranuleIDs))
    {
        Unique10m = R10m[R10m$granule == UniqueGranuleIDs[GranuleID],]
        Unique20m = R20m[R20m$granule == UniqueGranuleIDs[GranuleID],]
        
        foreach (index=iter(indices), .inorder=FALSE, .packages="raster", .verbose=TRUE) %do%
        {
            print(paste("Index to be calculated:", index))
            switch(index,
                EVI=CalcEVI(Unique10m),
                MSAVI=CalcMSAVI(Unique10m),
                NDVI=CalcNDVI(Unique10m),
                NDMI=CalcNDMI(Unique10m, Unique20m),
                NBR=CalcNBR(Unique10m, Unique20m),
                stop(paste("Unknown index requested:", index)))
        }
    }
}

CalcEVI = function(file_df)
{
    print("Calculating EVI...")
    overlay(GetRasterByBand(file_df, "B04"), GetRasterByBand(file_df, "B08"), GetRasterByBand(file_df, "B02"),
        fun=EVI, filename=GetOutputFilename(file_df, "EVI"), datatype="INT2S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

CalcMSAVI = function(file_df)
{
    overlay(GetRasterByBand(file_df, "B04"), GetRasterByBand(file_df, "B08"),
        fun=MSAVI, filename=GetOutputFilename(file_df, "MSAVI"), datatype="INT2S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

CalcNDVI = function(file_df)
{
    overlay(GetRasterByBand(file_df, "B04"), GetRasterByBand(file_df, "B08"),
        fun=NDVI, filename=GetOutputFilename(file_df, "NDVI"), datatype="INT2S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

CalcNDMI = function(file_10_df, file_20_df)
{
    overlay(disaggregate(GetRasterByBand(file_20_df, "B11"), 2, "bilinear"), GetRasterByBand(file_10_df, "B08"),
        fun=NDMI, filename=GetOutputFilename(file_10_df, "NDMI"), datatype="INT2S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

CalcNBR = function(file_10_df, file_20_df)
{
    overlay(disaggregate(GetRasterByBand(file_20_df, "B12"), 2, "bilinear"), GetRasterByBand(file_10_df, "B08"),
        fun=NBR, filename=GetOutputFilename(file_10_df, "NBR"), datatype="INT2S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

# Run S2CalcIndicesGranule over many files
S2CalcIndicesBatch = function(path, pattern=NULL, threads=8, ...)
{
    if (!is.null(pattern))
    {
        Directories = list.files(path, glob2rx(pattern), full.names=TRUE)
        psnice(value = min(threads - 1, 19))
        registerDoParallel(threads)
        
        foreach (Directory=iter(Directories), .inorder=FALSE, .packages="raster", .verbose=TRUE) %dopar%
            S2CalcIndicesGranule(Directory, ...)
    }
    else
        S2CalcIndicesGranule(path, ...)

    
}
