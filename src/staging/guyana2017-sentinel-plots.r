# spplots for Guyana 2017 Sentinel-2 imagery
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

# TODO: How far apart could the trees be for them to be clumped together? I look at 75 metres on both sides
# -> Looks like 40m is about right

GetSentinel2Date = function(filename)
{
    result = character()
    for (i in 1:length(filename))
        result = c(result, strsplit(grep(glob2rx("????????T??????"), unlist(strsplit(filename[i], "_")), value=TRUE), "T")[[1]][1])
    return(result)
}

PlotTS = function(ts, row, column, ...)
{
    plot(GetSentinel2Date(names(ts)), unlist(getValues(ts, row, 1)[column,]), xlab="Date", ylab="Vegetation index", ...)
}

# NDVI: mostly useless; there are faint marks that something happened
# But! It's pretty clear later on that the gaps are there
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/35_80-1_20-1_60-1.grd")
spplot(ndvi)
PlotTS(ndvi, 8, 9)
# EVI: pretty good, shows an earlier gap and then the new one
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/35_80-1_20-1_60-1.grd")
spplot(evi)
# NBR: Just as good as EVI
nbr = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NBR/35_80-1_20-1_60-1.grd")
spplot(nbr)
# MSAVI: also pretty good, both gaps are visible
msavi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/MSAVI/35_80-1_20-1_60-1.grd")
spplot(msavi)
## NDMI: may be the best, both gaps are vividly standing out; but this is a shadow map!
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/35_80-1_20-1_60-1.grd")
spplot(ndmi)
PlotTS(ndmi, 8, 10)

# Other trees
## Seems like there was a gap there before just as well! Only new gap in the extreme north-west, and it's the same as 35
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/36_40-3.grd")
spplot(ndmi)
# One pixel to the south maybe (but faint), also plenty of older gaps around
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/37_60-4_20-3.grd")
spplot(ndmi) # Nothing new in NDVI
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/37_60-4_20-3.grd")
spplot(ndvi) # EVI and NDMI are chaotic
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/37_60-4_20-3.grd")
spplot(evi)
## Central pixel already had a gap
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/38_20-4.grd")
spplot(ndmi)
## Also already a gap
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/39_60-5.grd")
spplot(ndmi) ##...but not according to NDVI! 
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/39_60-5.grd")
spplot(ndvi) # All other indices agree that it's prior art though
nbr = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NBR/39_60-5.grd")
spplot(nbr)
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/39_60-5.grd")
spplot(evi)
msavi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/MSAVI/39_60-5.grd")
spplot(msavi)
## Two gaps to the north (closest one deepened a lot, further one is a different tree)
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/40_80-4.grd")
spplot(ndmi) # Including visible from NDVI
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/40_80-4.grd")
spplot(ndvi)
nbr = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NBR/40_80-4.grd")
spplot(nbr) # MSAVI and EVI say it's prior art
msavi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/MSAVI/40_80-4.grd")
spplot(msavi)
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/40_80-4.grd")
spplot(evi)

## GIANT gap appeared east!
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/41_100-6.grd")
spplot(ndmi) # NBR shows it a bit cleaner
PlotTS(ndmi, 9, 11)
nbr = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NBR/41_100-6.grd")
spplot(nbr) ## Even visible from NDVI
PlotTS(nbr, 9, 11)
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/41_100-6.grd")
spplot(ndvi) # EVI/MSAVI agrees but had shadow problems
PlotTS(ndvi, 8, 9)
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/41_100-6.grd")
spplot(evi)
msavi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/MSAVI/41_100-6.grd")
spplot(msavi)
# Two gaps to the north, these are 40-41
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/42_40-10_40-11_60-8.grd")
spplot(ndmi) # Nothing much happened in NDVI; slight tint change
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/42_40-10_40-11_60-8.grd")
spplot(ndvi)
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/42_40-10_40-11_60-8.grd")
spplot(evi)
## One gap immediately to the west
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/43_80-7.grd")
spplot(ndmi) # Poorly visible in NBR
nbr = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NBR/43_80-7.grd")
spplot(nbr) ## There is a small change in NDVI
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/43_80-7.grd")
spplot(ndvi) # EVI shows it too
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/43_80-7.grd")
spplot(evi)
## Existing gaps deepened; possibly new gap-branch to the south
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/44_100-8.grd")
spplot(ndmi) # NDVI also shows the gap deepen but later
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/44_100-8.grd")
spplot(ndvi)
# There already was a huge clearing; looks like it's a former (c. 2016) logging road
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/45_80-10_20-8.grd")
spplot(ndmi)
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/45_80-10_20-8.grd")
spplot(ndvi)
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/45_80-10_20-8.grd")
spplot(evi)
# Also was already a clearing (pretty much the same place)
ndmi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/", glob2rx("46*.grd"), full.names=TRUE))
spplot(ndmi)
ndvi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/", glob2rx("46*.grd"), full.names=TRUE))
spplot(ndvi)
evi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/", glob2rx("46*.grd"), full.names=TRUE))
spplot(evi)
# And also was already a clearing (this is right on a road)
ndmi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/", glob2rx("47*.grd"), full.names=TRUE))
spplot(ndmi) # NDVI looks pretty beautiful, but not super useful
ndvi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/", glob2rx("47*.grd"), full.names=TRUE))
spplot(ndvi)
evi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/", glob2rx("47*.grd"), full.names=TRUE))
spplot(evi)
# Gap to south-west; this is the same gap as in 35, but this tree is 100cm diameter
ndmi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/", glob2rx("48*.grd"), full.names=TRUE))
spplot(ndmi)
# This is generally the same area as 48 and 35
ndmi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/", glob2rx("49*.grd"), full.names=TRUE))
spplot(ndmi)
# Nothing, existing gaps disappeared
ndmi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/", glob2rx("50*.grd"), full.names=TRUE))
spplot(ndmi) ## Actually could be a new gap, but only one non-cloudy image for NDVI
ndvi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/", glob2rx("50*.grd"), full.names=TRUE))
spplot(ndvi) # EVI is weird
evi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/", glob2rx("50*.grd"), full.names=TRUE))
spplot(evi)
msavi = brick(list.files("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/MSAVI/", glob2rx("50*.grd"), full.names=TRUE))
spplot(msavi)

## Overall, MSAVI==EVI, NBR==NDMI, NDVI only sees huge changes i.e. soil in gaps
## We can see 6/16(15) gaps, ~60cm with NDVI, ~80cm with NDMI
## all 100cm visible except ones next to roads, some 80cms visible, one 60cm faintly visible, others not or in clearings
## On Landsat, these would be 1 pixel max, rarely 2, and if on border, would not be visible at all
