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

# Input: Path to CSV file that maps campaigns to projections; path to reference point CSV file; path to output CSV file.
# Output: An enhanced CSV file with xmin, xmax, ymin, ymax columns (in respective projections).

AddExtent = function(projection_csv, data_csv, output_path)
{
    # Get the data into R format
    # Note that different scenes have different projections!
    # This means we need a file to map projections to campaigns, or else reproject all rasters to a single projection.
    projection_csv = "../data/reference/Projections.csv"
    ProjectionMap = read.csv(projection_csv, stringsAsFactors=FALSE)
    data_csv = "../data/reference/LoggedTrees.csv"
    DataPoints = read.csv(data_csv, stringsAsFactors=FALSE)
    DataPoints[["Campaign"]] = as.factor(DataPoints[["Campaign"]])
    coordinates(DataPoints) = ~Longitude+Latitude
    crs(DataPoints) = CRS("+proj=longlat +datum=WGS84 +no_defs")
    
    OutputCSV = data.frame()
    for (i in 1:length(levels(DataPoints@data$Campaign)))
    {
        Campaign = levels(DataPoints@data$Campaign)[i]
        # Select points of the current campaign
        CampaignPoints = DataPoints[DataPoints$Campaign==Campaign,]
        # Transform to the right projection
        DataUTM = spTransform(CampaignPoints, crs(ProjectionMap[ProjectionMap$Campaign==Campaign, "proj4"]))
        
        # Buffer
        BufferedPoints = gBuffer(DataUTM, byid=TRUE, width=75, quadsegs=1) # Rhombus; fine, since we need the BB only
        # Could also use byid=FALSE and disaggregate() to dissolve them
        xmin=c(); xmax=c(); ymin=c(); ymax=c()
        for (n in 1:length(BufferedPoints))
        {
            # Extract extent values for writing to CSV
            xmin = c(xmin, extent(BufferedPoints[n,])@xmin)
            xmax = c(xmax, extent(BufferedPoints[n,])@xmax)
            ymin = c(ymin, extent(BufferedPoints[n,])@ymin)
            ymax = c(ymax, extent(BufferedPoints[n,])@ymax)
        }
        BufferedPoints@data$xmin = xmin
        BufferedPoints@data$xmax = xmax
        BufferedPoints@data$ymin = ymin
        BufferedPoints@data$ymax = ymax
        if (length(OutputCSV) == 0)
            OutputCSV = BufferedPoints@data
        else
            OutputCSV = rbind(OutputCSV, BufferedPoints@data)
    }
    FinalCSV = read.csv(data_csv)
    FinalCSV = cbind(FinalCSV, xmax=OutputCSV[["xmax"]]) # These need to be ordered first
    write.csv(OutputCSV, output_path)
}
