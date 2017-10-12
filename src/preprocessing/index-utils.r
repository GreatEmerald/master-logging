# Functions to use in raster::overlay; these are for Sentinel-2/Landsat values
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

EVI = function(red, nir, blue)
{
    red = red/10000
    nir = nir/10000
    blue = blue/10000
    2.5 * (nir-red) / (nir+6*red-7.5*blue+1) * 10000
} 

MSAVI = function(red, nir)
{
    red = red/10000
    nir = nir/10000
    (2*nir+1 - sqrt((2*nir+1)^2 - 8*(nir-red)))/2 * 10000
}

NDVI = function(red, nir)
{
    (nir-red)/(nir+red) * 10000
}

NDMI = function(swir, nir)
{
    (nir-swir)/(nir+swir) * 10000
}

NBR = function(swir2, nir)
{
    (nir-swir2)/(nir+swir2) * 10000
}
