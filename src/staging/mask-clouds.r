# Masks clouds in Landsat imagery by applying FMask output to images.
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


# Input: Directory with input Landsat images, or a list of files; directory with FMask outputs, or a list of files;
#        output directory.
# Output: Landsat images with all clouded areas set to NA.

# NOTE: Due to the big data nature, we can't process everything at once, this needs to be done in batches.
# Therefore the script first checks if the output files already exist, if not, processes the input.
# That avoids the problem of mixing different batches together.
# It also optionally removes the input data to save disk space after processing is deemed successful.


