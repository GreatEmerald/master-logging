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

# Input: Reference raster to which to fit the bounding box to; data point CSV file.
# Output: A list of bbox classes that define the boundaries of all data points.

GetBBox = function(reference_raster, data_csv)
{
    # Get the data into R format
    reference_raster = "../data/satellite/LE07_L1TP_231056_19990822_20170217_01_T1_sr_ndvi.tif"
    RR = raster(reference_raster)
    data_csv = "../data/reference/LoggedTrees.csv"
    DataPoints = read.csv(data_csv, stringsAsFactors=FALSE)
    coordinates(DataPoints) = ~Latitude+Longitude
    
    # Reproject points to the CRS of the raster so as to get a buffer that is in fact round and of 60 m
    a = gBuffer(DataPoints, byid=TRUE, width=res(RR)[1]*2, quadsegs=1) # Rhombus; fine, since we need the BB only
}
