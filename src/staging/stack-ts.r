#!/usr/bin/env Rscript
# Creates a time series stack for each VI (optionally for each tree)
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

StackTS = function()
{
    # See if this is running in point or tile mode
    # If point mode, load tree information with extents
    # If tile mode, there is no reason to save the stack to disk, that will just eat too much space.
    timeStack()
}
