## Add correct proj string to rasters 5m rasters

# required packages
require(parallel)

# working directory
setwd('..')

#--------------------------------------------------#



####----------------------------------------------------------------------####
## Function

## Assign raster CRS
rasterProj <- function(rasterfile){
  # packages
  require(raster)
  require(rgdal)
  # load input raster
  ras <- raster(rasterfile)
  # assign correct CRS
  proj4string(ras) <- proj
  # output filename
  outf <- sub(".tif","_proj.tif",rasterfile)
  # write raster to file
  raster::writeRaster(ras,filename=outf, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
}
####----------------------------------------------------------------------####


# list rasters
rlist <-list.files(path="Rasters",pattern="*5m.tif$",full.names = TRUE)

#full bc albers proj
proj <- "+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"


## create cluster object 
num_cores <- detectCores()
cl <- makeCluster(num_cores)

## make variables and packages available to cluster
clusterExport(cl, varlist="proj")

# apply function across list
parSapply(cl, rlist, FUN=rasterProj)

## stop cluster
stopCluster(cl)



