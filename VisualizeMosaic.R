require(raster)
require(rgdal)
require(sp)

# load coastline
reg <- readOGR(dsn = "C:/Users/NephinJ/Documents/Projects/Spatial/EEZ", layer = "Regions_alb")

# mosaics
mosaic <- c("NWCVI_5m.tif","QCStr_5m.tif","SWCVI_5m.tif","JDF_5m.tif","SSoG_5m.tif","DE_5m.tif","CSoG_5m.tif",
            "NSoG_5m.tif","WHG_5m.tif","WQCS_5m.tif","NHS_5m.tif","EQCS_5m.tif","SHS_5m.tif","CWCVI_5m.tif")


# load rasters
ras <- raster("F:/Bathymetry_Multibeam/Mosaics/Original/CSoG_5m.tif")
#ras <- raster("F:/Bathymetry_Multibeam/Mosaics/CSoG_5m.tif")
ras
plot(ras)

# values
NAvalue(ras)
sam <- sampleRandom(ras, 10000)
quantile(sam)

# plot with region
plot(ras)
plot(reg[reg$Name == "CSoG",], add=T)

# test mask
outf <- "F:/Bathymetry_Multibeam/Mosaics/CSoG_5m_masked.tif"
raster::mask(ras, reg[reg$Name == "CSoG",], filename=outf, 
             overwrite=TRUE, format = "GTiff", datatype = "FLT4S")

mras <- raster("F:/Bathymetry_Multibeam/Mosaics/CSoG_5m_masked.tif")
