# Stack Sentinel-2 VI time series by cropping to AOI
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

# Input: input directory (containing directories whose names are timestamps);
#        pattern to filter a vegetation index by;
#        output directory (typically with a name for the VI);
#        CSV file with area of interest extents;
#        name of the campaign

S2StackVITimeseriesAOI = function(input_dir, file_pattern, output_dir, aoi_file, campaign)
{
    TreeData = read.csv(aoi_file, stringsAsFactors=FALSE)
    TreeData = TreeData[TreeData$Campaign==campaign,]
    VIFiles = list.files(input_dir, glob2rx(file_pattern), recursive=TRUE, full.names=TRUE)
    
    Times = basename(dirname(VIFiles)) # This gives yyyy-mm-ddThh:mm:ss.fffZ
    # Hacky way of getting only the yyyy-mm-dd part, probably better to use lubridate
    Dates = unlist(as.data.frame(strsplit(Times, "T"), stringsAsFactors=FALSE)[1,])
    #print(Dates)
    
    foreach (TreeDatum = iter(TreeData, by="row"), .inorder = FALSE, .packages = "raster", .verbose=TRUE) %dopar%
    {
        StackName = file.path(output_dir, paste0(row.names(TreeDatum), "_",
                sub(":", "to", sub("&", "and", gsub(" ", "_", TreeDatum$ID))), ".grd"))
        VIStack = foreach (VIFile = VIFiles, .combine=addLayer, .multicombine=TRUE, .packages="raster", .verbose=TRUE) %do%
        {
            print(paste("Cropping file:", VIFile))
            VIRaster = raster(VIFile)
            AOIExtent = extent(TreeDatum$xmin, TreeDatum$xmax, TreeDatum$ymin, TreeDatum$ymax)
#             e = intersect(extent(VIRaster), AOIExtent)
#             if (is.null(e))
#             {
#                 print(paste("ERROR: No overlap between raster", VIFile, "and tree extent:"))
#                 print(TreeDatum)
#                 print("Raster extent was:")
#                 print(extent(VIRaster))
#             }
            crop(VIRaster, AOIExtent, datatype="INT2S")
        }
        VIStack = setZ(VIStack, Dates)
        writeRaster(VIStack, filename=StackName, progress="text", datatype="INT2S")
    }
}

# Batch function to process all VIs
S2StackVITimeseriesAOIs = function(..., output, VIs = c("EVI", "MSAVI", "NDMI", "NBR", "NDVI"))
{
    foreach (VI = VIs, .inorder=FALSE, .packages="raster") %do%
    {
        VIPattern = paste0("*", VI, "*.tif")
        OutputDirectory = file.path(output, VI)
        if (!file.exists(OutputDirectory))
            dir.create(OutputDirectory)
            
        S2StackVITimeseriesAOI(..., output_dir=OutputDirectory, file_pattern = VIPattern)
    }
}
