#!/usr/bin/env Rscript
# Bash-ready script for extending files to common maximum extent.
# This works, but has been superseded by landsat-mosaic-tiles.r.
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

library(parallel)
library(raster)
library(optparse)

# Command-line options
parser = OptionParser()
parser = add_option(parser, c("-i", "--input-dir"), type="character", default="../data/satellite",
    help="Directory of input files. May be compressed. (Default: %default)", metavar="path")
parser = add_option(parser, c("-o", "--output-dir"), type="character", metavar="path",
    default="../data/intermediary/cloud-free",
    help="Output directory. Subdirectories for each vegetation index will be created. (Default: %default)")
parser = add_option(parser, c("-p", "--pattern"), type="character", metavar="regex",
    help="Pattern to filter input files on. Should not include the extension (end with a *).")
parser = add_option(parser, c("-t", "--threads"), type="numeric", default=detectCores()-1,  metavar="num",
    help="Number of threads to use for multicore processing. 1.6 GiB RAM is needed per thread. (Default: %default)")
sink("/dev/null") # Silence rasterOptions
parser = add_option(parser, c("-m", "--temp-dir"), type="character", metavar="path",
    help=paste0("Path to a temporary directory to store results in. (Default: ",
        rasterOptions()$tmpdir, ")"))
sink()
args = parse_args(parser)

source("preprocessing/set-common-extent.r")

if (!is.null(args[["temp-dir"]]))
        rasterOptions(tmpdir=args[["temp-dir"]])

ExtendToMaxCommonExtent(args[["input-dir"]], args[["pattern"]], args[["output-dir"]], args[["threads"]])
