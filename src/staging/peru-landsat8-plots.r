# Scratchpad for plotting time series of Peru Landsat 8
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

source("staging/util.r")

dir="/run/media/dainius/Landsat/Peru/landsat8/time-stacks/"

# The first nine are database points, probably incorrect placement. Should see nothing
# NDMI<=2500 is a clearing
# False positive
TimeSeries = TSF("ndmi", 1, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# False positive
TimeSeries = TSF("ndmi", 2, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2014, 1), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# And again. 8 points are not eonugh to determine stable history!
TimeSeries = TSF("ndmi", 3, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2014, 1), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# False positive
TimeSeries = TSF("ndmi", 4, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# False positive
TimeSeries = TSF("ndmi", 5, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# False positive
TimeSeries = TSF("ndmi", 6, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# Nothing
TimeSeries = TSF("ndmi", 7, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# False positive
TimeSeries = TSF("ndmi", 8, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2014.5), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# Nothing; a few interesting values, actually, but too low magnitude
TimeSeries = TSF("ndmi", 9, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

## 10: Maybe a value to the north: it does show a bit of a trend, though not detected
# Google Earth says it should be 20m to SW; which is right on the pixel boundary!
TimeSeries = TSF("ndmi", 10, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

TimeSeries = TSF("nbr", 10, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 10, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 10, dir) # EVI/MSAVI shows one pixel constantly darker to northeast
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=9, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("msavi", 10, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=9, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 11: false positive
TimeSeries = TSF("ndmi", 11, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 11, dir) # Break detected, but due to clouds
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 11, dir) # Also false positive
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 12: the case of the one pixel south: prior art
TimeSeries = TSF("ndmi", 12, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 12, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 12, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 13: prior art to the east
TimeSeries = TSF("ndmi", 13, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 13, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 13, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 14: also prior art; perhaps south-east is something
TimeSeries = TSF("ndmi", 14, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=17, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 14, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 14, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

## 15: First of the southern ones; potentially is one (but probably a cloud shadow)
TimeSeries = TSF("ndmi", 15, dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 15, dir) # The cloud shadow is detected as a break
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 15, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 16: Slight dip but not significant; a nice example of nothing at all
TimeSeries = TSF("ndmi", 16, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 16, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 16, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("nbr", 16, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 17: Back to the mainland and nothing of interest still
TimeSeries = TSF("ndmi", 17, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 17, dir) # NDVI reveals that there was an unfiltered cloud right after
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 17, dir) # EVI indicates prior art, nice sine pattern
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 18: Something is going on in the south, but prior art
TimeSeries = TSF("ndmi", 18, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 18, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 18, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 19: Start of gaps: these may have been made earlier; nothing obvious, may be to the north or south
TimeSeries = TSF("ndmi", 19, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 19, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 19, dir) # This does seem to indicate that there was a gap, but other VIs differ
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 20: There seems to have been a gap one pixel over
TimeSeries = TSF("ndmi", 20, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 20, dir) # Not significant enough to be seen in NDVI (and there's a cloud)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 20, dir) # EVI shows some real bright pixels; hard to say due to lack of 2014 data
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 21: Also looks like there was a gap one pixel over
TimeSeries = TSF("ndmi", 21, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 21, dir) # But not visible from NDVI
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 21, dir) # Nor EVI
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

## 22: Something happened one up north, but much later (in 2015)
TimeSeries = TSF("ndmi", 22, dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 22, dir) ## Break detected well
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 22, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 23: back to mainland; there may have been a gap made right before, but that pattern seems common
# The pixel to the north-east is #14
TimeSeries = TSF("ndmi", 23, dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 23, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 23, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 24: potentially one to the left was a gap
TimeSeries = TSF("ndmi", 24, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=12, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 24) # NDVI disagrees
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=12, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 24, dir) # EVI says that perhaps the central one, but again lack of 2014
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=12, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# 25: perhaps one to the east, but the magnitude is too small
TimeSeries = TSF("ndmi", 25, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("nbr", 25, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 25, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("evi", 25, dir)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
