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
library(optparse)
library(tools)

parser = OptionParser()
parser = add_option(parser, c("-i", "--input-dir"), type="character",
    default="../data/intermediary/cloud-free",
    help="Directory with cloud-free VI files. (Default: %default)", metavar="path")
parser = add_option(parser, c("-f", "--extent-file"), type="character", metavar="path",
    default="../data/reference/LoggedTreeBoundaries.csv",
    help="File that contains information about logged trees and search bounding box. (Default: %default)")
parser = add_option(parser, c("-c", "--campaign"), type="character", metavar="name",
    help="Name of the campaign to process.")
parser = add_option(parser, c("-o", "--output-dir"), type="character", metavar="path",
    default="../data/intermediary/time-stacks",
    help="Output directory. (Default: %default)")
sink("/dev/null") # Silence rasterOptions
parser = add_option(parser, c("-m", "--temp-dir"), type="character", metavar="path",
    help=paste0("Path to a temporary directory to store results in. (Default: ",
        rasterOptions()$tmpdir, ")"))
sink()
args = parse_args(parser)

# Input: directory with a time series, list of points with an extent, campaign name
# Output: a directory with cropped stacked time series per point

# This is meant to run in point mode only: stack only the buffer around our known trees.
# For this we need to load tree information with extents. And since that's a lot of data, campaigns.
# Run once per campaign per VI. This does not recurse.

# In tile mode, there is no reason to save the stack to disk, that will just eat space for no gain.
# That is thus handled by the scripts further in the processing chain. Do not run this in that case.
StackTS = function(input_dir=args[["input-dir"]], output_dir=args[["output-dir"]],
    extent_file=args[["extent-file"]], campaign=args[["campaign"]], temp_dir=args[["temp-dir"]])
{
    if (!is.null(temp_dir))
        rasterOptions(tmpdir=temp_dir)
    
    # Parse the tree data
    TreeData = read.csv(extent_file, stringsAsFactors=FALSE)
    TreeData = TreeData[TreeData$Campaign==campaign,]
    
    Threads = detectCores()-1
    psnice(value = min(Threads - 1, 19))
    registerDoParallel(cores = Threads)
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

StackTS()
