#!/usr/bin/env Rscript
# Creates a time series stack for each VI for each tree
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

library(bfastSpatial)
library(doParallel)
library(foreach)
library(iterators)
library(tools)

# Input: directory with a time series, list of points with an extent, campaign name
# Output: a directory with cropped stacked time series per point

# This is meant to run in point mode only: stack only the buffer around our known trees.
# For this we need to load tree information with extents. And since that's a lot of data, campaigns.
# Run once per campaign per VI. This does not recurse.

# In tile mode, there is no reason to save the stack to disk, that will just eat space for no gain.
# That is thus handled by the scripts further in the processing chain. Do not run this in that case.
StackTS = function(input_dir, output_dir, extent_file, campaign)
{
    # Parse the tree data
    TreeData = read.csv(extent_file, stringsAsFactors=FALSE)
    TreeData = TreeData[TreeData$Campaign==campaign,]
    
    outputs = foreach(TreeDatum = iter(TreeData, by="row"), .inorder = FALSE, .packages = "bfastSpatial",
        .verbose=TRUE) %dopar%
    {
        # Stack the tile in memory, have to use quick to prevent stacking issues
        TileList = list.files(input_dir, pattern=glob2rx("*.tif"), full.names=TRUE)
        TileStack = stack(TileList)
        # Generate a pretty filename
        StackName = paste0(output_dir, "/", row.names(TreeDatum), "_",
            sub(":", "to", sub("&", "and", gsub(" ", "_", TreeDatum$ID))), ".grd")
        print(paste("Writing stack:", StackName))
        
        crop(TileStack, extent(TreeDatum$xmin, TreeDatum$xmax, TreeDatum$ymin, TreeDatum$ymax),
            filename=StackName, datatype="INT2S")
    }
}

StackTSs = function(input_dir, output_dir, ...)
{
    InputDirs = list.dirs(input_dir, recursive=FALSE)
    foreach(ID = InputDirs) %do%
    {
        OutputDir = file.path(output_dir, basename(ID))
        if (!file.exists(OutputDir))
            dir.create(OutputDir)
        StackTS(ID, OutputDir, ...)
    }
}
