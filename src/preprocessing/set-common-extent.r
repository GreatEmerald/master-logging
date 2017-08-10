# Function for extending full tiles to a common extent
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
library(foreach)
library(doParallel)
library(tools)

ExtendToMaxCommonExtent = function(input_dir, pattern=NULL, output_dir, threads=1)
{
    if (is.null(pattern))
        pattern = "*.tif"
    
    FilesToCrop = list.files(input_dir, pattern=glob2rx(pattern), full.names = TRUE)
    for (i in 1:length(FilesToCrop))
    {
        Image = raster(FilesToCrop[i])
        if (!exists("Extents"))
        {
            Extents = as.numeric(bbox(Image))
        } else
            Extents = rbind(Extents, as.numeric(bbox(Image)))
    }
    rm(Image)
    colnames(Extents) = c("xmin", "ymin", "xmax", "ymax")
    rownames(Extents) = NULL
    EnlargeExtent = extent(min(Extents[,"xmin"]), max(Extents[,"xmax"]),
        min(Extents[,"ymin"]), max(Extents[,"ymax"]))

    psnice(value = min(threads - 1, 19))
    registerDoParallel(cores = threads)
    foreach(i=1:length(FilesToCrop), .inorder = FALSE, .packages = "raster", .verbose=TRUE) %dopar%
    {
        ImageName = FilesToCrop[i]
        print(paste("Processing:", ImageName))
        Image = raster(ImageName)
        extend(Image, EnlargeExtent, filename=file.path(output_dir, basename(ImageName)),
            options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), datatype="INT2S")
    }
}
