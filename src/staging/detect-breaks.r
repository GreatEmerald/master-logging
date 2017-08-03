#!/usr/bin/env Rscript
# Script for detecting deforestation breaks in time series
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

library(bfast)
library(raster)

library(bfastSpatial)

input = "../data/intermediary/time-stacks/Guyana2014/ndvi/33_T09.grd" # cell 8 is interesting
# nbr is interesting: it does not show a large cloud on 2015-01-06 LE072310562015010601T1
input = "../data/intermediary/time-stacks/Guyana2014/nbr/26_T02.grd"
input = "../data/intermediary/time-stacks/Guyana2014/ndvi/34_T10.grd"
input = "../data/intermediary/time-stacks/Guyana2014/nbr/32_T08.grd"
TimeSeries = brick(input)

getSceneinfo(names(TimeSeries))
which(row.names(getSceneinfo(names(TimeSeries))) == "LE072310562015010601T1")
plot(TimeSeries, 281, col=rev(rainbow(99,start=0,end=1)), breaks=seq(min(minValue(TimeSeries), na.rm=TRUE),
    max(maxValue(TimeSeries), na.rm=TRUE),length.out=100))

# 13th cell is the centre one, 8th is 1 north, 18th is 1 south
for (i in 1:25){
BMP = bfmPixel(TimeSeries, start = c(2014, 1), cell=i, formula=response~harmon, order=1)
plot(BMP$bfm)
abline(v=2014.9167)
abline(v=2014.8333)
}

# Can't find anything; by 2015-04-12 it's grown back up, no data in 2014

input = "../data/intermediary/time-stacks/Guyana2014/evi/33_T09.grd"
TimeSeries = brick(input)
