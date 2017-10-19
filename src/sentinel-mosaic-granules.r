#!/usr/bin/env Rscript
# Mosaic multiple granules into a single granule with best quality pixels
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

library(optparse)
library(raster)

# NOTE: The parser cannot easily parse arrays, so you need to edit the defaults in the function definitions if you need
# different vegetation indices than all of the default 5.

parser = OptionParser()
parser = add_option(parser, c("-i", "--input-directory"), type="character", default="../data/intermediate/cloud-free",
    help="Directory that contains Sentinel-2-derived vegetation indices. (Default: %default)", metavar="path")
parser = add_option(parser, c("-o", "--output-directory"), type="character", default="../data/intermediate/mosaics",
    help="Output directory. (Default: %default)", metavar="path")
parser = add_option(parser, c("-t", "--threads"), type="integer", metavar="num",
    default=8, help="Number of threads to use. You need 1.4 GiB of RAM per thread. (Default: %default)")
sink("/dev/null") # Silence rasterOptions
parser = add_option(parser, c("-m", "--temp-dir"), type="character", metavar="path",
    help=paste0("Path to a temporary directory to store uncompressed large chunks in. (Default: ",
        rasterOptions()$tmpdir, ")"))
sink()
args = parse_args(parser)

source("preprocessing/sentinel-mosaic-granules.r")

if (!is.null(args[["temp-dir"]]))
        rasterOptions(tmpdir=args[["temp-dir"]])
        
S2MosaicVIs(args[["input-directory"]], args[["output-directory"]], threads=args[["threads"]])
