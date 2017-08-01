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
    return(grep(glob2rx("B??"), unlist(strsplit(name, "_")), value=TRUE))
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
GetRasterByBand(file_df, band)
{
    return(raster(file_df["filename", file_df$band == band]))
}

# Utility function to save space and increase readablity
GetOutputFilename(file_df, vi_name)
{
    SampleFilename = file_df["filename", file_df$band == "B08"]
    NewFilename = sub("_B08_", paste0("_", vi_name ,"_") basename(SampleFilename))
    return(file.path(dirname(SampleFilename), NewFilename))
}

# Input: path to a granule (the directory with a timestamp), list of VIs to generate
# This function is a dispatcher to VI-specific functions
S2CalcIndicesGranule = function(path, indices=c("EVI", "NBR", "MSAVI", "NDMI", "NDVI"), threads=1)
{
    R10m = list.files(file.path(path, "R10m"), glob2rx("*.tif"), full.names=TRUE)
    R20m = list.files(file.path(path, "R20m"), glob2rx("*.tif"), full.names=TRUE)
    
    # Figure out tiles. There may be more than one tile per directory due to timestamps matching.
    R10m = GetSentinel2Info(R10m)
    R20m = GetSentinel2Info(R20m)
    UniqueGranuleIDs = levels(R10m$granule)
    
    psnice(value = min(threads - 1, 19))
    registerDoParallel(threads)
    
    for (GranuleID in 1:length(UniqueGranuleIDs))
    {
        Unique10m = R10m[,R10m$granule == GranuleID]
        Unique20m = R20m[,R20m$granule == GranuleID]
        
        foreach (index=iter(indices), .inorder=FALSE, .packages="raster", .verbose=TRUE) %dopar%
        {
            switch(index,
                EVI=CalcEVI(Unique10m),
                MSAVI=CalcMSAVI(Unique10m),
                NDVI=CalcNDVI(Unique10m),
                NDMI=CalcNDMI(Unique10m, Unique20m),
                NBR=CalcNDMI(Unique10m, Unique20m),
                stop(paste("Unknown index requested:", index)))
        }
    }
}

CalcEVI(file_df)
{
    EVI = function(red, nir, blue)
    {
        2.5 * (nir-red) / (nir+6*red-7.5*blue+1)
    }
    overlay(GetRasterByBand(file_df, "B04"), GetRasterByBand(file_df, "B08"), GetRasterByBand(file_df, "B02"),
        fun=EVI, filename=GetOutputFilename(file_df, "EVI"), datatype="FLT4S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

CalcMSAVI(file_df)
{
    MSAVI = function(red, nir)
    {
        (2*nir+1 - sqrt((2*nir+1)^2 - 8*(nir-red)))/2
    }
    overlay(GetRasterByBand(file_df, "B04"), GetRasterByBand(file_df, "B08"),
        fun=MSAVI, filename=GetOutputFilename(file_df, "MSAVI"), datatype="FLT4S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

CalcNDVI(file_df)
{
    NDVI = function(red, nir)
    {
        (nir-red)/(nir+red)
    }
    overlay(GetRasterByBand(file_df, "B04"), GetRasterByBand(file_df, "B08"),
        fun=NDVI, filename=GetOutputFilename(file_df, "NDVI"), datatype="FLT4S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

CalcNDMI(file_10_df, file_20_df)
{
    NDMI = function(swir, nir)
    {
        (nir-swir)/(nir+swir)
    }
    overlay(disaggregate(GetRasterByBand(file_20_df, "B11"), 2, "bilinear"), GetRasterByBand(file_10_df, "B08"),
        fun=NDMI, filename=GetOutputFilename(file_10_df, "NDMI"), datatype="FLT4S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}

CalcNBR(file_10_df, file_20_df)
{
    NBR = function(swir2, nir)
    {
        (nir-swir2)/(nir+swir2)
    }
    overlay(disaggregate(GetRasterByBand(file_20_df, "B12"), 2, "bilinear"), GetRasterByBand(file_10_df, "B08"),
        fun=NBR, filename=GetOutputFilename(file_10_df, "NBR"), datatype="FLT4S", progress="text",
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
}
