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
        Unique10m = R10m[,R10m$granule == GranuleID]
        Unique20m = R20m[,R20m$granule == GranuleID]
        
        for (index in 1:length(indices))
        {
            switch(index,
                EVI=CalcEVI(Unique10m))
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
        fun=EVI, filename=GetOutputFilename(file_df, "EVI"), progress="text", options=c("COMPRESS=DEFLATE", "ZLEVEL=9"))
}
