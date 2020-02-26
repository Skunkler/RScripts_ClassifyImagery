require(raster)
require(doParallel)
require(foreach)

UseCores <- 3

cl <- makeCluster(UseCores)
registerDoParallel(cl)

path <- "D:/Clark_County_2017_ImageClassification_Project/Books_123124__needing_8Band"
Opath <- "D:/Clark_County_2017_ImageClassification_Project/Eight_band_stacks/"

stack_list <- list.files(path, pattern = ".tif", full.names = T)

OutFile.names <- dir(path, pattern = ".tif")


foreach(i=1:length(stack_list), .packages="raster") %dopar%{
  library(rgdal)
  library(glcm)
  
  rasterFileIn <- brick(stack_list[i])
  textureVar <- glcm(rasterFileIn[[4]], window = c(7,7), shift=c(2,2), statistics = 'second_moment')
  
  
  print("calculating Mean Green")
  textureVar2 <- glcm(rasterFileIn[[2]], window = c(7,7), shift=c(2,2), statistics = 'mean')
  print("calculating mean NIR")
  textureVar3 <- glcm(rasterFileIn[[4]], window = c(7,7), shift=c(2,2), statistics = 'mean')
  
  print("NDVI")
  NDVI <- ((rasterFileIn[[4]] - rasterFileIn[[1]] )/(rasterFileIn[[4]] + rasterFileIn[[1]])  )
  
  rasList <- c(rasterFileIn, NDVI, textureVar2, textureVar3, textureVar)
  
  ImageFileOutput <- stack(rasList)
  print("outputting final raster")
  
  OutFile <- toString(OutFile.names[i])
  OutputComplete <- paste(Opath, OutFile, sep="")
  writeRaster(ImageFileOutput, OutputComplete, format="GTiff", overwrite = TRUE )
  
}

stopCluster(cl)