#!/usr/bin/env Rscript
# Script for detecting deforestation breaks in Sentinel-2 time series
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

input = "/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/41_100-6.grd" # cell 8 is interesting
TimeSeries = brick(input)

# Unfortunately BFAST has not enough time series to make this work without additional data
for (i in 1:225){
BMP = bfmPixel(TimeSeries, start = c(2017, 01), cell=i, formula=response~harmon, order=1)
plot(BMP$bfm)
abline(v=2017.0049)
}

# Could try STEF or fuse imagery; but the gap in the important time cannot be easily filled
