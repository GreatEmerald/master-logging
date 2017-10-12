# Pansharpening test

library(satellite)

NIR = raster("../../userdata/master-logging/sentinel/21NUE/S2A_MSIL2A_20170712T142041_N0205_R010_T21NUE_20170712T142037.SAFE/GRANULE/L2A_T21NUE_A010732_20170712T142037/IMG_DATA/R10m/L2A_T21NUE_20170712T142041_B08_10m.jp2")
SWIR = raster("../../userdata/master-logging/sentinel/21NUE/S2A_MSIL2A_20170712T142041_N0205_R010_T21NUE_20170712T142037.SAFE/GRANULE/L2A_T21NUE_A010732_20170712T142037/IMG_DATA/R20m/L2A_T21NUE_20170712T142041_B11_20m.jp2")

# Pansharpen SWIR with NIR
SharpSWIR = panSharp(SWIR, NIR, datatype="INT2U", filename="../../userdata/tmp/pansharpened.tif", progress="text")
# Works, but with artefacts
