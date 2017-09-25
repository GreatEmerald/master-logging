#!/usr/bin/env Rscript
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

library(optparse)
library(raster)

# NOTE: The parser cannot easily parse arrays, so you need to edit the defaults in the function definitions if you need
# different vegetation indices than all of the default 5.

parser = OptionParser()
parser = add_option(parser, c("-i", "--input-directory"), type="character", default="../data/intermediate/cloud-free/Guyana2017",
    help="Directory that contains Sentinel-2 product files, or a Sentinel SAFE directory. (Default: %default)", metavar="path")
parser = add_option(parser, c("-t", "--threads"), type="integer", metavar="num",
    default=8, help="Number of threads to use. You need 1 GiB of RAM per thread. (Default: %default)")
parser = add_option(parser, c("-p", "--pattern"), type="character", metavar="regex",
    help="Glob for finding Sentinel SAFE directories if the input directory contains multiple of them (for example: *T*Z)")
sink("/dev/null") # Silence rasterOptions
parser = add_option(parser, c("-m", "--temp-dir"), type="character", metavar="path",
    help=paste0("Path to a temporary directory to store results in. (Default: ",
        rasterOptions()$tmpdir, ")"))
sink()
args = parse_args(parser)

source("preprocessing/sentinel-calc-indices.r")

if (!is.null(args[["temp-dir"]]))
        rasterOptions(tmpdir=args[["temp-dir"]])
#rasterOptions(chunksize=5e+07, maxmemory=5e+08)
        
S2CalcIndicesBatch(args[["input-directory"]], pattern=args[["pattern"]], threads=args[["threads"]])
