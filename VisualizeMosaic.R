require(raster)
require(rgdal)
require(sp)

# load coastline
reg <- readOGR(dsn = "C:/Users/NephinJ/Documents/Projects/Spatial/EEZ", layer = "Regions_alb")

# mosaics
mosaic <- c("NWCVI_5m.tif","QCStr_5m.tif","SWCVI_5m.tif","JDF_5m.tif","SSoG_5m.tif","DE_5m.tif","CSoG_5m.tif",
            "NSoG_5m.tif","WHG_5m.tif","WQCS_5m.tif","NHS_5m.tif","EQCS_5m.tif","SHS_5m.tif","CWCVI_5m.tif")


# load rasters
ras <- raster(paste0("F:/Bathymetry_Multibeam/Mosaics/", mosaic[5]))
ras
plot(ras)
#plot(reg, add=T)


NAvalue(warp) <- -3.4e+038
NAvalue(mer) <- -999
vals <- getValues(mer)


plot(ras)
plot(reg[reg$Name == "JDF",], add=T)


sam <- sampleRandom(mer, 10000)
quantile(sam)


writeRaster(mer, filename="F:/Bathymetry_Multibeam/Mosaics/test.tif", 
            overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
