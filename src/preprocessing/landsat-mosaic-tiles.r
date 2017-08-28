# Mosaic multiple tiles into a single tile with best quality pixels
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

library(foreach)
library(bfastSpatial)
library(stringr)

# Mosaic matching tiles of a given path/row into one (both are set to 999 in output)
# Note: this can also be used in lieu of set-common-extent.r, since it does the extending anyway.
LSMosaicVI = function(input_dir, pattern="*.tif", output_dir)
{
    Files = list.files(input_dir, pattern=glob2rx(pattern), full.names=TRUE)
    if (length(Files) <= 0)
    {
        warning(paste("No files matching pattern", pattern, "found in directory", input_dir, "thus skipping it."))
        return(NULL)
    }
    
    FileInfos = getSceneinfo(Files)
    FileInfos = cbind(FileInfos, id=1:length(Files)) # Add an "id" column to match row number
    
    # Figure out what the extent is supposed to be
    MaxExtent = extent(NaN, NaN, NaN, NaN)
    foreach(File = Files) %do%
    {
        CurrentRaster = raster(File)
        CurrentExtent = extent(CurrentRaster)
        MaxExtent@xmin = min(CurrentExtent@xmin, MaxExtent@xmin, na.rm=TRUE)
        MaxExtent@ymin = min(CurrentExtent@ymin, MaxExtent@ymin, na.rm=TRUE)
        MaxExtent@xmax = max(CurrentExtent@xmax, MaxExtent@xmax, na.rm=TRUE)
        MaxExtent@ymax = max(CurrentExtent@ymax, MaxExtent@ymax, na.rm=TRUE)
    }
    rm(CurrentRaster)
    
    # Figure out which images are pairs of which other images
    # Maintain a blacklist for the second tile in pair so as not to process twice
    Blacklist = c()
    
    foreach(FileIndex = 1:length(Files)) %do%
    {
        File = Files[FileIndex]
        if (!(File %in% Blacklist))
        {
            FileInfo = FileInfos[FileIndex,]
            # Find tiles that match the date of the current tile
            PotentialPairs = FileInfos[which(FileInfo$date == FileInfos$date),]
            # It will find itself too, so filter ourselves out
            PotentialPairs = PotentialPairs[!rownames(PotentialPairs) %in% rownames(FileInfo),]
            # Hopefully it only picked up the counterpart
            if (nrow(PotentialPairs) > 1)
            {
                print(PotentialPairs)
                stop(paste("More than one pontential pair found for file", File))
            }
            else if (nrow(PotentialPairs) == 1)
            {
                PairFile = Files[PotentialPairs$id]
                # Blacklist it
                Blacklist = c(Blacklist, PairFile)
            }
        }
    }
    
    print("Files with pairs (in blacklist):")
    print(Blacklist)
    
    if (!file.exists(output_dir))
        dir.create(output_dir)
    # Do the actual processing, in parallel
    foreach(FileIndex = 1:length(Files), .packages="raster", .inorder=FALSE) %dopar%
    {
        File = Files[FileIndex]
        if (!(File %in% Blacklist))
        {
            FileInfo = FileInfos[FileIndex,]
            # Find tiles that match the date of the current tile
            PotentialPairs = FileInfos[which(FileInfo$date == FileInfos$date),]
            print(paste0("Run ", FileIndex, ": Potential pairs found for the file ", File, ":"))
            print(PotentialPairs)
            # It will find itself too, so filter ourselves out
            PotentialPairs = PotentialPairs[!rownames(PotentialPairs) %in% rownames(FileInfo),]
            # Hopefully it only picked up the counterpart
            if (nrow(PotentialPairs) > 1)
            {
                print(PotentialPairs)
                stop(paste("More than one pontential pair found for file", File))
            }
            else if (nrow(PotentialPairs) <= 0)
            {
                OutputFile = file.path(output_dir, basename(File))
                if (file.exists(OutputFile))
                    print(paste("Extended file", OutputFile, "already exists, skipping!"))
                else
                {
                    print(paste("Pair for file", File, "not found, extending instead."))
                    extend(raster(File), MaxExtent, filename=OutputFile, progress="text",
                        datatype="INT2S", options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
                }
            }
            else
            {
                PairFile = Files[PotentialPairs$id]
                # Create a filename
                PathRow = paste0(str_pad(FileInfo$path, 3, pad="0"), str_pad(FileInfo$row, 3, pad="0"))
                OutputFile = file.path(output_dir, sub(PathRow, "999999", basename(File)))
                if (file.exists(OutputFile))
                    print(paste("Mosaicked file", OutputFile, "already exists, skipping!"))
                else
                {
                    print(paste("Mosaicking", File, "with", PairFile))
                    Mosaic = mosaic(raster(File), raster(PairFile), fun=max, progress="text")
                    print(paste("Extending the file and writing to", OutputFile))
                    extend(Mosaic, MaxExtent, filename=OutputFile, datatype="INT2S", progress="text",
                        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
                }
            }
            
        }
        else print(paste("Skipping", File, "as it has already been processed."))
    }
}

LSMosaicVIs = function(input_dir, pattern="*.tif", output_dir)
{
    VIDirs = list.dirs(input_dir, recursive=FALSE)
    foreach (VIDir = VIDirs) %do%
    {
        OutputDir = file.path(output_dir, basename(VIDir))
        LSMosaicVI(VIDir, pattern, OutputDir)
    }
}
