## Created by Jessica Nephin
## Last edited 2017-01-09

# Crops and mask mosaics using region polygons

# required packages
require(parallel)

# working directory
setwd('..')



####----------------------------------------------------------------------####
## Function

## Crop and Mask env.layers and exports tiff
maskfun <- function(rasterfile){
  # packages
  require(raster)
  require(rgdal)
  # load mosaiced raster
  ras <- raster(rasterfile)
  # output filenames
  outc <- sub("Mosaics/Original","Mosaics/Cropped", rasterfile)
  outm <- sub("Mosaics/Original","Mosaics/Masked", rasterfile)
  # name of region
  regname <- sub("[_].*","",rasterfile)
  regname <- sub(".*/","",regname)
  # set ful proj string
  proj4string(ras) <- proj
  # load region polygons
  reg <- readOGR(dsn = "Boundary", layer = "MultibeamGridDis")
  # names of each region layer
  reg$Name <- paste0("area",reg$ID)
  # reg extents
  ext <- extent(reg[reg$Name == regname,])
  # Crop - crop raster to spatial extent of region
  cras <- raster::crop(ras, ext, filename=outc, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
  # Mask - assigns NA values outside of region polygon
  rasmask <- rasterize(reg[reg$Name == regname,], cras, mask=TRUE, filename=outm, overwrite=TRUE,
                       format = "GTiff", datatype = "FLT4S")
}

####----------------------------------------------------------------------####



####----------------------------------------------------------------------####
# Variables

#full bc albers proj
proj <- "+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

# list mosaiced rasters
ras.list <- list.files(path="Mosaics/Original",pattern="5m.tif$", full.names = TRUE)

####----------------------------------------------------------------------####


####----------------------------------------------------------------------####
# Run in parallel

## create cluster object
num_cores <- detectCores() - 1
cl <- makeCluster(num_cores)

## make variables and packages available to cluster
clusterExport(cl, varlist="proj")

# apply function over clusters
parSapply(cl, ras.list, FUN=maskfun)

## stop cluster
stopCluster(cl)
