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

library(raster)
library(optparse)

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
parser = add_option(parser, c("-t", "--threads"), type="integer", metavar="num",
    default=detectCores()-1, help="Number of threads to use. You need almost no RAM per thread when using small AOIs. (Default: %default)")
sink("/dev/null") # Silence rasterOptions
parser = add_option(parser, c("-m", "--temp-dir"), type="character", metavar="path",
    help=paste0("Path to a temporary directory to store results in. (Default: ",
        rasterOptions()$tmpdir, ")"))
sink()
args = parse_args(parser)

source("preprocessing/landsat-stack-ts.r")

if (!is.null(args[["temp-dir"]]))
    rasterOptions(tmpdir=args[["temp-dir"]])

if (args[["threads"]] > 0)
{
    psnice(value = min(args[["threads"]] - 1, 19))
    registerDoParallel(cores = args[["threads"]])
}

StackTSs(args[["input-dir"]], args[["output-dir"]], args[["extent-file"]], args[["campaign"]])
