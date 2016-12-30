## Created by Jessica Nephin
## Last edited 2016-11-25

# Masks input raster using clipped to coastline BoP layer
# Exports raster with appropriate data type to limit storage space

# required packages
require(parallel)

# working directory
setwd('..')



####----------------------------------------------------------------------####
## Function

## Masks env.layers and exports tiff with chosen datatype
maskfun <- function(rasterfile){
  # packages
  require(raster)
  require(rgdal)
  # load mosaiced raster
  ras <- raster(rasterfile)
  # output filename
  outc <- sub("Mosaics/Original","Mosaics/Cropped", rasterfile)
  outm <- sub("Mosaics/Original","Mosaics/Masked", rasterfile)
  # name of region
  regname <- sub("[_].*","",rasterfile)
  regname <- sub(".*/","",regname)
  # set ful proj string
  proj4string(ras) <- proj
  # load region polygons
  reg <- readOGR(dsn = "C:/Users/NephinJ/Documents/Projects/Spatial/EEZ", layer = "Regions_alb")
  # Crop - crop raster to spatial extent of region
  eras <- raster::crop(ras, extent(reg[reg$Name == regname,]), filename=outc, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
  # Mask - assigns NA values outside of region polygon
  mras <- raster::mask(eras, reg[reg$Name == regname,], filename=outm, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
}
####----------------------------------------------------------------------####



####----------------------------------------------------------------------####
# Variables

#full bc albers proj
proj <- "+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

# list mosaiced rasters
ras.list <- list.files(path="Mosaics/Original",pattern=".tif$", full.names = TRUE)

####----------------------------------------------------------------------####




####----------------------------------------------------------------------####
# Run in parallel

## create cluster object 
num_cores <- detectCores() - 2
cl <- makeCluster(num_cores)

## make variables and packages available to cluster
clusterExport(cl, varlist="proj")

# apply function over clusters for thiessen interp layers
parSapply(cl, ras.list, FUN=maskfun)

## stop cluster
stopCluster(cl)

