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
LSMosaicVI = function(input_dir, pattern, output_dir, path_a, row_a, path_b, row_b)
{
    Files = list.files(input_dir, pattern=glob2rx(pattern), full.names=TRUE)
    FileInfos = getSceneinfo(Files)
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
            PotentialPairs = PotentialPairs[-FileIndex,]
            # Hopefully it only picked up the counterpart
            if (nrow(PotentialPairs) > 1)
            {
                print(PotentialPairs)
                stop(paste("More than one pontential pair found for file", File))
            }
            else if (nrow(PotentialPairs) <= 0)
            {
                print(paste("Pair for file", File, "not found, extending instead."))
                extend(raster(File), filename=file.path(output_dir, basename(File)), progress="text", datatype="INT2S",
                    options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
            }
            else
            {
                PairFile = Files[as.numeric(rownames(PotentialPairs))]
                # Blacklist it
                Blacklist = c(Blacklist, PairFile)
                # Create a filename
                PathRow = paste0(str_pad(FileInfo$path, 3, pad="0"), str_pad(FileInfo$row, 3, pad="0"))
                OutputFile = file.path(output_dir, sub(PathRow, "999999", basename(File)))
                
                print(paste("Mosaicking", File, "with", PairFile, "into", OutputFile))
                Mosaic = mosaic(raster(File), raster(PairFile), fun=max, progress="text",
                    filename=OutputFile, datatype="INT2S", options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"))
            }
            
        }
        else print(paste("Skipping", File, "as it has already been processed."))
    }
}

LE072310562009012101T1_ndvi.tif
