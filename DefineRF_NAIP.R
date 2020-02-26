require(raster)
require(rgdal)
require(randomForest)

image <- brick("D:/colorBalance_Tests/test_stack/o16331_se_old.tif")

trainData <- readOGR("D:/colorBalance_Tests/samples/o16331_samples.shp", "o16331_samples")

roi_Data <- extract(image, trainData, df=TRUE)

roi_Data$desc <- as.factor(trainData$vegField[roi_Data$ID])

colnames(roi_Data) <- c('ID', 'b1', 'b2', 'b3', 'b4','b5', 'b6', 'b7', 'b8', 'desc')

write.csv(roi_Data, 'D:/colorBalance_Tests/Training_old.csv')

intable <- read.csv('D:/colorBalance_Tests/Training_old.csv')

myrf <- randomForest(desc ~ b1+b2+b3+b4+b5+b6+b7+b8, data = intable, keep.forest = TRUE, importance = TRUE)

print(myrf)

saveRDS(myrf, 'D:/colorBalance_Tests/RM_modelOld.rds')
