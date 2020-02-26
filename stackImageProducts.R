require(raster)
require(rgdal)

rasterFileIn = brick("D:/NAIP/Wambolt_NorthBig_Springs2010/38114f6se.tif")


NDVI <- ((rasterFileIn[[4]] - rasterFileIn[[1]] )/(rasterFileIn[[4]] + rasterFileIn[[1]])  )
NDWI <- ((rasterFileIn[[2]] - rasterFileIn[[4]])/(rasterFileIn[[2]] + rasterFileIn[[4]]))



rasList <- c(rasterFileIn, NDVI, NDWI)

ImageFileOutput <- stack(rasList)

writeRaster(ImageFileOutput, "D:/NAIP/Wambolt_NorthBig_Springs2010/stack/38114f6se.tif")
