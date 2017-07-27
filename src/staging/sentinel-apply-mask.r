# Apply the scene classification mask to Sentinel-2 imagery

library(raster)
library(foreach)
library(doParallel)

# Applies a mask to a single granule
S2ApplyMaskToGranule = function(path, output_dir)
{
    path="/run/media/dainius/Landsat/Guyana2017/sentinel2/S2A_USER_PRD_MSIL2A_PDMC_20151223T201036_R053_V20151223T143139_20151223T143139.SAFE/GRANULE/S2A_USER_MSI_L2A_TL_SGS__20151223T165401_A002624_T20NQK_N02.01/"
    output_dir="/run/media/dainius/Landsat/Guyana2017/sentinel2/20151223"
    # NOTE: These are paranoid values. You might want to exclude 2 (dark areas, usually cloud shadows though) and 7 (low probability that it's cloud)
    mask_values=c(0:3, 7:10)
    
    ID = file.path(path, "IMG_DATA")
    MaskFile = list.files(ID, pattern=glob2rx("*SCL_L2A*20m.jp2"), full.names=TRUE)
    Mask = raster(MaskFile)
    Mask10 = disaggregate(Mask, 2)
    spplot(Mask)
    
    masker = function(x, y)
    {
        x[y %in% mask_values] <- NA
        return(x)
    }
    
    # NOTE: Needs 2.1 GiB RAM per thread of 20m, 5.6 GiB per thread of 10m
    rasterOptions(chunksize=1e+08, maxmemory=1e+09)
    registerDoParallel(1)
    
    # Function for handling any size, run for 20 and then 10m resolution files; size is string
    MaskGranuleWithSize=function(size)
    {
        size = as.character(size)
        if (size == "10")
            CurrentMask = Mask10
        else
            CurrentMask = Mask
        
        Bands = list.files(ID, pattern=glob2rx(paste0("S2A_USER_MSI_L2A_*_B??_", size, "m.jp2")), full.names=TRUE, recursive=TRUE)
        OutputDir = file.path(output_dir, paste0("R", size, "m"))
        if (!file.exists(OutputDir))
            dir.create(OutputDir, recursive=TRUE)
        
        foreach(BandFile=iter(Bands), .inorder=FALSE, .packages="raster", .verbose=TRUE) %dopar%
        {
            Band = raster(BandFile)
            OutputFile = sub("0m.jp2", "0m.tif", file.path(OutputDir, basename(BandFile)))
            MaskedBand = overlay(Band, CurrentMask, fun=masker, filename=OutputFile, datatype="INT2U",
                options=c("COMPRESS=DEFLATE", "ZLEVEL=9", "SPARSE_OK=TRUE"), progress="text")
        }
    }
    MaskGranuleWithSize("20")
    MaskGranuleWithSize("10")
}

S2ApplyMaskToGranule("", "")
