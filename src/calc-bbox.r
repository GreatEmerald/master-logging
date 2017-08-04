#!/usr/bin/env Rscript
# Calculates the bounding box around all points in the area of interest.
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
library(rgeos)
library(optparse)

# Input: Path to CSV file that maps campaigns to projections; path to reference point CSV file; path to output CSV file.
# Output: An enhanced CSV file with xmin, xmax, ymin, ymax columns (in respective projections).

parser = OptionParser()
parser = add_option(parser, c("-p", "--projection-file"), type="character", default="../data/reference/Projections.csv",
    help="CSV file that maps projections to campaigns in reference data. (Default: %default)", metavar="path")
parser = add_option(parser, c("-d", "--data-file"), type="character", metavar="path",
    default="../data/reference/LoggedTrees.csv",
    help="CSV file that lists logged trees in campaigns. (Default: %default)")
parser = add_option(parser, c("-o", "--output-file"), type="character", metavar="path",
    default="../data/reference/LoggedTreeBoundaries.csv", help="Output file path. (Default: %default)")
args = parse_args(parser)
    
AddExtent = function(projection_csv=args[["projection-file"]], data_csv=args[["data-file"]], output_path=args[["output-file"]])
{
    # Get the data into R format
    # Note that different scenes have different projections!
    # This means we need a file to map projections to campaigns, or else reproject all rasters to a single projection.
    ProjectionMap = read.csv(projection_csv, stringsAsFactors=FALSE)
    DataPoints = read.csv(data_csv, stringsAsFactors=FALSE)
    DataPoints[["Campaign"]] = as.factor(DataPoints[["Campaign"]])
    coordinates(DataPoints) = ~Longitude+Latitude
    crs(DataPoints) = CRS("+proj=longlat +datum=WGS84 +no_defs")
    
    OutputCSV = read.csv(data_csv, stringsAsFactors=FALSE)
    CoordDF = data.frame()
    for (i in 1:length(DataPoints))
    {
        Campaign = DataPoints@data$Campaign[i]
        Point = DataPoints[i,]
        # Transform to the right projection
        DataUTM = spTransform(Point, crs(ProjectionMap[ProjectionMap$Campaign==Campaign, "proj4"]))
        
        # Buffer
        BufferedPoints = gBuffer(DataUTM, byid=TRUE, width=75, quadsegs=1) # Rhombus; fine, since we need the BB only
        # Could also use byid=FALSE and disaggregate() to dissolve them
        # Extract extent values for writing to CSV
        Coords = data.frame(xmin = extent(BufferedPoints)@xmin, xmax = extent(BufferedPoints)@xmax,
            ymin = extent(BufferedPoints)@ymin, ymax = extent(BufferedPoints)@ymax)
        if (length(CoordDF) == 0)
            CoordDF = Coords
        else
            CoordDF = rbind(CoordDF, Coords)
    }
    OutputCSV = cbind(OutputCSV, CoordDF)
    write.csv(OutputCSV, output_path)
}

AddExtent()
