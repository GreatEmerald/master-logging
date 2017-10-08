# Scratchpad for plotting time series of Guyana 2014 Landsat 8

library(bfastSpatial)

source("staging/utils.r")

dir = "/run/media/dainius/Landsat/Guyana2014/Landsat8/time-stacks/"
dir7 = "/run/media/dainius/Landsat/Guyana2014/Landsat7/time-stacks/"

# 26: clouded
TimeSeries = TSF("ndmi", 26, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

TS7 = TSF("ndmi", 26, dir=dir7)
spplot(TS7, CleanTSIDs(TS7))

# 27: clouded
TimeSeries = TSF("ndmi", 27, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 27, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

## 28: history is clouded, but looks like there is something, then regrowth, then logged again; or maybe it's seasonality
TimeSeries = TSF("ndmi", 28, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 28, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
# And yet nothing persistent in Landsat 7; however it disappears by 2015-05, so maybe that one observation north at 2015-04 is it
TS7 = TSF("ndmi", 28, dir=dir7)
spplot(TS7, CleanTSIDs(TS7))

# 29: Road, also disappears from time to time; NDVI seems oversaturated, so cloud shadow?
TimeSeries = TSF("ndmi", 29, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 29, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 30: lack of history, otherwise it's hard to tell
TimeSeries = TSF("ndmi", 30, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 30, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

# 31: No history and nothing obvious; individual pixels light up in 2017
TimeSeries = TSF("ndmi", 31, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 31, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)

## 32: pixel to the west is always darker (but also in history) including in NDVI
TimeSeries = TSF("ndmi", 32, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=12, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 32, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=12, formula=response~harmon, order=1)
plot(BP$bfm)
# In Landsat 7 it is mostly one pixel further and dates back to 2014-06; temporary fluctuations in NDVI
TS7 = TSF("ndmi", 32, dir=dir7)
spplot(TS7, CleanTSIDs(TS7))
TS7 = TSF("ndvi", 32, dir=dir7)
spplot(TS7, CleanTSIDs(TS7))

## 33: one pixel north is a thing in NDMI, even though initially not completely visible
TimeSeries = TSF("ndmi", 33, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=8, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 33, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=8, formula=response~harmon, order=1)
plot(BP$bfm)
# Landsat 7 disagrees
TS7 = TSF("ndmi", 33, dir=dir7)
spplot(TS7, CleanTSIDs(TS7))
TS7 = TSF("ndvi", 33, dir=dir7)
spplot(TS7, CleanTSIDs(TS7))
bfmPixel(TS7, start = c(2014, 1), cell=8, formula=response~harmon, order=1, plot=TRUE)

## 34: one pixel east may also be a thing in NDMI, but too little history to tell
TimeSeries = TSF("ndmi", 34, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=14, formula=response~harmon, order=1)
plot(BP$bfm)
TimeSeries = TSF("ndvi", 34, dir=dir)
spplot(TimeSeries, CleanTSIDs(TimeSeries))
BP = bfmPixel(TimeSeries, start=c(2017), cell=13, formula=response~harmon, order=1)
plot(BP$bfm)
# Landsat 7 says prior art since 2013-11
TS7 = TSF("ndmi", 34, dir=dir7)
spplot(TS7, CleanTSIDs(TS7))
