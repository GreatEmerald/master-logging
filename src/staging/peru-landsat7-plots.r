# Scratchpad for plotting time series of Peru Landsat 7
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

TSF = function(VI, index, dir="/run/media/dainius/Landsat/Peru/landsat7/time-stacks/")
{
    TS = brick(list.files(file.path(dir, VI), glob2rx(paste0(index, "*.grd")), full.names=TRUE)[1])
    TS = setZ(TS, getSceneinfo(names(TS))$date)
    return(TS)
}

# Remove all NAs, order by date
CleanTSIDs = function(TS)
{
    Order = order(getZ(TimeSeries))
    OrderNonNA = integer()
    for (i in 1:nlayers(TS))
    {
        if (!all(is.na(getValues(TimeSeries[[Order[i]]]))))
            OrderNonNA = c(OrderNonNA, Order[i])
    }
    return(OrderNonNA)
}

TimeSeries = TSF("ndmi", 1)
spplot(TimeSeries, order(getZ(TimeSeries)))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# Should be one to the left
# It did go down a bit, but very slightly
TimeSeries = TSF("ndmi", 10)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=12, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
TimeSeries = TSF("ndvi", 10) # Nothing in NDVI
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=12, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# Should be a bit to the north
# This is right next to a clearing; pixels to the south-west are from when it was cleared
TimeSeries = TSF("ndmi", 11)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) ## Showing off the clear-cuts: 2006 to the south-east
BP = bfmPixel(TimeSeries, start=c(2001.7), cell=19, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) ## 2001, 2006, 2009 and 2015 to the south-west
pdf("../../thesis/thesis-figures/13-peru-shifting.pdf", 9, 6)
BP = bfmPixel(TimeSeries/10000, start=c(2001), cell=16, formula=response~harmon, order=1)
plot(BP$bfm); #abline(v=2013.7); abline(v=2013.74) ## Looks like it regenerates in slightly less than a year
dev.off()
TimeSeries = TSF("ndvi", 11)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) ## Showing off the clear-cuts: 2006 to the (south-)east; see how NDVI later on increases
BP = bfmPixel(TimeSeries, start=c(2006), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
pdf("../../thesis/thesis-figures/14-peru-shifting-ndvi.pdf", 9, 5)
BP = bfmPixel(TimeSeries/10000, start=c(2006), cell=19, formula=response~harmon, order=1)
plot(BP$bfm)#; abline(v=2013.7); abline(v=2013.74)
dev.off()

# This is also next to the clearing; it is a very obvious single tree that got cut down in Google, right in the centre
TimeSeries = TSF("ndmi", 12)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) ## There is a slight decrease, but also because of clouds
BP = bfmPixel(TimeSeries, start=c(2006), cell=7, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) ## Clear-cut is clear
TimeSeries = TSF("ndvi", 12)
spplot(TimeSeries, CleanTSIDs(TimeSeries)) ## Also a nice visual on a clear-cut becoming brighter after a year
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) # There is a slight decrease, but mostly because of clouds
BP = bfmPixel(TimeSeries, start=c(2006), cell=7, formula=response~harmon, order=1)
plot(BP$bfm)#; abline(v=2013.7); abline(v=2013.74) ## Very good visualisation of NDVI increasing afterwards

# This should be a small tree to the east; the clearing is visible from here too
TimeSeries = TSF("ndmi", 13)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) ## Also slightly lower
TimeSeries = TSF("ndvi", 13)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) # This is a cloud, nothing out of the ordinary

# This should be right at the border between centre and one south; pretty obvious in Google
TimeSeries = TSF("ndmi", 14)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) ## Nothing too interesting, but this was a seasonal tree: the dynamic range has been compressed
TimeSeries = TSF("ndvi", 14)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# This is a big one, but split between this and the south pixel
TimeSeries = TSF("ndmi", 15)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) # A cloud, and then it became a bit brighter
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) # Same; odd considering that it's shadowed, but pixel border effect
TimeSeries = TSF("ndvi", 15)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) # Two clouds
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=18, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# Google shows very obvious tree right in the middle
TimeSeries = TSF("ndmi", 16)
spplot(TimeSeries, CleanTSIDs(TimeSeries)) # Something weird is going on to the west, not sure why
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) # No big change, but then there's a temporal gap
TimeSeries = TSF("ndvi", 16)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) # No real change

# Google shows that this is one to the left and one down (pixel effect)
TimeSeries = TSF("ndmi", 17)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74) # A cloud and a gap in time, nothing of worth
TimeSeries = TSF("ndvi", 17)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=14, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.7); abline(v=2013.74)

# Also not really obvious. One left maybe?
## 11-28: spot-on post-logging date!
TimeSeries = TSF("ndmi", 18)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.8); abline(v=2013.9) # But nothing real interesting
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=12, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.8); abline(v=2013.9) # Break detected but much later... I don't think it's right
TimeSeries = TSF("ndvi", 18)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.8); abline(v=2013.9)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=12, formula=response~harmon, order=1)
plot(BP$bfm); abline(v=2013.8); abline(v=2013.9)

# Start of gaps
TimeSeries = TSF("ndmi", 19)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 19)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=12, formula=response~harmon, order=1)
plot(BP$bfm) # Looks like this should have been a gap showing bare soil in 2011, but too coarse

TimeSeries = TSF("ndmi", 20)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # Maybe a bit lighter than usual?..
TimeSeries = TSF("ndvi", 20)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# Looks like a tree was cut down here at around that time
TimeSeries = TSF("ndmi", 21)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # Maybe a bit lighter than usual?..
TimeSeries = TSF("ndvi", 21)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

## Google Earth shows a post-2010 gap that's right at the border between this and the north pixel
# See landsat 8 also
TimeSeries = TSF("ndmi", 22)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # One north seems to be sometimes darker, but more recently than 2013
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 22)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=8, formula=response~harmon, order=1)
plot(BP$bfm)

# No change in Google Earth, but the tree does cast a large shadow
TimeSeries = TSF("ndmi", 23)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) ## In 2013 it became VERY dark: this is not a cloud! The next pixel is a cloud though
TimeSeries = TSF("ndvi", 23)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # Less visible in NDVI

# Google shows a pretty large tree cut down post-2011
TimeSeries = TSF("ndmi", 24)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # No clear pattern though
TimeSeries = TSF("ndvi", 24)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2013.7), cell=13, formula=response~harmon, order=1)
plot(BP$bfm) # If anything it's a bit higher; there was something to the west, but that's too far

# 25 is same as 17
