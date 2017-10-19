# Plotting time series of Guyana 2017 Landsat 7
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

source("visualisation/utils.r")

dir = "../data/output/Guyana2017/landsat7/"

# 35: clouded
TimeSeries = TSF("ndmi", 35, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 36: prior gap in centre, but ought to be one off
TimeSeries = TSF("ndmi", 36, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 36, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 37: nothing obvious and clouded; something odd in cell 10 in 2015 NDMI
TimeSeries = TSF("ndmi", 37, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2015), cell=10, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 37, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2015), cell=10, formula=response~harmon, order=1)
plot(BP$bfm)

# 38: Still nothing obvious, clouds
TimeSeries = TSF("ndmi", 38, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 38, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 39: clouds
TimeSeries = TSF("ndmi", 39, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 39, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 40: clouds, only two observations
TimeSeries = TSF("ndmi", 40, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 40, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 41: clouds, a single observation
TimeSeries = TSF("ndmi", 41, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 41, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 42: clouds, a single observation
TimeSeries = TSF("ndmi", 42, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 42, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 43: clouds, a single observation
TimeSeries = TSF("ndmi", 43, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 43, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

## 44: clouds, a single observation; but an interesting pattern if it was true
TimeSeries = TSF("ndmi", 44, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 44, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

## 45: clouds, a single observation; oddly enough the log deck that's there "disappears", maybe cloud shadow
TimeSeries = TSF("ndmi", 45, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 45, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 46: same area
TimeSeries = TSF("ndmi", 46, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 46, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

## 47: road, once again mysteriously disappears one time
TimeSeries = TSF("ndmi", 47, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 47, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 48: clouds
TimeSeries = TSF("ndmi", 48, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 48, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 49: duplicate of 48
TimeSeries = TSF("ndmi", 49, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 49, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 50: road (also disappearing), a single observation
TimeSeries = TSF("ndmi", 50, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 50, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
