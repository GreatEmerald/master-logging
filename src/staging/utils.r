# Utility functions for Landsat 7 visualisation

TSF = function(VI, index, dir="/run/media/dainius/Landsat/Peru/landsat7/time-stacks/")
{
    TS = brick(list.files(file.path(dir, VI), glob2rx(paste0(index, "*.grd")), full.names=TRUE)[1])
    TS = setZ(TS, getSceneinfo(names(TS))$date)
    return(TS)
}

# Remove all NAs, order by date
CleanTSIDs = function(TS)
{
    Order = order(getZ(TS))
    OrderNonNA = integer()
    for (i in 1:nlayers(TS))
    {
        if (!all(is.na(getValues(TS[[Order[i]]]))))
            OrderNonNA = c(OrderNonNA, Order[i])
    }
    return(OrderNonNA)
}
