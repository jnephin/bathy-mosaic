require(raster)
require(rgdal)
require(sp)

# load coastline
reg <- readOGR(dsn = "C:/Users/NephinJ/Documents/Projects/Spatial/EEZ", layer = "Regions_alb")

# load rasters
ras <- raster("F:/Bathymetry_Multibeam/Mosaics/CWCVI_5m.tif")
ras
plot(ras)
plot(reg, add=T)


NAvalue(warp) <- -3.4e+038
NAvalue(mer) <- -999
vals <- getValues(mer)

writeRaster(mer, filename="F:/Bathymetry_Multibeam/Mosaics/test_merge2.tif", 
            overwrite=TRUE, format = "GTiff", datatype = "FLT4S")


plot(ras)
plot(reg[reg$Name == "DE",], add=T)





test <- raster("F:/Bathymetry_Multibeam/Rasters/s5026057_2004_SouthMalaspina_2mZ10N_ra_alb_abs_5m_proj.tif")
test
plot(test)


sam <- sampleRandom(mer, 10000)
quantile(sam)
