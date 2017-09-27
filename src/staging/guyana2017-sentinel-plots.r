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
library(lubridate)

# TODO: How far apart could the trees be for them to be clumped together? I look at 75 metres on both sides
# -> Looks like 40m is about right

GetSentinel2Date = function(ts)
{
    return(as.Date(getZ(ts)))
}

GetVIValues = function(ts, row, column)
{
    return(unlist(getValues(ts, row, 1)[column,]))
}

PlotTS = function(ts, row, column, ...)
{
    plot(GetSentinel2Date(ts), GetVIValues(ts, row, column)/10000, xlab="Date", ylab="", ...)
}

GetTSByID = function(id, vi, path="/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks")
{
    return(brick(list.files(file.path(path, vi), glob2rx(paste0(id, "*.grd")), full.names=TRUE)))
}

# Create a data frame of all pixels that belong to a treefall gap; "best" means that the effect is strongest for this tree and this VI
GapRegister = data.frame(tree_id=character(), vi=character(), row=integer(), column=integer(), best=logical())

AppendGapRegister = function(tree_id, vi, row, column, best)
{
    return(rbind(GapRegister, data.frame(tree_id, vi, row, column, best, stringsAsFactors=FALSE)))
}

# Note: "NDMI" means "everything except NDVI", because only NDVI is insensitive to shadows
# 8 8 is the central pixel; gaps can reasonably be within the 5-11 range
# First count down, then count right
# In Landsat: 1-3 is 1, 4-6 is 2, 7-9 is 3, 10-12 is 4, 13-15 is 5

GapRegister = AppendGapRegister("35", "NDVI", 9, 5, FALSE)
GapRegister = AppendGapRegister("35", "NDVI", 9, 4, FALSE)
GapRegister = AppendGapRegister("35", "NDVI", 10, 5, TRUE)

GapRegister = AppendGapRegister("36", "NDVI", 8, 9, TRUE)
GapRegister = AppendGapRegister("36", "NDVI", 8, 8, FALSE)
GapRegister = AppendGapRegister("36", "NDVI", 7, 9, FALSE)
GapRegister = AppendGapRegister("36", "NDVI", 7, 10, FALSE)
GapRegister = AppendGapRegister("36", "NDVI", 7, 11, FALSE) # This might actually be best
GapRegister = AppendGapRegister("36", "NDVI", 9, 9, FALSE)
GapRegister = AppendGapRegister("36", "NDVI", 8, 10, FALSE)
GapRegister = AppendGapRegister("36", "NDVI", 8, 11, FALSE)

GapRegister = AppendGapRegister("39", "NDVI", 9, 8, FALSE)
GapRegister = AppendGapRegister("39", "NDVI", 10, 8, FALSE)
GapRegister = AppendGapRegister("39", "NDVI", 10, 9, FALSE)
GapRegister = AppendGapRegister("39", "NDVI", 9, 9, TRUE)
GapRegister = AppendGapRegister("39", "NDMI", 10, 10, TRUE)
GapRegister = AppendGapRegister("39", "NDMI", 11, 9, FALSE)
GapRegister = AppendGapRegister("39", "NDMI", 9, 10, FALSE)
GapRegister = AppendGapRegister("39", "NDMI", 9, 9, FALSE)

GapRegister = AppendGapRegister("40", "NDVI", 6, 6, TRUE)
GapRegister = AppendGapRegister("40", "NDVI", 5, 6, FALSE)
GapRegister = AppendGapRegister("40", "NDVI", 7, 6, FALSE)
GapRegister = AppendGapRegister("40", "NDVI", 6, 5, FALSE)
GapRegister = AppendGapRegister("40", "NDVI", 6, 7, FALSE)
GapRegister = AppendGapRegister("40", "NDVI", 5, 5, FALSE)
GapRegister = AppendGapRegister("40", "NDVI", 7, 7, FALSE)
GapRegister = AppendGapRegister("40", "NDMI", 7, 7, FALSE)
GapRegister = AppendGapRegister("40", "NDMI", 6, 7, TRUE)
GapRegister = AppendGapRegister("40", "NDMI", 5, 7, FALSE)
GapRegister = AppendGapRegister("40", "NDMI", 7, 6, FALSE)
GapRegister = AppendGapRegister("40", "NDMI", 5, 6, FALSE)

GapRegister = AppendGapRegister("41", "NDVI", 8, 9, TRUE)
GapRegister = AppendGapRegister("41", "NDVI", 9, 9, FALSE)
GapRegister = AppendGapRegister("41", "NDVI", 8, 8, FALSE)
GapRegister = AppendGapRegister("41", "NDVI", 9, 8, FALSE)
GapRegister = AppendGapRegister("41", "NDVI", 8, 10, FALSE)
GapRegister = AppendGapRegister("41", "NDVI", 8, 11, FALSE)
GapRegister = AppendGapRegister("41", "NDMI", 9, 11, TRUE)
GapRegister = AppendGapRegister("41", "NDMI", 10, 11, FALSE)
GapRegister = AppendGapRegister("41", "NDMI", 8, 11, FALSE)
GapRegister = AppendGapRegister("41", "NDMI", 9, 10, FALSE)
GapRegister = AppendGapRegister("41", "NDMI", 9, 9, FALSE)
GapRegister = AppendGapRegister("41", "NDMI", 10, 9, FALSE)

GapRegister = AppendGapRegister("43", "NDVI", 6, 7, FALSE)
GapRegister = AppendGapRegister("43", "NDVI", 7, 7, TRUE)
GapRegister = AppendGapRegister("43", "NDVI", 7, 8, FALSE)
GapRegister = AppendGapRegister("43", "NDVI", 8, 8, FALSE)
GapRegister = AppendGapRegister("43", "NDMI", 8, 8, FALSE)
GapRegister = AppendGapRegister("43", "NDMI", 8, 7, FALSE)
GapRegister = AppendGapRegister("43", "NDMI", 5, 7, TRUE)
GapRegister = AppendGapRegister("43", "NDMI", 6, 8, FALSE)
GapRegister = AppendGapRegister("43", "NDMI", 7, 8, FALSE)
GapRegister = AppendGapRegister("43", "NDMI", 8, 9, FALSE)

GapRegister = AppendGapRegister("44", "NDVI", 6, 9, FALSE)
GapRegister = AppendGapRegister("44", "NDVI", 6, 8, TRUE)
GapRegister = AppendGapRegister("44", "NDVI", 7, 8, FALSE)
GapRegister = AppendGapRegister("44", "NDMI", 6, 10, FALSE)
GapRegister = AppendGapRegister("44", "NDMI", 7, 9, FALSE)
GapRegister = AppendGapRegister("44", "NDMI", 8, 8, TRUE)
GapRegister = AppendGapRegister("44", "NDMI", 7, 8, FALSE)

## This has been made into a log deck recently
GapRegister = AppendGapRegister("45", "NDVI", 10, 11, TRUE)
GapRegister = AppendGapRegister("45", "NDVI", 11, 12, FALSE)
GapRegister = AppendGapRegister("45", "NDVI", 10, 12, FALSE)
GapRegister = AppendGapRegister("45", "NDVI", 9, 11, FALSE)
GapRegister = AppendGapRegister("45", "NDMI", 10, 11, TRUE)
GapRegister = AppendGapRegister("45", "NDMI", 11, 12, FALSE)
GapRegister = AppendGapRegister("45", "NDMI", 10, 12, FALSE)
GapRegister = AppendGapRegister("45", "NDMI", 11, 13, FALSE)

GapRegister = AppendGapRegister("47", "NDMI", 7, 8, TRUE)

GapRegister = AppendGapRegister(tree_id="48", vi="NDVI", row=8+1, column=9-4, best=TRUE)
GapRegister = AppendGapRegister("48", "NDVI", 8+1, 10-4, FALSE)
GapRegister = AppendGapRegister("48", "NDVI", 7+1, 9-4, FALSE)
GapRegister = AppendGapRegister("48", "NDVI", 7+1, 10-4, FALSE)
GapRegister = AppendGapRegister("48", "NDVI", 7+1, 11-4, FALSE)
GapRegister = AppendGapRegister("48", "NDMI", 8+1, 10-4, TRUE)
GapRegister = AppendGapRegister("48", "NDMI", 8+1, 11-4, FALSE)
GapRegister = AppendGapRegister("48", "NDMI", 9+1, 10-4, FALSE)
GapRegister = AppendGapRegister("48", "NDMI", 9+1, 9-4, FALSE)
GapRegister = AppendGapRegister("48", "NDMI", 7+1, 11-4, FALSE)
GapRegister = AppendGapRegister("48", "NDMI", 7+1, 10-4, FALSE)

# This is the same general area as 48/49; they are closer to this point, so only consider the gap to the west
## There is change in NDVI, but no change in others: existing gap
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/35_80-1_20-1_60-1.grd")
spplot(ndvi)
PlotTS(ndvi, 8, 9)
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/35_80-1_20-1_60-1.grd")
spplot(evi)
nbr = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NBR/35_80-1_20-1_60-1.grd")
spplot(nbr)
msavi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/MSAVI/35_80-1_20-1_60-1.grd")
spplot(msavi)
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/35_80-1_20-1_60-1.grd")
spplot(ndmi)

# Other trees
## Seems like there was a gap there before just as well! Only new gap in the extreme north-west, and it's the same as 35
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/36_40-3.grd")
spplot(ndmi) ## But NDVI does show something; but one timestep later, could be delayed logging? Looks like it!
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/36_40-3.grd")
spplot(ndvi)

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
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/38_20-4.grd")
spplot(ndvi)

## Also already a gap; but it got bigger
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
pdf("../../thesis/thesis-figures/08-guyana-ts-ndmi.pdf", 5, 3)
PlotTS(ndmi, 9, 11, main="NDMI")
abline(v=as.Date("2017-01-18"))
dev.off()
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
## Smiley face
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
# And then it got turned into a log deck!
ndmi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDMI/45_80-10_20-8.grd")
spplot(ndmi, at=seq(4000, -1000, -100)) ## Actually there is something faint to the south-east! Have to change scale to filter out negative 4000
ndvi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/NDVI/45_80-10_20-8.grd")
spplot(ndvi)
evi = brick("/run/media/dainius/Landsat/Guyana2017/sentinel2/stacks/EVI/45_80-10_20-8.grd")
spplot(evi)

# Also was already a clearing (pretty much the same place, but right in the log deck)
ndmi = GetTSByID("46", "NDMI")
spplot(ndmi)
ndvi = GetTSByID("46", "NDVI")
spplot(ndvi)
evi = GetTSByID("46", "EVI")
spplot(evi)

# And also was already a clearing (this is right on a road); but one pixel may be different
ndmi = GetTSByID("47", "NDMI")
spplot(ndmi)
PlotTS(ndmi, 7, 8)
ndvi = GetTSByID("47", "NDVI")
spplot(ndvi) # NDVI looks pretty beautiful, but not super useful; too cloudy
evi = GetTSByID("47", "EVI")
spplot(evi)

# Gap to south-west; this is the same gap as in 35, but this tree is 100cm diameter
# NDVI: mostly useless; there are faint marks that something happened
# But! It's pretty clear later on that the gaps are there
# EVI: pretty good, shows an earlier gap and then the new one
# NBR: Just as good as EVI
# MSAVI: also pretty good, both gaps are visible
## NDMI: may be the best, both gaps are vividly standing out; but this is a shadow map!
ndmi = GetTSByID("48", "NDMI")
spplot(ndmi)
PlotTS(ndmi, 9, 6)

# This is exacly the same area as 48
ndmi = GetTSByID("49", "NDMI")
spplot(ndmi)

# Nothing, existing gaps disappeared
ndmi = GetTSByID("50", "NDMI")
spplot(ndmi, at=seq(5500, -1000, -100)) ## Actually could be a new gap, but only one non-cloudy image for NDVI
ndvi = GetTSByID("50", "NDVI")
spplot(ndvi) # EVI is weird
evi = GetTSByID("50", "EVI")
spplot(evi)
msavi = GetTSByID("50", "MSAVI")
spplot(msavi)

## Overall, MSAVI==EVI, NBR==NDMI, NDVI only sees huge changes i.e. soil in gaps
## We can see 6/16(15) gaps, ~60cm with NDVI, ~80cm with NDMI
## all 100cm visible except ones next to roads, some 80cms visible, one 60cm faintly visible, others not or in clearings
## On Landsat, these would be 1 pixel max, rarely 2, and if on border, would not be visible at all

## Analysis

# Is this date before or after logging; based on LoggedTrees.csv
GetBeforeAfter = function(id, date)
{
    if (as.numeric(id) < 45)
    {
        if (date > "2017-01-18")
            return("After")
        else
            return("Before")
    }
    if (as.numeric(id) < 47)
    {
        if (date > "2017-01-23")
            return("After")
        else
            return("Before")
    }
    if (id == "47")
    {
        if (date > "2017-01-25")
            return("After")
        else
            return("Before")
    }
    if (id == "48")
    {
        if (date > "2017-01-26")
            return("After")
        else
            return("Before")
    }
    if (id == "49")
    {
        if (date > "2017-02-08")
            return("After")
        else
            return("Before")
    }
    if (id == "50")
    {
        if (date > "2017-02-13")
            return("After")
        else
            return("Before")
    }
}

# Filter out pixels on clouded days, based on context in QGIS
IsClouded = function(id, date)
{
    # 10-05 is suspect; but can't say that it's clouds outright
    # Same with 11-24
    if (date == "2016-12-04" && id != "47")
        return(TRUE)
    if (date == "2016-11-24" && ((as.numeric(id) >= 40 &&  as.numeric(id) <= 44) || id == "47"))
        return(TRUE)
    if (date == "2017-08-21" && (id == "36" || id == "47"))
        return(TRUE)
    if (date == "2016-12-14" && (id == "39" || id == "45" || id == "46"))
        return(TRUE)
    if (date == "2016-10-05" && id == "47")
        return(TRUE)
    if (date == "2017-01-13" && id == "47")
        return(TRUE)
    if (date == "2017-02-12" && id == "47")
        return(TRUE)
    if (date == "2017-03-14" && id == "50")
        return(TRUE)
    if (date == "2017-04-23" && id == "47")
        return(TRUE)
    if (date == "2017-09-10" && id == "50")
        return(TRUE)
    return(FALSE)
}

# Create a long list of individual pixel values with dates
GetPixelValues = function(register, vi, filter_clouds=FALSE)
{
    PixelValues = data.frame()
    for (i in 1:nrow(register))
    {
        if (vi == register[i,]$vi || (register[i,]$vi == "NDMI" && (vi == "MSAVI" || vi == "EVI" || vi == "NBR")))
        {
            TS = GetTSByID(register[i,]$tree_id, vi)
            Values = GetVIValues(TS, register[i,]$row, register[i,]$column)
            Dates = GetSentinel2Date(TS)
            for (n in 1:length(Values))
            {
                if (!is.na(Values[n]) && (!filter_clouds || !IsClouded(register[i,]$tree_id, Dates[n])))
                {
                    When = GetBeforeAfter(register[i,]$tree_id, Dates[n])                
                    PixelValues = rbind(PixelValues, data.frame(Value=Values[n], Date=Dates[n], When=When))
                }
            }
        }
    }
    return(PixelValues)
}

## Plot everything

# Not the best
AllNDVIs = GetPixelValues(GapRegister, "NDVI")
pdf("../../thesis/thesis-figures/03-boxplot-ndvi.pdf", 3, 4)
boxplot(Value/10000~When, data=AllNDVIs, main="NDVI")
dev.off()
t.test(Value/10000~When, data=AllNDVIs) # Significant; before 0.83, after 0.75

# The best
AllNDMIs = GetPixelValues(GapRegister, "NDMI")
pdf("../../thesis/thesis-figures/04-boxplot-ndmi.pdf", 3, 4)
boxplot(Value/10000~When, data=AllNDMIs, main="NDMI")
dev.off()
t.test(Value/10000~When, data=AllNDMIs) # Significant; before 0.31, after 0.15

# Second best; with filtering may be the best
AllNBRs = GetPixelValues(GapRegister, "NBR")
pdf("../../thesis/thesis-figures/05-boxplot-nbr.pdf", 3, 4)
boxplot(Value/10000~When, data=AllNBRs, main="NBR")
dev.off()
t.test(Value/10000~When, data=AllNBRs) # Significant; before 0.63, after 0.48

# Like NDVI
AllMSAVIs = GetPixelValues(GapRegister, "MSAVI")
pdf("../../thesis/thesis-figures/06-boxplot-msavi.pdf", 3, 4)
boxplot(Value/10000~When, data=AllMSAVIs, main="MSAVI")
dev.off()
t.test(Value/10000~When, data=AllMSAVIs) # Significant; before 0.54, after 0.44

# Like NDVI
AllEVIs = GetPixelValues(GapRegister, "EVI")
pdf("../../thesis/thesis-figures/07-boxplot-evi.pdf", 3, 4)
boxplot(Value/10000~When, data=AllEVIs, main="EVI")
dev.off()
t.test(Value/10000~When, data=AllEVIs) # Significant; before 0.54, after 0.47

## Plot best pixels only

# Very poor
BestNDVIs = GetPixelValues(GapRegister[GapRegister$best == TRUE,], "NDVI", TRUE)
boxplot(Value/10000~When, notch=TRUE, data=BestNDVIs)
t.test(Value/10000~When, data=BestNDVIs) ## Insignificant; before 0.82, after 0.81; why?!

# The best
BestNDMIs = GetPixelValues(GapRegister[GapRegister$best == TRUE,], "NDMI", TRUE)
boxplot(Value/10000~When, data=BestNDMIs)
t.test(Value/10000~When, data=BestNDMIs) # Significant, before 0.33, after 0.10

# Second best
BestNBRs = GetPixelValues(GapRegister[GapRegister$best == TRUE,], "NBR", TRUE)
boxplot(Value/10000~When, data=BestNBRs)
t.test(Value/10000~When, data=BestNBRs) # Significant but barely; before 0.59, after 0.51

# Better than NDVI
BestMSAVIs = GetPixelValues(GapRegister[GapRegister$best == TRUE,], "MSAVI", TRUE)
boxplot(Value/10000~When, data=BestMSAVIs)
t.test(Value/10000~When, data=BestMSAVIs) # Insignificant; before 0.47, after 0.46

# Better than NDVI
BestEVIs = GetPixelValues(GapRegister[GapRegister$best == TRUE,], "EVI", TRUE)
boxplot(Value/10000~When, data=BestEVIs)
t.test(Value/10000~When, data=BestEVIs) # Insignificant; before 0.49, after 0.46

## Control: select 4 furthest pixels in each

ControlRegister = expand.grid(tree_id=seq(35,50,1), vi=c("NDVI", "NDMI"), row=c(1, 15), column=c(1,15), best=FALSE)

ControlNDVIs = GetPixelValues(ControlRegister, "NDVI", TRUE)
boxplot(Value/10000~When, notch=TRUE, data=ControlNDVIs)
ControlNDMIs = GetPixelValues(ControlRegister, "NDMI", TRUE)
boxplot(Value/10000~When, notch=TRUE, data=ControlNDMIs)
ControlNBRs = GetPixelValues(ControlRegister, "NBR", TRUE)
boxplot(Value/10000~When, notch=TRUE, data=ControlNBRs)
ControlMSAVIs = GetPixelValues(ControlRegister, "MSAVI", TRUE)
boxplot(Value/10000~When, notch=TRUE, data=ControlMSAVIs)
ControlEVIs = GetPixelValues(ControlRegister, "EVI", TRUE)
boxplot(Value/10000~When, notch=TRUE, data=ControlEVIs)
