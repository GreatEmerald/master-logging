# Quick script for cropping full tiles to a common extent
library(raster)
library(foreach)
library(doParallel)
library(tools)
rasterOptions(tmpdir="/userdata2/tmp/")

FilesToCrop = list.files("../data/intermediary/cloud-free/Guyana2014/ndvi",
    pattern=glob2rx("*.tif"), full.names = TRUE)
OutputDir = "../data/intermediary/cloud-free/Guyana2014b/ndvi"
for (i in 1:length(FilesToCrop))
{
    Image = raster(FilesToCrop[i])
    if (!exists("Extents")){
        Extents = as.numeric(bbox(Image))
    }else
        Extents = rbind(Extents, as.numeric(bbox(Image)))
}
rm(Image)
colnames(Extents) = c("xmin", "ymin", "xmax", "ymax")
rownames(Extents) = NULL
EnlargeExtent = extent(min(Extents[,"xmin"]), max(Extents[,"xmax"]),
    min(Extents[,"ymin"]), max(Extents[,"ymax"]))

Threads = 10#detectCores()-1
psnice(value = min(Threads - 1, 19))
registerDoParallel(cores = Threads)
foreach(i=1:length(FilesToCrop), .inorder = FALSE, .packages = "raster", .verbose=TRUE) %dopar%
{
    ImageName = FilesToCrop[i]
    print(paste("Processing:", ImageName))
    Image = raster(ImageName)
    extend(Image, EnlargeExtent, filename=paste0(OutputDir, "/", basename(ImageName)),
        options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), datatype="INT2S")
}
