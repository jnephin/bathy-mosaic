## Reclass rasters to convert to positive values only

# required packages
require(parallel)

# working directory
setwd('..')

#--------------------------------------------------#


####----------------------------------------------------------------------####
## Functions

## Change raster values to absolute, assign NA value and export tif
rasterAbs <- function(rasterfile){
  # packages
  require(raster)
  require(rgdal)
  # load input raster
  ras <- raster(rasterfile)
  # assign correct NA value
  NAvalue(ras) <- -4.076491e+14
  # output filename
  outf <- sub(".tif","_abs.tif",rasterfile)
  # Set values to absolute values
  aras <- raster::calc(ras, fun=abs, filename=outf, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
}
####----------------------------------------------------------------------####


# list rasters
rlist <-list.files(path="Rasters",pattern="*.tif$",full.names = TRUE)


## create cluster object 
num_cores <- detectCores()
cl <- makeCluster(num_cores)

# apply function across list
parSapply(cl, rlist, FUN=rasterAbs)

## stop cluster
stopCluster(cl)



