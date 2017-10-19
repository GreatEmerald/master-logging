# Utility functions for Landsat 7 visualisation
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

TSF = function(VI, index, dir="../data/output/Peru/landsat7/")
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
