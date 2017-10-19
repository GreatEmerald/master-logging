# Plotting time series of Guyana 2017 Landsat 8
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

dir="../data/output/Guyana2017/landsat8/"

cut.val = -10
theme.novpadding = list()
#     list(layout.heights =
#          list(top.padding = 0,
#               main.key.padding = 0,
#               key.axis.padding = 0,
#               axis.xlab.padding = 0,
#               xlab.key.padding = 0,
#               key.sub.padding = 0,
#               bottom.padding = 0),
#          layout.widths =
#          list(left.padding = cut.val,
#               key.ylab.padding = 0,
#               ylab.axis.padding = 0,
#               axis.key.padding = 0,
#               right.padding = cut.val))

# 35: it did get lower, but then it went back again.
TimeSeries = TSF("evi", 35, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
## 35 with NDMI: the pixel of interest seems to be one over (This is confirmed by Sentinel); it is actualy tree 48
# Tree 35 would be one to the west (cell 12) and there is no change
TimeSeries = TSF("ndmi", 35, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
pdf("../../thesis/thesis-figures/09-guyana17-landsat-ndmi-undetected.pdf", 7, 5)
BP = bfmPixel(TimeSeries/10000, start=c(2017, 01), cell=14, formula=response~harmon, order=1, history="all")
plot(BP$bfm)
dev.off()
# 35 NBR: goes down way after
TimeSeries = TSF("nbr", 35, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)
# 35 with MSAVI: save as EVI
TimeSeries = TSF("msavi", 35, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)
# 35 with NDVI: also one over
TimeSeries = TSF("ndvi", 35, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)

## 36: also seemingly one over, and indeed was a gap already (confirmed one over by Sentinel)
TimeSeries = TSF("ndmi", 36, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 36, dir) # Invisible in NDVI
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("evi", 36, dir) # Invisible in EVI
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)

# 37: nothing obvious
TimeSeries = TSF("ndmi", 37, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)

## 38: a new gap to northwest; confirmed by Sentinel to be prior art (area is clouded in Landsat)
TimeSeries = TSF("ndmi", 38, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 39: nothing obvious; there is a cloud to the west, so can't be sure about this one
# Sentinel comparison shows that the gap was split into four pixels, two of which are to the (south) west
TimeSeries = TSF("ndmi", 39, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=17, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 39, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("nbr", 39, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 40: Either north or south, nothing happened in the middle
## However: only one full scene available after cutting down; north pixels seem to be new
TimeSeries = TSF("ndmi", 40, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=12, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=7, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 40, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=12, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=7, formula=response~harmon, order=1)
plot(BP$bfm)

## 41: This seems to be visible! But it was pretty dark already.
TimeSeries = TSF("ndmi", 41, dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # Same from NDVI, but 8.5 is not too low
TimeSeries = TSF("ndvi", 41, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("evi", 41, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("nbr", 41, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 42: Gap to the north is 41, there is also something to the south, nothing in the middle
# Sentinel says south ones are prior art
TimeSeries = TSF("ndmi", 42, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 43: Something to east-south-east, also north and west (sentinel says all prior art), but not central
TimeSeries = TSF("ndmi", 43, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # east-south-east and north are visible in NDVI too
TimeSeries = TSF("ndvi", 43, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("nbr", 43, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # EVI is confused, cloud?
TimeSeries = TSF("evi", 43, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # So is MSAVI
TimeSeries = TSF("msavi", 43, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

## 44: Seems to be visible! Though was dark before too; break detected
# Sentinel says this is because the gap is new, but it's not that new (that time period is clouded in Landsat)
TimeSeries = TSF("ndmi", 44, dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries), par.settings = theme.novpadding)
pdf("../../thesis/thesis-figures/10-guyana17-landsat-ndmi-detected.pdf", 7, 5)
BP = bfmPixel(TimeSeries/10000, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
dev.off()
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm) # Central pixel stands out in NBR
TimeSeries = TSF("nbr", 44, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm) # Visible in NDVI too, but central pixel was darker before too
TimeSeries = TSF("ndvi", 44, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm) # Also visible in EVI
TimeSeries = TSF("evi", 44, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("msavi", 44, dir)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)

# 45: A road in 2016 indeed. Hard to say if anything changed in central
## Log deck detection
TimeSeries = TSF("ndmi", 45, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2016), cell=7, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 45, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)
pdf("../../thesis/thesis-figures/11-guyana17-landsat-ndvi-deck.pdf", 7, 4)
BP = bfmPixel(TimeSeries/10000, start=c(2016), cell=7, formula=response~harmon, order=1)
plot(BP$bfm)
dev.off()

# 46: Same road, indeed the break was earlier.
TimeSeries = TSF("ndmi", 46, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) ## Example of break detection
BP = bfmPixel(TimeSeries, start=c(2016, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 47: A road circa 2014.
TimeSeries = TSF("ndmi", 47, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=8, formula=response~harmon, order=1)
plot(BP$bfm) ## Another example: logging road detection
BP = bfmPixel(TimeSeries, start=c(2014, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 47, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
pdf("../../thesis/thesis-figures/12-guyana17-landsat-ndvi-road.pdf", 7, 5)
BP = bfmPixel(TimeSeries/10000, start=c(2014, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
dev.off()

## 48: Potential new gap to south-west, same as 35 (sentinel-confirmed)
TimeSeries = TSF("ndmi", 48, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=17, formula=response~harmon, order=1)
plot(BP$bfm) # But not notable enough.
TimeSeries = TSF("ndvi", 48, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=17, formula=response~harmon, order=1)
plot(BP$bfm)

# 49: Duplicate pixel of 48
TimeSeries = TSF("ndmi", 49, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 50: Road circa 2015
## Road detection
TimeSeries = TSF("ndmi", 50, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2015, 01), cell=5, formula=response~harmon, order=1)
plot(BP$bfm) # Two timesteps with clouds in EVI
TimeSeries = TSF("evi", 50, dir)
spplot(TimeSeries, order(getZ(TimeSeries)), par.settings = theme.novpadding)
BP = bfmPixel(TimeSeries, start=c(2017, 01), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # Detected
BP = bfmPixel(TimeSeries, start=c(2015, 01), cell=5, formula=response~harmon, order=1)
plot(BP$bfm)
